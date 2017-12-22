
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
# - severity_logged?
# - tracing?
# - severity_to_string
# - prefix_elements
# - program_name
# - program_id
# - severity_string severity
# - thread_id
# - timestamp_format
# - timestamp dt
module Api

	# Logs an arbitrary set of parameters at the given severity level
	def log severity, *args

		return nil unless severity_logged? severity

		log_v_impl 1, severity, args
	end

	def log_v severity, argv

		return nil unless severity_logged? severity

		log_v_impl 1, severity, argv
	end

	def trace *args

		return nil unless severity_logged? :trace

		do_trace_v_ args, 1
	end

	def trace_v argv

		return nil unless severity_logged? :trace

		do_trace_v_ argv, 1
	end

	if Util::VersionUtil.version_compare(RUBY_VERSION, [ 2, 1 ]) >= 0

	def trace_blv b, lvars

		return nil unless severity_logged? :trace

		trace_v_impl 1, ApplicationLayer::ParamNameList[*lvars], :trace, lvars.map { |lv| b.local_variable_get(lv) }
	end
	end # RUBY_VERSION

	if Util::VersionUtil.version_compare(RUBY_VERSION, [ 2, 2 ]) >= 0

	def trace_b b

		return nil unless severity_logged? :trace

		trace_v_impl 1, ApplicationLayer::ParamNameList[*b.local_variables], :trace, b.local_variables.map { |lv| b.local_variable_get(lv) }
	end
	end # RUBY_VERSION

	# Determines whether a given severity is logged

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

		true
	end

	def tracing?

		severity_logged? :trace
	end

	def severity_to_string severity

		severity.to_s
	end



	# Defines the ordered list of log-statement elements
	#
	# === Elements
	#
	# Elements can be one of:
	#   - +:program_name+
	#   - +:program_id+
	#   - +:severity+
	#   - +:thread_id+
	#   - +:timestamp+
	def prefix_elements

		[ :program_name, :thread_id, :timestamp, :severity ]
	end

	# Default implementation to obtain the program name
	#
	# * *Returns:*
	#   the file stem of +$0+
	def program_name

		bn = File.basename $0

		bn =~ /\.rb$/ ? $` : bn
	end

	def program_id

		Process.pid
	end

	def severity_string severity

		r = ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_STRINGS[severity] and return r

		severity.to_s
	end

	def thread_id

		t = Thread.current

		return t.thread_name if t.respond_to? :thread_name

		t.to_s
	end

	def timestamp_format

		'%Y-%m-%d %H:%M:%S.%6N'
	end

	def timestamp dt

		dt.strftime timestamp_format
	end




	def self.included receiver

		receiver.extend self

		::Pantheios::Core.register_include self, receiver
	end

	private

	def log_v_impl call_depth, severity, argv

		if :trace == severity

			return trace_v_impl 1 + call_depth, nil, severity, argv
		end

		log_raw_v severity, argv
	end

	def do_trace_v_ argv, call_depth

		if ApplicationLayer::ParamNameList === argv[0]

			trace_v_impl 1 + call_depth, argv[0], :trace, argv[1..-1]
		else

			trace_v_impl 1 + call_depth, nil, :trace, argv
		end
	end

	def trace_v_impl call_depth, param_list, severity, argv

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

		log_raw severity, stmt
	end

	def log_raw_v severity, argv

		log_raw severity, argv.join
	end

	def log_raw severity, statement

		now = Time.now

		prels = prefix_elements.map do |el|

			case el
			when :program_name

				program_name
			when :program_id

				program_id
			when :severity

				severity_string severity
			when :thread_id

				thread_id
			when :timestamp

				timestamp now
			else

				s = ::Symbol === el ? ":#{el}" : el.to_s

				warn "ignoring unrecognised prefix_element '#{s}'"

				nil
			end
		end

		prefix	=	prels.join(', ') # TODO: need to do more intelligent joining

		$stderr.puts "[#{prefix}]: #{statement}"
	end

end # module Api
end # module Pantheios


