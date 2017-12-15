
module Pantheios
module Util

module VersionUtil

	# Compares two version designators and returns a spaceship comparison
	# result
	#
	# === Signature
	#
	# * *Parameters:*
	#  - +lhs+ [String, Array[Integer|String]] The left-hand comparand
	#  - +rhs+ [String, Array[Integer|String]] The right-hand comparand
	#
	# * *Returns:*
	#  - 0 if the two version designators represent exactly the same version
	#  - <0 if the +lhs+ version designator represents an earlier version
	#    than the +rhs+ version designator
	#  - >0 if the +lhs+ version designator represents a later version
	#    than the +rhs+ version designator
	def self.version_compare lhs, rhs

		lhs	=	lhs.split('.') if String === lhs
		rhs	=	rhs.split('.') if String === rhs

		lhs	=	lhs.map { |n| n.to_i }
		rhs	=	rhs.map { |n| n.to_i }

		if lhs.size < rhs.size

			lhs += [ 0 ] * (rhs.size - lhs.size)
		else

			rhs += [ 0 ] * (lhs.size - rhs.size)
		end

		lhs <=> rhs
	end
end # module VersionUtil

end # module Util
end # module Pantheios

