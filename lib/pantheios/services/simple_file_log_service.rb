
# ######################################################################## #
# File:         lib/pantheios/services/simple_file_log_service.rb
#
# Purpose:      Definition of the
#               ::Pantheios::Services::SimpleFileLogService class
#
# Created:      17th June 2015
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


require 'pantheios/application_layer/stock_severity_levels'

require 'logger'

=begin
=end

module Pantheios
module Services

# A class that fulfils the Pantheios *LogService* protocol that allows all
# severities and logs to a file
#
# NOTE: The *LogService* protocol is implemented by a class that provides
# the instance methods +severity_logged?(severity : Object) : boolean+ and
# +log(severity : Object, t : Time, prefix : String|Array, msg : String)+
class SimpleFileLogService

	module SimpleFileLogService_Constants

		DEFAULT_ROLL_DEPTH		=	7
		DEFAULT_ROLL_SIZE		=	1024 * 1024

		RECOGNISED_OPTIONS		=	%w{ roll_depth roll_period roll_size }.map { |s| s.to_sym }

	end # module SimpleFileLogService_Constants

	#
	# === Signature
	#
	# * *Parameters:*
	#   - +log_file_or_path+:: [ +::File+, +::IO+, +::String+ ] A file or an
	#     IO that will be used as the target of the log statements, or a
	#     string specifying the path of the file to be used as the target
	#   - +options+:: [ ::Hash ] Options. Options other than those listed
	#     are ignored silently (except if +$DEBUG+, in which case a
	#     +warn+ing will be issued)
	#
	# * *Options:*
	#   - +:roll_period+:: ( +:daily+, +:weekly+, +:monthly+ ) The
	#     periodicity of the log-file rolling. Ignored unless
	#     +log_file_or_path+ is a +::String+. Ignored if either +:roll_size+
	#     or +:roll_depth+ is specified
	#   - +:roll_size+:: [ ::Integer, [ ::Integer, ::Integer ] ] An integer
	#     specifying the size of the log file, or an array containing the
	#     size of the log file and the depth of the log roll
	#   - +:roll_depth+:: [ ::Integer ] The depth of the size-based log
	#     rolling. Overrides the second element in an array specified for
	#     +:roll_size+ 


	def initialize log_file_or_path, **options

		roll_period	=	options[:roll_period]
		roll_size	=	options[:roll_size]
		roll_depth	=	options[:roll_depth]

		if $DEBUG

			options.each do |k, v|

				warn "#{self.class}##{__method__}(): ignoring unrecognised option '#{k}'" unless SimpleFileLogService_Constants::RECOGNISED_OPTIONS.include?(:k)
			end
		end

		if roll_period && (roll_size || roll_depth)

			warn "#{self.class}##{__method__}(): caller specified :roll_depth/:roll_period with :roll_size to #{self.class}##{__method__}() - ignoring :roll_period" if $DEBUG

			roll_period = nil
		end

		if roll_size || roll_depth

			if ::Array === roll_size

				roll_size, d	=	roll_size

				roll_depth		||=	d
			end

			roll_size	||=	SimpleFileLogService_Constants::DEFAULT_ROLL_SIZE
			roll_depth	||=	SimpleFileLogService_Constants::DEFAULT_ROLL_DEPTH
		end

		logger_init_args	=	[]
		logger_init_options	=	{}

		if false;
		elsif roll_depth

			logger_init_args	<<	roll_depth
			logger_init_args	<<	roll_size
		elsif roll_period

			roll_period = roll_period.downcase.to_sym if ::String === roll_period

			case roll_period
			when :daily, :weekly, :monthly

				;
			else

				raise ArgumentError, ":roll_period value must be one of :daily, :weekly, :monthly"
			end

			logger_init_args	<<	roll_period.to_s
			logger_init_args	<<	0
		end

		raise ArgumentError, ":roll_depth must be a non-negative integer" unless roll_depth.nil? || (::Integer === roll_depth && roll_depth >= 0)
		raise ArgumentError, ":roll_size must be a non-negative integer" unless roll_size.nil? || (::Integer === roll_size && roll_size >= 0)

		file_proc = lambda do

			@logger			=	::Logger.new log_file_or_path, *logger_init_args
			@log_file_path	=	log_file_or_path.path
		end

		io_proc = lambda do

			@logger			=	::Logger.new log_file_or_path, *logger_init_args
			@log_file_path	=	log_file_or_path.respond_to?(:path) ? log_file_or_path.path : nil
		end

		case log_file_or_path
		when nil

			raise ArgumentError, 'log_file_or_path may not be nil'
		when ::IO#, ::StringIO

			io_proc.call
		when ::File#, ::Tempfile

			file_proc.call
		when ::String

			@logger			=	::Logger.new log_file_or_path, *logger_init_args
			@log_file_path	=	log_file_or_path
		else

			ancestor_names	=	log_file_or_path.class.ancestors.map(&:to_s)

			if false

				;
			elsif ancestor_names.include?('StringIO')

				io_proc.call
			elsif ancestor_names.include?('Tempfile')

				file_proc.call
			else

				raise TypeError, "log_file_or_path type must be one of #{::File}, #{::IO}, #{::String}, #{::StringIO}"
			end
		end

		self
	end

	# The path of the underlying log file. May return +nil+ if the path
	# cannot be determined
	attr_reader	:log_file_path

	def severity_logged? severity

		true
	end

	def log sev, t, pref, msg

		@logger << "#{pref}#{msg}\n"
	end
end


end # module Services
end # module Pantheios

# ############################## end of file ############################# #


