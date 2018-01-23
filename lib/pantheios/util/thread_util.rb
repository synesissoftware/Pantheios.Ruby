
module Pantheios
module Util

module ThreadUtil

	# Creates (if necessary) and sets the given thread's +thread_name+
	# attribute to the given name
	#
	# === Signature
	#
	# * *Parameters:*
	#  - +t+ [Thread, nil] The thread to be named, or +nil+ if it should
	#    operate on the current (invoking) thread
	#  - +name+ [String] The thread's name
	def self.set_thread_name t, name

		t ||= Thread.current

		class << t; attr_accessor :thread_name; end unless t.respond_to? :thread_name

		t.thread_name = name
	end

	def self.get_thread_name t

		t ||= Thread.current

		return t.thread_name if t.respond_to? :thread_name

		t.to_s
	end

	# Inclusion module for giving the included type the +thread_name+
	# attribute
	#
	# If included into a thread type, or a thread instance, then
	module ThreadName

		def self.included receiver

			if receiver < ::Thread

				receiver.instance_eval do

					define_method(:thread_name) { @thread_name || self.to_s }
					define_method(:thread_name=) { |name| @thread_name = name }
				end
			else

				receiver.instance_eval do

					define_method :thread_name do |name = (name_not_given_ = true)|

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

					define_method(:thread_name=) { |name| thread_name name }
				end
			end
		end
	end

end # module ThreadUtil

end # module Util
end # module Pantheios

# ############################## end of file ############################# #


