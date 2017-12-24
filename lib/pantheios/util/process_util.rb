
module Pantheios
module Util

module ProcessUtil

	def self.derive_process_name dollar0 = nil

		dollar0 ||= $0

		bn = File.basename dollar0

		bn =~ /\.rb$/ ? $` : bn
	end

end # module ProcessUtil

end # module Util
end # module Pantheios



