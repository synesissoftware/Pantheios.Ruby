# **Pantheios.Ruby** Changes

## 0.22.0.2 - 5th June 2020

* added **examples/threshold_front_end.rb**

## 0.22.0.1 - 4th June 2020

* tidied up the documentation markup

## 0.22.0 - 4th June 2020

* added `Pantheios::Services::ColouredConsoleLogService`, which does exactly what it says on the tin. Current version colours only on UNIX bash and choice of colours is fixed, but this will change in a future version
* added `Pantheios::API#prefix_parts` method, which assembles the prefix parts into an array
* changed core to work in terms of a back-end\'s `requires_prefix?` method, which may return `false` (no prefix), `true` (prefix-string), or `:parts` (prefix parts array)
* adds the `severity` attribute to each string in the `Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_STRINGS` array
* fixed defect in core's `set_back_end`
* added **examples/coloured_console_log_service.rb**

## 0.21.0 - 3rd June 2020

* added `Pantheios::FrontEnds::ThresholdFrontEnd`, which provides severity filtering based on a threshold
* added `Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_RELATIVE`, which is a map that containing only those levels that are relative, i.e. may participate meaningfully in a threshold-based filtering
* added `Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_ALIASES`, which is a map that provides lookup of all recognised severity levels and aliases to the canonical severity level symbol
* added `:debug5` severity level
* now dependent on **xqsr3** v0.36+ (development-only)

## 0.20.3.2 - 3rd June 2020

* more-complete tests for stock severity levels
* minor documentation improvements

## previous versions

T.B.C.

