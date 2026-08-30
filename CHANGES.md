# Pantheios.Ruby - Changes <!-- omit in toc -->


## 0.22.3 - 28th August 2026

* added the `warnings` branch to the **Ruby** workflow trigger;
* updated **pantheios-ruby.gemspec** to centralise the project URL for
  homepage and metadata URIs, and raised the **xqsr3** development dependency
  floor;
* updated **lib/pantheios/version.rb** for release 0.22.3;
* removed unused local-variable assignments from **simple_file_log_service.rb** and
  **standard_log_service_adapter.rb**;
* corrected ambiguous regular-expression syntax in **tc_simple_file_log_service.rb**
  and **tc_standard_log_service_adapter.rb**;
* removed an unused process-ID assignment from **tc_standard_log_service_adapter.rb**;
* removed unused loop and instance assignments from example and performance
  programs;
* warning-mode unit tests now complete without warnings;
* guarded and initialised lazily accessed instance variables to eliminate
  Ruby 2.7 warnings;


## 0.22.2 - 27th August 2026

* renamed **Pantheios.Ruby.gemspec** to **pantheios-ruby.gemspec** so the filename stem matches `spec.name`;
* **pantheios-ruby.gemspec**: `spec.summary` matches the README tagline; packaged **AUTHORS**, **CHANGES**, **CONTRIBUTING**, **EXAMPLES**, **FAQ**, **INSTALL**, **NEWS**, **SECURITY**, **TODO**; **Gemfile.lock** and **.ruby-version** excluded from `spec.files`;
* **Gemfile** sets `lockfile false` when Bundler supports it; stop tracking **Gemfile.lock**;
* CI uses `bundler-cache: false` and explicit `bundle install`; **Warnings** job on Ruby **3.4**; `gem build pantheios-ruby.gemspec`;
* updated **run_all_unit_tests.sh** (from https://github.com/synesissoftware/misc-dev-scripts) to skip **tput** when **$TERM** is unset or stdout is not a TTY;
* **README.md**: dropped GitHub-release badge; Dependencies (Efferent / Afferent); related-project list trailing `;`;
* **EXAMPLES.md** example links are repo-relative (`./examples/…`);
* library source **Home:** URLs now use `https`;
* **StockSeverityLevels** attaches `:severity` to a `dup` of each stock level string so frozen string literals still work on Ruby **3.4**;
* **Gemfile** pulls in **logger** when `RUBY_VERSION >= '4'` (no longer a default gem; the **logger** gem requires Ruby **>= 2.5**, so it is not declared in **pantheios-ruby.gemspec**);


## 0.22.1 - 15th August 2026

* added `# frozen_string_literal: true` to all **lib/** sources;
* modernised gemspec (**metadata** URIs, HTTPS homepage);
* added Synesis documentation scaffolding (**AUTHORS.md**, **CHANGES.md**, **EXAMPLES.md**, **FAQ.md**, **NEWS.md**, **README.md**, **TODO.md**);
* added **Rakefile**;


## 0.22.0.2 - 5th June 2020

* added **examples/threshold_front_end.rb**;


## 0.22.0.1 - 4th June 2020

* tidied up the documentation markup;


## 0.22.0 - 4th June 2020

* added `Pantheios::Services::ColouredConsoleLogService` (UNIX bash colours; fixed palette for now);
* added `Pantheios::API#prefix_parts` method, which assembles the prefix parts into an array;
* changed core to work in terms of a back-end's `requires_prefix?` method, which may return `false` (no prefix), `true` (prefix-string), or `:parts` (prefix parts array);
* adds the `severity` attribute to each string in the `Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_STRINGS` array;
* fixed defect in core's `set_back_end`;
* added **examples/coloured_console_log_service.rb**;


## 0.21.0 - 3rd June 2020

* added `Pantheios::FrontEnds::ThresholdFrontEnd`, which provides severity filtering based on a threshold;
* added `Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_RELATIVE`, which is a map containing only those levels that are relative, i.e. may participate meaningfully in a threshold-based filtering;
* added `Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_ALIASES`, which is a map that provides lookup of all recognised severity levels and aliases to the canonical severity level symbol;
* added `:debug5` severity level;
* now dependent on **xqsr3** v0.36+ (development-only);


## 0.20.3.2 - 3rd June 2020

* more-complete tests for stock severity levels;
* minor documentation improvements;


## 0.20.3.1 - 5th June 2019

* added example/simple_logging(.rb);


## 0.20.3 - 5th June 2019

* fix to trace() implementation;


## 0.20.2.1 - 19th October 2018

* dependencies;


## 0.20.2 - 11th April 2019

* merge (=> 0.18.2);


## 0.20.1 - 13th July 2018

* run_all_unit_tests(.sh) : ~ improving variable names (to avoid clashes);


## 0.19.2 - 8th February 2018

* Pantheios::Services::MultiplexingLogService : ~ fixed multiplexing output defect;


## 0.19.1 - 8th February 2018

* added Pantheios::Services::MultiplexingLogService class;


## 0.18.1 - 5th February 2018

* added Pantheios::Globals::MAIN_THREAD_NAME;


## 0.17.1 - 5th February 2018

* added Pantheios::Globals.PROCESS_NAME;


## 0.16.1 - 4th February 2018

* fix;


## 0.15.1 - 4th February 2018

* added more tests of postfix severity_logged? performance;


## 0.14.1 - 27th January 2018

* added ReflectionUtil and improved policing of specific service instance;


## 0.13.4 - 27th January 2018

* fixed defect;


## 0.13.2 - 27th January 2018

* tidying;


## 0.13.1 - 23rd January 2018

* added StandardLogServiceAdapter class, which provides instance adaptation of Ruby's ::Logger;


## 0.12.2 - 23rd January 2018

* documentation;


## 0.12.1 - 22nd January 2018

* added block support; + added SYNCHRONISED_SEVERITY_LOGGED global; ~ refactoring for improved performance;


## 0.11.2 - 8th January 2018

* SimpleConsoleLogService : ~ corrected handling of symbol as severity;


## 0.11.1 - 6th January 2018

* renamed SimpleConsoleService => SimpleConsoleLogService; + added NullLogService class; + added log service class tests;


## 0.10.1 - 6th January 2018

* added :benchmark severity level;


## 0.9.4 - 6th January 2018

* added unit-tests for stock severity levels;


## 0.9.3 - 6th January 2018

* tagged release;


## 0.9.2 - 2nd January 2018

* prefix now in [ ];


## 0.9.1 - 24th December 2017

* fixing;


## 0.8.2 - 24th December 2017

* tag;


## 0.8.1 - 24th December 2017

* tag;


## 0.8.0 - 23rd December 2017

* starting to break out impl. into Pantheios::Core;


## 0.7.4 - 1st March 2018

* updated dependencies;


## 0.7.3 - 5th February 2018

* LibCLImate::Climate::set_program_name(), which uses Colcon if available;


## 0.7.2 - 3rd January 2018

* merge version update;


## 0.7.1 - 22nd December 2017

* Api into Pantheios::Api; nested inclusion when 'include ::Pantheios'; Core.register_include();


## 0.6.5 - 1st January 2018

* preparatory mods;


## 0.6.4 - 1st January 2018

* fixed the version inference;


## 0.6.3 - 22nd June 2017

* tagged release;


## 0.6.2 - 15th December 2017

* tagged release;


## 0.6.1 - 16th March 2017

* added inference of version;


## 0.5.8 - 17th October 2016

* tidying up contract enforcements;


## 0.5.7 - 17th October 2016

* simplified unit test;


## 0.5.6 - 17th October 2016

* updated documentation;


## 0.5.5 - 26th June 2016

* changed hash-bangs;


## 0.5.4 - 18th June 2016

* fixed lacking blocks in new add_*() methods;


## 0.5.3 - 17th June 2016

* fix;


## 0.4.1 - 14th June 2016

* tidying;


## 0.3.1 - 13th June 2016

* merge;


## 0.2.4 - 13th June 2016

* 0.2.4 changes;


## 0.2.3 - 12th June 2016

* fixed extras handling for flags;


## 0.2.2 - 11th June 2016

* merge;


## 0.2.1 - 6th June 2016

* specified ranges for dependent libraries;


## 0.1.2 - 14th May 2016

* added Climate class, and basics of API;


## 0.1.1 - 14th July 2015

* added basic skeleton (0.1.1);


<!-- ########################### end of file ########################### -->
