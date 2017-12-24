
module Pantheios
module Services

class SimpleConsoleService

	def severity_logged? severity

		true
	end

	def log sev, t, pref, msg

		$stderr.puts "#{pref}#{msg}"
	end
end

end # module Services
end # module Pantheios

