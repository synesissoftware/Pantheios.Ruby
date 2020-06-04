
# ######################################################################## #
# File:         lib/pantheios/services/coloured_console_log_service.rb
#
# Purpose:      Definition of the
#               ::Pantheios::Services::ColouredConsoleLogService class
#
# Created:      19th June 2019
# Updated:      4th June 2020
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2019-2020, Matthew Wilson and Synesis Information Systems
# Copyright (c) 2019, Matthew Wilson and Synesis Software
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


require 'pantheios/services/common/console'

=begin
=end

module Pantheios
module Services

# A class that fulfils the Pantheios *LogService* protocol that allows all
# severities and logs to the console (via +$stdout+ and +$stderr+)
#
# NOTE: The *LogService* protocol is implemented by a class that provides
# the instance methods +severity_logged?(severity : Object) : boolean+ and
# +log(severity : Object, t : Time, prefix : String|Array, msg : String)+
class ColouredConsoleLogService

	module Constants

		include ::Pantheios::Services::Common::Console::AnsiEscapeSequences
	end # module Constants

	def self.requires_prefix?

		return @requires_prefix unless @requires_prefix.nil?

		@requires_prefix = ::Pantheios::Services::Common::Console::Internal_::SHOULD_COLOURIZE_ ? :parts : false
	end

	def requires_prefix?

		self.class.requires_prefix?
	end

	def severity_logged? severity

		true
	end

	def log sev, t, pref, msg

		stm = infer_stream sev

		if requires_prefix?

			pref = pref.map do |part|

				bg	=	Constants::Background
				fg	=	Constants::Foreground

				if part.respond_to?(:severity)

					part = fg.bold part

					case sev
					when :violation

						part = bg.red part
						#part = fg.bright_magenta part
						part = fg.bright_yellow part
						part = fg.blinking part
					when :alert

						part = bg.red part
						part = fg.bright_cyan part
						part = fg.blinking part
					when :critical

						part = bg.red part
						part = fg.white part
					when :failure

						part = bg.yellow part
						part = fg.red part
					when :warning

						part = bg.yellow part
						part = fg.blue part
					when :notice

						part = bg.dark_grey part
						part = fg.white part
					when :informational

						part = bg.dark_grey part
						part = fg.light_grey part
					when :debug0

						part = bg.blue part
						part = fg.light_grey part
					when :debug1

						part = bg.blue part
						part = fg.light_grey part
					when :debug2

						part = bg.blue part
						part = fg.light_grey part
					when :debug3

						part = bg.blue part
						part = fg.light_grey part
					when :debug4

						part = bg.blue part
						part = fg.light_grey part
					when :debug5

						part = bg.blue part
						part = fg.light_grey part
					when :trace

						part = bg.blue part
						part = fg.light_grey part
					when :benchmark

						part = bg.black part
						part = fg.light_grey part
					else

						;
					end
				else

					part = fg.dark_grey part
				end

				part
			end.join(', ')

			pref = '[' + pref + ']: '

			#pref = pref.map { |pp| pp.severity? ? map_sev_(sev) : sev }.join(
		end

		stm.puts "#{pref}#{msg}"
	end

	# Overrideable method that determines which stream to write, based on a
	# severity. This implementation always returns +$stderr+
	#
	# Overrides must return an object that supports the +puts(String)+
	# method
	def infer_stream sev

		$stderr
	end

	private
end # class ColouredConsoleLogService

end # module Services
end # module Pantheios

# ############################## end of file ############################# #


