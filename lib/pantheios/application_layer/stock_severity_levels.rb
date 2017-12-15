
module Pantheios
module ApplicationLayer

module StockSeverityLevels

	private
	module Internal_

		STOCK_SEVERITY_LEVELS_ = {

			:emergency => [ 1, 'Emergency' ],
			:alert => [ 2, 'Alert' ],
			:critical => [ 3, 'Critical' ],
			:failure => [ 4, 'Failure' ],
			:warning => [ 5, 'Warning', [ :warn ] ],
			:notice => [ 6, 'Notice' ],
			:informational => [ 7, 'Informational', [ :info ] ],
			:debug0 => [ 8, 'Debug-0' ],
			:debug1 => [ 9, 'Debug-0' ],
			:debug2 => [ 10, 'Debug-0' ],
			:debug3 => [ 11, 'Debug-0' ],
			:debug4 => [ 12, 'Debug-0' ],
			:trace => [ 13, 'Trace' ],
		}

		def self.create_level_value_map m

			r = {}

			m.each do |s, ar|

				warn 'invalid start-up' unless ::Symbol === s
				warn 'invalid start-up' unless ::Array === ar

				([s] + (ar[2] || [])).each do |al|

					r[al] = ar[0]
				end
			end

			r
		end
		def self.create_level_string_map m

			r = {}

			m.each do |s, ar|

				warn 'invalid start-up' unless ::Symbol === s
				warn 'invalid start-up' unless ::Array === ar

				([s] + (ar[2] || [])).each do |al|

					r[al] = ar[1]
				end
			end

			r
		end
	end
	public

	# Ordered list of stock severity levels
	STOCK_SEVERITY_LEVELS = Internal_::STOCK_SEVERITY_LEVELS_.keys

	# Mapping of severity levels (and level aliases) to integral
	# equivalent
	STOCK_SEVERITY_LEVEL_VALUES = Internal_.create_level_value_map Internal_::STOCK_SEVERITY_LEVELS_

	# Mapping of severity levels (and level aliases) to string
	STOCK_SEVERITY_LEVEL_STRINGS = Internal_.create_level_string_map Internal_::STOCK_SEVERITY_LEVELS_

end # module StockSeverityLevels

end # module ApplicationLayer
end # module Pantheios

