
module Pantheios
module Services
module Common

module Console

	module Internal_

		STDERR_ISATTY_		=	$stderr.isatty
		OS_IS_UNIX_			=	%w{

			darwin
			freebsd
			linux
			mingw32
			solaris
			sunos
		}.any? { |os| RUBY_PLATFORM =~ /#{os.downcase}/ }
		SHOULD_COLOURIZE_	=	STDERR_ISATTY_ && OS_IS_UNIX_

		module ColourInitialiser

			def self.extended other

				other::COLOURS.each do |name, value|

					other.const_set(name.to_s.upcase, value)

					if SHOULD_COLOURIZE_

						other.define_singleton_method(name) { |s| "\x1B[#{value}m#{s}\x1B[0m" }
					else

						other.define_singleton_method(name) { |s| s }
					end
				end
			end
		end # module ColourInitialiser
	end # module Internal_

	module AnsiEscapeSequences

		module Foreground

			COLOURS	=	{

				blinking: 5,
				bold: 1,
				default: 39,

				black: 30,
				red: 31,
				green: 32,
				yellow: 33,
				blue: 34,
				magenta: 35,
				cyan: 36,
				light_grey: 37,

				dark_grey: 90,
				bright_red: 91,
				bright_green: 92,
				bright_yellow: 93,
				bright_blue: 94,
				bright_magenta: 95,
				bright_cyan: 96,
				white: 97,
			}

			extend Internal_::ColourInitialiser
		end # module Foreground

		module Background

			COLOURS = Hash[Foreground::COLOURS.reject { |k, v| [ :blinking, :bold, :default ].include? k }.map { |k, v| [ k, 10 + v ] }]

			extend Internal_::ColourInitialiser
		end # module Background

		module Special

			# TODO

		end # module Special
	end # end AnsiEscapeSequences

end # module Console
end # module Common
end # module Services
end # module Pantheios

