#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *([ '..' ] * 1), 'lib')

# ######################################
# requires

require 'pantheios'

# ######################################
# modules

module Organisation

module Helpers

	include ::Pantheios

	def with_trace

		trace
	end

	def with_debug0; log(:debug0); end
	def with_debug1; log(:debug1); end
	def with_informational; log(:informational); end
	def with_notice; log(:notice); end
	def with_warning; log(:warning); end
	def with_failure; log(:failure); end
	def with_critical; log(:critical); end
	def with_alert; log(:alert); end

	def helper1

		trace

		with_debug0

		with_notice
	end

end # module Helpers

class OrgClass

	include Helpers
	include ::Pantheios

	def initialize()

		trace

		log(:debug2) { 'initialised instance of OrgClass' }

		helper1
	end

end # class OrgClas

end # module Organisation

# ######################################
# includes

include ::Organisation::Helpers

include ::Pantheios

# ######################################
# constants

SUPPRESSED_SEVERITIES = %i{


}

# ######################################
# diagnostics

def detect_suppression argv

	argv.each do |arg|

		SUPPRESSED_SEVERITIES << arg.to_sym
	end
end

class FrontEnd

	def severity_logged? severity

		case severity
		when ::Symbol

			!SUPPRESSED_SEVERITIES.include?(severity)
		else

			true
		end
	end
end

Pantheios::Core.set_front_end FrontEnd.new

# ######################################
# main

detect_suppression ARGV

log(:some_level)

log(:notice, 'starting up')

puts "Suppressed severities: #{SUPPRESSED_SEVERITIES}"

log(:info) { "Calling helpers" }

with_trace

with_debug0
with_debug1
helper1
with_critical
with_alert

log(:info) { "Creating instance of OrgClass" }

oc = Organisation::OrgClass.new

# ############################## end of file ############################# #


