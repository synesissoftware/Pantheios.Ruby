
# ######################################################################## #
# File:         lib/libclimate/climate.rb
#
# Purpose:      Definition of the ::LibCLImate::Climate class
#
# Created:      13th July 2015
# Updated:      11th June 2016
#
# Home:         http://github.com/synesissoftware/libCLImate.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2015-2016, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
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


require 'clasp'
require 'xqsr3/extensions/io'

if !defined? Colcon

	begin

		require 'colcon'
	rescue LoadError => x

		warn "could not load colcon library" if $DEBUG
	end
end

module LibCLImate

class Climate

  private
	def show_usage_

		options	=	{}
		options.merge! stream: stdout, program_name: program_name, version: version, exit: exit_on_usage ? 0 : nil
		options[:info_lines] = info_lines if info_lines
		options[:values] = usage_values if usage_values

		CLASP.show_usage aliases, options
	end

	def show_version_

		CLASP.show_version aliases, stream: stdout, program_name: program_name, version: version, exit: exit_on_usage ? 0 : nil
	end

  public
	def initialize(options={})

		options ||=	{}

		program_name = File.basename($0)
		program_name = (program_name =~ /\.rb$/) ? "#$`(#$&)" : program_name

		if defined? Colcon

			program_name = "#{::Colcon::Decorations::Bold}#{program_name}#{::Colcon::Decorations::Unbold}"
		end

		@aliases			=	[]
		@exit_on_unknown	=	true
		@exit_on_usage		=	true
		@info_lines			=	nil
		@program_name		=	program_name
		@stdout				=	$stdout
		@stderr				=	$stderr
		@usage_values		=	usage_values
		@version			=	[]

		@aliases << CLASP::Flag.Help(handle: proc { show_usage_ }) unless options[:no_help_flag]
		@aliases << CLASP::Flag.Version(handle: proc { show_version_ }) unless options[:no_version_flag]

		raise ArgumentError, "block is required" unless block_given?

		yield self
	end

	attr_accessor :aliases
	attr_accessor :exit_on_unknown
	attr_accessor :exit_on_usage
	attr_accessor :info_lines
	attr_accessor :program_name
	attr_accessor :stdout
	attr_accessor :stderr
	attr_accessor :usage_values
	attr_accessor :version

	def run argv = ARGV

		raise ArgumentError, "argv may not be nil" if argv.nil?

		arguments	=	CLASP::Arguments.new argv, aliases
		flags		=	arguments.flags
		options		=	arguments.options
		values		=	arguments.values.to_a

		results		=	{

			flags: {

				given:		flags,
				handled:	[],
				unhandled:	[],
				unknown:	[]
			},

			options: {

				given:		options,
				handled:	[],
				unhandled:	[],
				unknown:	[]
			},

			values:	values
		}

		flags.each do |f|

			al = aliases.detect do |a|

				a.kind_of?(::CLASP::Flag) && f.name == a.name
			end

			if al

				selector	=	:unhandled

				ex = f.extras

				case f.extras
				when ::Hash
					if f.extras.has_key? :handle

						f.extras[:handle].call(f, al)

						selector = :handled
					end
				end

				results[:flags][selector] << f
			else

				message = "#{program_name}: unrecognised flag '#{f}'; use --help for usage"

				if exit_on_unknown

					abort message
				else

					stderr.puts message
				end

				results[:flags][:unknown] << f
			end
		end

		options.each do |o|

			al = aliases.detect do |a|

				a.kind_of?(::CLASP::Option) && o.name == a.name
			end

			if al

				selector	=	:unhandled

				ex = al.extras

				case ex
				when ::Hash
					if ex.has_key? :handle

						ex[:handle].call(o, al)

						selector = :handled
					end
				end

				results[:options][selector] << o
			else

				message = "#{program_name}: unrecognised option '#{o}'; use --help for usage"

				if exit_on_unknown

					abort message
				else

					stderr.puts message
				end

				results[:options][:unknown] << o
			end
		end

		def results.flags

			self[:flags]
		end

		def results.options

			self[:options]
		end

		def results.values

			self[:values]
		end

		results
	end
end # class Climate

end # module LibCLImate

# ############################## end of file ############################# #


