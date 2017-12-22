
module Pantheios
module Core

	def self.included receiver

		abort "Attempt to include Pantheios::Core into #{receiver}. This is not allowed"
	end

	# :nodoc:
	def self.register_include includee, includer

	end


	def self.severity_logged? severity

		true
	end


	# Default implementation to obtain the process id
	#
	# * *Returns:*
	#   +Process.pid+
	def self.process_id

		Process.pid
	end

	# Default implementation to obtain the program name
	#
	# * *Returns:*
	#   The file stem of +$0+
	def self.program_name

		bn = File.basename $0

		bn =~ /\.rb$/ ? $` : bn
	end

	def self.severity_string severity

		r = ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_STRINGS[severity] and return r

		severity.to_s
	end

	# Default implementation to obtain the thread_id
	#
	# * *Returns:*
	#   From the current thread either the value obtained via the attribute
	#   +thread_name+ (if it responds to that) or via +object_id+
	def self.thread_id

		t = Thread.current

		return t.thread_name if t.respond_to? :thread_name

		t.object_id
	end

	def self.timestamp_format

		'%Y-%m-%d %H:%M:%S.%6N'
	end

	# Default implementation to obtain the timestamp according to a given
	# format
	#
	# * *Parameters:*
	#  - +t+ [::Time] The time
	#  - +fmt+ [::String, nil] The format to be used. If +nil+ the value
	#    obtained by +timestamp_format+ is used
	#
	# * *Returns:*
	#   A string representing the time
	def self.timestamp t, fmt

		fmt ||= self.timestamp_format

		t.strftime fmt
	end


end # Core
end # Pantheios

