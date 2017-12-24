
require 'pantheios/application_layer/param_name_list'
require 'pantheios/application_layer/stock_severity_levels'
require 'pantheios/util/version_util'

require 'pantheios/core'


module Pantheios
# This inclusion module specifies the main logging API methods, including:
#
# - log
# - log_v
# - trace
# - trace_v
#
# as well as those that may be overridden:
#
# - severity_logged?
# - tracing?
#
# - prefix_elements
# - process_id
# - program_name
# - severity_string severity
# - thread_id
# - timestamp dt
module Api

	# Logs an arbitrary set of parameters at the given severity level
	def log severity, *args

		return nil unless severity_logged? severity

		log_or_trace 1, severity, args
	end

	def log_v severity, argv

		return nil unless severity_logged? severity

		log_or_trace 1, severity, argv
	end

	def trace *args

		return nil unless tracing?

		trace_v_prep self, 1, args
	end

	def trace_v argv

		return nil unless tracing?

		trace_v_prep self, 1, argv
	end

	if Util::VersionUtil.version_compare(RUBY_VERSION, [ 2, 1 ]) >= 0

	def trace_blv b, lvars

		return nil unless tracing?

		trace_v_impl self, 1, ApplicationLayer::ParamNameList[*lvars], :trace, lvars.map { |lv| b.local_variable_get(lv) }
	end
	end # RUBY_VERSION

	if Util::VersionUtil.version_compare(RUBY_VERSION, [ 2, 2 ]) >= 0

	def trace_b b

		return nil unless tracing?

		trace_v_impl self, 1, ApplicationLayer::ParamNameList[*b.local_variables], :trace, b.local_variables.map { |lv| b.local_variable_get(lv) }
	end
	end # RUBY_VERSION


	# Determines whether a given severity is logged
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +severity+:: The severity level, which should be a known log
	#   severity symbol or an integral equivalent
	#
	# * *Returns:*
	#   a +truey+ value if the severity should be logged; a +falsey+ value
	#   otherwise
	def severity_logged? severity

		::Pantheios::Core.severity_logged? severity
	end

	# Determines whether tracing (severity == :trace) is enabled. This is
	# used in the trace methods (+trace+, +trace_v+, +trace_blv+, +trace_b+)
	# and therefore it may be overridden independently of +severity_logged?+
	def tracing?

		severity_logged? :trace
	end



	# Defines the ordered list of log-statement elements
	#
	# === Elements
	#
	# Elements can be one of:
	#   - +:program_name+
	#   - +:process_id+
	#   - +:severity+
	#   - +:thread_id+
	#   - +:timestamp+
	#
	# This is called from +prefix+
	def prefix_elements

		[ :program_name, :thread_id, :timestamp, :severity ]
	end

	# Obtains the process id
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::process_id+
	def process_id

		::Pantheios::Core.process_id
	end

	# Obtains the program name
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::program_name+
	def program_name

		::Pantheios::Core.program_name
	end

	# Obtains the string corresponding to the severity
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::severity_string+
	def severity_string severity

		::Pantheios::Core.severity_string severity
	end

	# Obtains the thread id
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::thread_id+
	def thread_id

		::Pantheios::Core.thread_id
	end

	# Obtains a string-form of the timestamp
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::timestamp+
	def timestamp dt

		::Pantheios::Core.timestamp dt, nil
	end




	def self.included receiver

		receiver.extend self

		::Pantheios::Core.register_include self, receiver
	end

	private

	def log_or_trace call_depth, severity, argv

		if :trace == severity

			return trace_v_impl self, 1 + call_depth, nil, severity, argv
		end

		log_raw self, severity, argv.join
	end

	def trace_v_prep prefix_provider, call_depth, argv

		if ApplicationLayer::ParamNameList === argv[0]

			trace_v_impl prefix_provider, 1 + call_depth, argv[0], :trace, argv[1..-1]
		else

			trace_v_impl prefix_provider, 1 + call_depth, nil, :trace, argv
		end
	end

	def trace_v_impl prefix_provider, call_depth, param_list, severity, argv

		case param_list
		when nil
			;
		when ApplicationLayer::ParamNameList
			;
		else

			warn "param_list (#{param_list.class}) must be nil or an instance of #{ApplicationLayer::ParamNameList}" unless param_list
		end

		f = caller(call_depth + 1, 1)[0]

		if f =~ /.*in\s*\`(.+)\'\s*$/

			f = $1
		end

		if param_list

			sig = ''

			argv.each_with_index do |arg, index0|

				n	=	param_list[index0]

				s	=	arg.to_s
				s	=	"'#{s}'" if s.index /[,\s]/

				sig	+=	', ' unless sig.empty?

				sig	+=	n ? "#{n} (#{arg.class})=#{s}" : s
			end
		else

			sig = argv.join(', ')
		end

		stmt = "#{f}(#{sig})"

		log_raw prefix_provider, severity, stmt
	end


	def prefix t, severity

		prefix_elements.map do |el|

			case el
			when :program_name

				program_name
			when :process_id

				process_id
			when :severity

				severity_string severity
			when :thread_id

				thread_id
			when :timestamp

				timestamp t
			else

				s = ::Symbol === el ? ":#{el}" : el.to_s

				warn "ignoring unrecognised prefix_element '#{s}'"

				nil
			end
		end.join(', ') # TODO: need to do more intelligent joining
	end

	def log_raw prefix_provider, severity, statement

		now = Time.now

		$stderr.puts "[#{prefix now, severity}]: #{statement}"
	end

end # module Api
end # module Pantheios


