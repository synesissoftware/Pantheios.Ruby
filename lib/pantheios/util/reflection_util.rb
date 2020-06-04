
module Pantheios
module Util

# reflection utilities
module ReflectionUtil

	module ReflectionUtil_Constants

		ROOT_CLASSES = [ ::Object, ::BasicObject ]
	end

	# Obtains a list of all classes pertaining to +o+, excepting root
	# objects (+::Object+ and +::BaseObject+).
	def self.non_root_classes o

		return [] if o.nil?

		return self.non_root_classes o.class unless ::Class === o

		return [] if ReflectionUtil_Constants::ROOT_CLASSES.any? { |c| c == o }

		s = o.superclass

		return [ o ] if ::Object == s

		[ o ] + self.non_root_classes(s)
	end

end # module ProcessUtil

end # module Util
end # module Pantheios

# ############################## end of file ############################# #


