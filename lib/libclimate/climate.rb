
# ######################################################################## #
# File:         lib/libclimate/climate.rb
#
# Purpose:      Definition of the ::LibCLImate::Climate class
#
# Created:      13th July 2015
# Updated:      9th June 2017
#
# Home:         http://github.com/synesissoftware/libCLImate.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2015-2017, Matthew Wilson and Synesis Software
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
require 'xqsr3/quality/parameter_checking'

=begin
=end

if !defined? Colcon

	begin

		require 'colcon'
	rescue LoadError #=> x

		warn "could not load colcon library" if $DEBUG
	end
end

#:stopdoc:

# We monkey-patch CLASP module's Flag and Option generator methods by
# added in a 'action' attribute (but only if it does not exist)
# and attaching the given block

class << CLASP

	alias_method :Flag_old, :Flag
	alias_method :Option_old, :Option

	def Flag(name, options={}, &blk)

		f = self.Flag_old(name, options)

		# anticipate this functionality being added to CLASP
		return f if f.respond_to? :action

		class << f

			attr_accessor :action
		end

		if blk

			case blk.arity
			when 0, 1, 2
			else

				warn "wrong arity for flag"
			end

			f.action = blk
		end

		f
	end

	def Option(name, options={}, &blk)

		o = self.Option_old(name, options)

		# anticipate this functionality being added to CLASP
		return o if o.respond_to? :action

		class << o

			attr_accessor :action
		end

		if blk

			case blk.arity
			when 0, 1, 2
			else

				warn "wrong arity for option"
			end

			o.action = blk
		end

		o
	end
end

#:startdoc:


module LibCLImate

