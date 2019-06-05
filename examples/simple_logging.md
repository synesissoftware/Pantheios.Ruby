# Pantheios.Ruby Example - **simple_logging**

## Summary

Simple example supporting ```--help``` and ```--version```.

## Source

```ruby
#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *([ '..' ] * 1), 'lib')

# requires (0)

require 'pantheios/globals'

# globals

Pantheios::Globals.MAIN_THREAD_NAME = [ Thread.current, 'main' ]
Pantheios::Globals.PROCESS_NAME = :script_stem

# requires (1)

require 'pantheios'

# includes

include ::Pantheios

# constants

LEVELS = %i{ violation alert critical failure warning notice informational debug0 debug1 debug2 debug3 debug4 }

# main

LEVELS.each do |level|

	log(level, "logging level #{level}")
end

# ############################## end of file ############################# #
```

## Usage

### No arguments

When executed gives the following output:

```
[simple_logging, main, 2019-06-05 13:18:52.517479, Violation]: logging level violation
[simple_logging, main, 2019-06-05 13:18:52.517615, Alert]: logging level alert
[simple_logging, main, 2019-06-05 13:18:52.517653, Critical]: logging level critical
[simple_logging, main, 2019-06-05 13:18:52.517681, Failure]: logging level failure
[simple_logging, main, 2019-06-05 13:18:52.517709, Warning]: logging level warning
[simple_logging, main, 2019-06-05 13:18:52.517735, Notice]: logging level notice
[simple_logging, main, 2019-06-05 13:18:52.517763, Informational]: logging level informational
[simple_logging, main, 2019-06-05 13:18:52.517789, Debug-0]: logging level debug0
[simple_logging, main, 2019-06-05 13:18:52.517837, Debug-1]: logging level debug1
[simple_logging, main, 2019-06-05 13:18:52.517876, Debug-2]: logging level debug2
[simple_logging, main, 2019-06-05 13:18:52.517905, Debug-3]: logging level debug3
[simple_logging, main, 2019-06-05 13:18:52.517931, Debug-4]: logging level debug4
```

