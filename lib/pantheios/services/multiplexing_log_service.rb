
# ######################################################################## #
# File:         lib/pantheios/services/multiplexing_log_service.rb
#
# Purpose:      Definition of the
#               ::Pantheios::Services::MultiplexingLogService class
#
# Created:      14th June 2015
# Updated:      4th June 2020
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2019-2020, Matthew Wilson and Synesis Information Systems
# Copyright (c) 2015-2018, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################## #


=begin
=end

module Pantheios
module Services

# A class that fulfils the Pantheios *LogService* protocol by multiplexing
# its responsibilities to a number of (concrete) log service instances
#
# NOTE: The *LogService* protocol is implemented by a class that provides
# the instance methods +severity_logged?(severity : Object) : boolean+ and
# +log(severity : Object, t : Time, prefix : String|Array, msg : String)+
class MultiplexingLogService

	# @!visibility private
	module MultiplexingLogService_Internals_ # :nodoc: all

		class ServiceManagementInfo

			def initialize svc

				@service	=	svc
			end

			attr_reader	:service
		end
	end

	# Initializes the instance with an array of log services, according to
	# the given options
	#
	# ===Signature
	#
	# * *Parameters:*
	#   - +services+:: [ ::Array ] An array of instances that observe the
	#     Log Service protocol
	#   - +options+:: [ ::Hash] options
	#
	# * *Options:*
	#   - +:level_cache_mode+:: [ ::Symbol ] Specifies the mode of severity
	#     level caching, and must be one of the following values:
	#     * +:none+:: no severity level caching is performed. This is the
	#       default because it is completely thread-safe, but it is the
	#       slowest mode, and users are advised to specify another mode
	#       suitable to their use
	#     * +:thread_fixed+:: remembers the response of each multiplexed log
	#       service to each severity level on a thread-specific basis
	#     * +:process_fixed+:: remembers the response of each multiplexed
	#       log service to each severity level and then remembers that for
	#       the duration of the lifetime of the instance
	#   - +:unsync_process_lcm+:: [ boolean ] If truey, causes
	#     +:process_fixed+ +:level_cache_mode+ to NOT be synchronised; the
	#     default is for it to be synchronised using an internal +Mutex+
	#     instance
	def initialize services, **options

		@tss_sym	=	self.to_s.to_sym
		@services	=	services.map { |svc| MultiplexingLogService_Internals_::ServiceManagementInfo.new svc }
		@options	=	options.dup
		@mode		=	options[:level_cache_mode]
		@unsync_pf	=	options[:unsync_process_lcm]

		@process_m	=	{}
		@mx			=	Mutex.new unless @unsync_pf
	end

	private

	# { svc => { sev => flag } }
	def get_tss_svc_sev_map_

		sym	=	@tss_sym
		tc	=	Thread.current
		m	=	tc.thread_variable_get sym

		unless m

			tc.thread_variable_set sym, (m = {})
		end

		m
	end

	def svc_sev_logged_tf_ m, svc, severity

		m[svc.object_id]	||=	{}

		unless m[svc.object_id].has_key? severity

			r = svc.severity_logged? severity

			m[svc.object_id][severity] = r
		else

			r = m[svc.object_id][severity]
		end

		r
	end

	def svc_sev_logged_pf_ m, svc, severity

		m[svc.object_id]	||=	{}

		unless m[svc.object_id].has_key? severity

			r = svc.severity_logged? severity

			m[svc.object_id][severity] = r
		else

			r = m[svc.object_id][severity]
		end

		r
	end

	def sev_logged_pf_ m, severity

		@services.any? { |smi| svc_sev_logged_pf_ m, smi.service, severity }
	end
	public

	# Indicates whether any of the services require a prefix and, if so,
	# what it may require
	#
	# === Return
	# (+false+, +true+, +:parts+) An indicator what the most needy of the
	# multiplexed services requires
	def requires_prefix?

		return @requires_prefix unless @requires_prefix.nil?

		requires_prefix = false

		@services.each do |svc|

			if svc.respond_to? :requires_prefix?

				case rp = svc.requires_prefix?
				when nil, false

					;
				when true

					requires_prefix ||= true
				when :parts

					requires_prefix = rp
					break
				else

					warn "unrecognised return from requires_prefix? for service #{svc}: #{rp} (#{rp.class})"
				end
			end
		end

		@requires_prefix = requires_prefix
	end

	# Indicates whether the given severity is to be logged by any of the
	# multiplexed log services
	def severity_logged? severity

		case @mode
		when :process_fixed

			if @unsync_pf

				sev_logged_pf_ @process_m, severity
			else

				@mx.synchronize { sev_logged_pf_ @process_m, severity }
			end
		when :thread_fixed

			m	=	get_tss_svc_sev_map_

			@services.any? do |smi|

				svc	=	smi.service

				svc_sev_logged_tf_ m, svc, severity
			end
		else # :none

			@services.any? { |smi| smi.service.severity_logged? severity }
		end
	end

	def log sev, t, pref, msg

		tss_m	=	:thread_fixed == @mode ? get_tss_svc_sev_map_ : nil

		@services.each do |smi|

			svc	=	smi.service

			case @mode
			when :process_fixed

				if @unsync_pf

					isl	=	svc_sev_logged_pf_ @process_m, svc, sev
				else

					isl	=	@mx.synchronize { svc_sev_logged_pf_ @process_m, svc, sev }
				end
			when :thread_fixed

				m	=	tss_m

				isl	=	svc_sev_logged_tf_ m, svc, sev
			else # :none

				isl	=	svc.severity_logged? sev
			end


			svc.log sev, t, pref, msg if isl
		end
	end
end

end # module Services
end # module Pantheios

# ############################## end of file ############################# #