# Class used to gather together the CLI specification, and execute it
#
#
#
class Climate

	#:stopdoc:

	private
	def show_usage_

		options	=	{}
		options.merge! stream: stdout, program_name: program_name, version: version, exit: exit_on_usage ? 0 : nil
		options[:info_lines] = info_lines if info_lines
		options[:values] = usage_values if usage_values

		CLASP.show_usage aliases, options
	end

	def show_version_

		ver = version || []

		if ver.empty?

			if defined? PROGRAM_VER_MAJOR

				ver << PROGRAM_VER_MAJOR

				if defined? PROGRAM_VER_MINOR

					ver << PROGRAM_VER_MINOR

					if defined? PROGRAM_VER_REVISION

						ver << PROGRAM_VER_REVISION
					end
				end
			end
		end

		CLASP.show_version aliases, stream: stdout, program_name: program_name, version: version, exit: exit_on_usage ? 0 : nil
	end

	#:startdoc:

	public

	# Creates an instance of the Climate class.
	#
	# === Signature
	#
	# * *Parameters*:
	#   - +options:+:: An options hash, containing any of the following options.
	#
	# * *Options*:
	#   - +:no_help_flag+:: Prevents the use of the CLASP::Flag.Help flag-alias
	#   - +:no_version_flag+:: Prevents the use of the CLASP::Version.Help flag-alias
	#
	# * *Block*:: An optional block which receives the constructing instance, allowing the user to modify the attributes.
	def initialize(options={}) # :yields: climate

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

		yield self if block_given?
	end

	# An array of aliases attached to the climate instance, whose contents should be modified by adding (or removing) CLASP aliases
	# @return [Array] The aliases
	attr_reader :aliases
	# Indicates whether exit will be called (with non-zero exit code) when an unknown command-line flag or option is encountered
	# @return [Boolean]
	# @return *true* exit(1) will be called
	# @return *false* exit will not be called
	attr_accessor :exit_on_unknown
	# @return [Boolean] Indicates whether exit will be called (with zero exit code) when usage/version is requested on the command-line
	attr_accessor :exit_on_usage
	# @return [Array] Optional array of string of program-information that will be written before the rest of the usage block when usage is requested on the command-line
	attr_accessor :info_lines
	# @return [String] A program name; defaults to the name of the executing script
	attr_accessor :program_name
	# @return [IO] The output stream for normative output; defaults to $stdout
	attr_accessor :stdout
	# @return [IO] The output stream for contingent output; defaults to $stderr
	attr_accessor :stderr
	# @return [String] Optional string to describe the program values, eg \<xyz "[ { <<directory> | &lt;file> } ]"
	attr_accessor :usage_values
	# @return [String, Array] A version string or an array of integers representing the version components
	attr_accessor :version

	# Executes the prepared Climate instance
	#
	# == Signature
	#
	# * *Parameters*:
	#   - +argv+:: The array of arguments; defaults to <tt>ARGV</tt>
	#
	# * *Returns*:
	#   an instance of a type derived from +::Hash+ with the additional
	#   attributes +flags+, +options+, +values+, and +argv+.
	#
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

				# see if it has a :action attribute (which will have been
				# monkey-patched to CLASP.Flag()

				if al.respond_to?(:action) && !al.action.nil?

					al.action.call(f, al)

					selector = :handled
				else

					ex = al.extras

					case ex
					when ::Hash

						if ex.has_key? :handle

							ex[:handle].call(f, al)

							selector = :handled
						end
					end
				end

				results[:flags][selector] << f
			else

				message = "unrecognised flag '#{f}'; use --help for usage"

				if exit_on_unknown

					self.abort message
				else

					if program_name && !program_name.empty?

						message = "#{program_name}: #{message}"
					end

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

				# see if it has a :action attribute (which will have been
				# monkey-patched to CLASP.Option()

				if al.respond_to?(:action) && !al.action.nil?

					al.action.call(o, al)

					selector = :handled
				else

					ex = al.extras

					case ex
					when ::Hash

						if ex.has_key? :handle

							ex[:handle].call(o, al)

							selector = :handled
						end
					end
				end

				results[:options][selector] << o
			else

				message = "unrecognised option '#{o}'; use --help for usage"

				if exit_on_unknown

					self.abort message
				else

					if program_name && !program_name.empty?

						message = "#{program_name}: #{message}"
					end

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

		results.define_singleton_method(:argv) do

			argv
		end

		results
	end

	# Calls abort() with the given message prefixed by the program_name
	#
	# === Signature
	#
	# * *Parameters*:
	#   - +message+:: The message string
	#   - +options+:: An option hash, containing any of the following options
	#
	# * *Options*:
	#   - +:stream+:: {optional} The output stream to use. Defaults to the value of the attribute +stderr+.
	#   - +:program_name+:: {optional} Uses the given value rather than the +program_name+ attribute; does not prefix if the empty string
	#   - +:exit+:: {optional} The exit code. Defaults to 1. Does not exit if +nil+ specified.
	#
	# * *Return*:
	#   The combined message string, if <tt>exit()</tt> not called.
	def abort message, options={}

		prog_name	=	options[:program_name]
		prog_name	||=	program_name
		prog_name	||=	''

		stream		=	options[:stream]
		stream		||=	stderr
		stream		||=	$stderr

		exit_code	=	options.has_key?(:exit) ? options[:exit] : 1

		if prog_name.empty?

			msg = message
		else

			msg = "#{prog_name}: #{message}"
		end


		stream.puts msg

		exit(exit_code) if exit_code

		msg
	end

	# Adds a flag to +aliases+
	#
	# === Signature
	#
	# * *Parameters*
	#   - +name+:: The flag name
	#   - +options+:: An options hash, containing any of the following options.
	#
	# * *Options*
	#   - +:help+:: 
	#   - +:alias+:: 
	#   - +:aliases+:: 
	#   - +:extras+:: 
	def add_flag(name, options={}, &block)

		::Xqsr3::Quality::ParameterChecking.check_parameter name, 'name', allow_nil: false, types: [ ::String, ::Symbol ]

		aliases << CLASP.Flag(name, **options, &block)
	end

	#
	# * *Options*
	#   - +:alias+:: 
	#   - +:aliases+:: 
	#   - +:help+:: 
	#   - +:values_range+:: 
	#   - +:default_value+:: 
	#   - +:extras+:: 
	def add_option(name, options={}, &block)

		::Xqsr3::Quality::ParameterChecking.check_parameter name, 'name', allow_nil: false, types: [ ::String, ::Symbol ]

		aliases << CLASP.Option(name, **options, &block)
	end

	# Adds a flag to +aliases+
	#
	# === Signature
	#
	# * *Parameters*
	#   - +name+:: The flag/option name or the valued option
	#   - +aliases+:: One or more aliases
	#
	# === Examples
	#
	# ==== Alias(es) of a flag (single statement)
	#
	# +climate.add_flag('--mark-missing', alias: '-x')+
	#
	# +climate.add_flag('--absolute-path', aliases: [ '-abs', '-p' ])+
	#
	# ==== Alias(es) of a flag (multiple statements)
	#
	# +climate.add_flag('--mark-missing')+
	# +climate.add_alias('--mark-missing', '-x')+
	#
	# +climate.add_flag('--absolute-path')+
	# +climate.add_alias('--absolute-path', '-abs', '-p')+
	#
	# ==== Alias(es) of an option (single statement)
	#
	# +climate.add_option('--add-patterns', alias: '-p')+
	#
	# ==== Alias(es) of an option (multiple statements)
	#
	# +climate.add_option('--add-patterns')+
	# +climate.add_alias('--add-patterns', '-p')+
	#
	# ==== Alias of a valued option (which has to be multiple statements)
	#
	# +climate.add_option('--verbosity')+
	# +climate.add_alias('--verbosity=succinct', '-s')+
	# +climate.add_alias('--verbosity=verbose', '-v')+
	def add_alias(name, *aliases)

		::Xqsr3::Quality::ParameterChecking.check_parameter name, 'name', allow_nil: false, types: [ ::String, ::Symbol ]
		raise ArgumentError, "must supply at least one alias" if aliases.empty?

		self.aliases << CLASP.Option(name, aliases: aliases)
	end
end # class Climate

end # module LibCLImate

# ############################## end of file ############################# #


