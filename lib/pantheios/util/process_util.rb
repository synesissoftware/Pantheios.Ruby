
module Pantheios
module Util

module ProcessUtil

	#
	# * *Options:*
	#   - +:style+:: (:script, :script_basename, :script_dirname,
	#   :script_realpath, :script_stem) directs the inference of the process
	#   name. If none specified, :script_stem is assumed
	def self.derive_process_name dollar0 = nil, **options

		dollar0	||=	$0

		style	=	options[:style] || :script_stem

		case style
		when :script

			dollar0
		when :script_basename

			File.basename(dollar0)
		when :script_dirname

			File.basename(File.realpath(File.dirname(dollar0)))
		when :script_realpath

			File.realpath(File.dirname(dollar0))
		when :script_stem

			bn = File.basename(dollar0)

			bn =~ /\.rb$/ ? $` : bn
		else

			warn "#{self.class}##{__method__}: ignoring unrecognised type/value for ':style': '#{style}' (#{style.class})"

			dollar0
		end
	end

end # module ProcessUtil

end # module Util
end # module Pantheios

# ############################## end of file ############################# #


