
# The main module for Pantheios
#
# Pantheios is both a namespace module and an inclusion module. When
# included, it results in the automatic inclusion of the inclusion modules
# +Pantheios::API+, +Pantheios::ApplicationLayer+, and +Pantheios::Util+ (as
# well as certain sub modules of +Pantheios::Util+; see +Pantheios::Util+
# for details), unless the global symbol
# +::Pantheios::Globals.HAS_CASCADED_INCLUDES+ is truey
module Pantheios
end # module Pantheios

require 'pantheios/globals'

require 'pantheios/api'
require 'pantheios/application_layer'
require 'pantheios/util'
require 'pantheios/version'

module Pantheios

	def self.included receiver

		if ::Pantheios::Globals.HAS_CASCADED_INCLUDES

			receiver.class_eval do

				include ::Pantheios::API
				include ::Pantheios::ApplicationLayer
				include ::Pantheios::Util
			end
		end

		::Pantheios::Core.register_include self, receiver
	end

end # module Pantheios


