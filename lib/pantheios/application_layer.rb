
require 'pantheios/application_layer/param_name_list'
require 'pantheios/application_layer/stock_severity_levels'

require 'pantheios/core'

module Pantheios
module ApplicationLayer

	def self.included receiver

		receiver.extend self

		::Pantheios::Core.register_include self, receiver
	end

end # module ApplicationLayer
end # module Pantheios


