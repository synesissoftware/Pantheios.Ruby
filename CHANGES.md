# **Pantheios.Ruby** Changes

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

