# Pantheios.Ruby Example - **multiple_modules**

## Summary

Example showing application of Pantheios into multiple modules and
suppression of arbitrary severity levels specified as command line
arguments

## Source

```ruby
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

```


## Usage

### No arguments

When executed as follows

```
$ ./examples/multiple_modules.rb
```

it gives the following output:

```
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.853720, some_level]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.853882, Notice]: starting up
Suppressed severities: []
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.853971, Informational]: Calling helpers
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854134, Trace]: ./examples/multiple_modules.rb:21: Object#with_trace()
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854200, Debug-0]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854255, Debug-1]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854333, Trace]: ./examples/multiple_modules.rb:35: Object#helper1()
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854386, Debug-0]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854522, Notice]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854582, Critical]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854631, Alert]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854684, Informational]: Creating instance of OrgClass
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854772, Trace]: ./examples/multiple_modules.rb:51: Organisation::OrgClass#initialize()
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854852, Debug-2]: initialised instance of OrgClass
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854930, Trace]: ./examples/multiple_modules.rb:35: Organisation::OrgClass#helper1()
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.854985, Debug-0]:
[multiple_modules, 70123884951220, 2020-06-03 20:30:15.855035, Notice]:
```

### Some named suppressed levels

When executed as follows

```
$ ./examples/multiple_modules.rb trace debug2
```

it gives the following output:

```
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.201933, some_level]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202013, Notice]: starting up
Suppressed severities: [:trace, :debug2]
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202050, Informational]: Calling helpers
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202073, Debug-0]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202091, Debug-1]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202110, Debug-0]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202125, Notice]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202167, Critical]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202199, Alert]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202243, Informational]: Creating instance of OrgClass
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202269, Debug-0]:
[multiple_modules, 70350289450660, 2020-06-03 20:25:49.202286, Notice]:
```

