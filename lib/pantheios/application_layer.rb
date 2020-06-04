
require 'pantheios/application_layer/param_name_list'
require 'pantheios/application_layer/stock_severity_levels'

require 'pantheios/core'

module Pantheios
module ApplicationLayer

	# @!visibility private
	def self.included receiver # :nodoc:

		receiver.extend self

		::Pantheios::Core.register_include self, receiver
	end

end # module ApplicationLayer
end # module Pantheios


