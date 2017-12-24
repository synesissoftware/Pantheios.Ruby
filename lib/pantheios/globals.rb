
module Pantheios
# A utility namespace for the sole purpose of defining "globals" - actually
# module constants' values and module attributes - that control the
# behaviour of Pantheios globally
#
# NOTE: The "globals" in this namespace are operative before
# +::Pantheios::Core+ and +::Pantheios::API+
module Globals

	module Internals_

		BOOLEAN_CLASSES	=	[ ::FalseClass, ::TrueClass ]
		TRUTHY_CLASSES	=	BOOLEAN_CLASSES + [ ::NilClass ]
	end

	def self.included receiver

		abort "Attempt to include #{self} into #{receiver}. This is not allowed"
	end

	# :nodoc:
	def self.class_init_

		@has_cascaded_includes = true
	end

	instance_eval do

		self.class_init_
	end

	class << self

		def HAS_CASCADED_INCLUDES; @has_cascaded_includes; end
		def HAS_CASCADED_INCLUDES= b

			warn "Assigning to #{__method__} with non-boolean argument" unless Internals_::BOOLEAN_CLASSES.any? { |c| c === b }

			@has_cascaded_includes = !(!(b))
		end
	end
end
end # module Pantheios


