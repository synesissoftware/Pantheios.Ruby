
module Pantheios
module Core

	def self.included receiver

		abort "Attempt to include Pantheios::Core into #{receiver}. This is not allowed"
	end

	# :nodoc:
	def self.register_include includee, includer

	end

end # Core
end # Pantheios

