
module Pantheios
module Util

module ThreadUtil

	def self.set_thread_name t, name

		class << t; attr_accessor :thread_name; end unless t.respond_to? :thread_name

		t.thread_name = name
	end

	def self.get_thread_name t

		return t.thread_name if t.respond_to? :thread_name

		t.to_s
	end

	def thread_name name = (name_not_given_ = nil)

		t = Thread.current

		has_tn = t.respond_to? :thread_name

		if name_not_given_

			return t.thread_name if has_tn

			t.to_s
		else

			class << t; attr_accessor :thread_name; end unless has_tn

			t.thread_name = name
		end
	end

end # module ThreadUtil

end # module Util
end # module Pantheios


