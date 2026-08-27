# Pantheios.Ruby - TODO <!-- omit in toc -->


## Functional improvements

* [ ] quiet unused-variable warnings in **simple_file_log_service.rb** (`logger_init_options`) and **standard_log_service_adapter.rb** (`sym`);
* [ ] quiet **Warnings** job noise in tests: unused `pid` in **tc_standard_log_service_adapter.rb**; ambiguous `/` in **tc_simple_file_log_service.rb** and **tc_standard_log_service_adapter.rb**;


## Performance improvements

* \<none>


## Packaging improvements

* [ ] catalogue known afferent dependents in **README.md** when any are identified;
* [x] ~~~handle Ruby **4** stdlib **logger** no longer being a default gem (**Gemfile** when `RUBY_VERSION >= '4'`; not in the gemspec because the **logger** gem requires Ruby **>= 2.5**)~~~;
* [x] ~~~rename gemspec so the filename stem matches `spec.name` (`Pantheios.Ruby.gemspec` → **pantheios-ruby.gemspec**)~~~;
* [x] ~~~obtain a **run_all_unit_tests.sh** (from **misc-dev-scripts**) that skips `tput` when `$TERM` is unset or stdout is not a TTY (CI: `tput: No value for $TERM and no -T specified`)~~~;
* [x] ~~~gemspec polish: README tagline as `spec.summary`, package docs, exclude **Gemfile.lock** / **.ruby-version**~~~;
* [x] ~~~stop tracking **Gemfile.lock**; **Gemfile** `lockfile false` when Bundler supports it; CI `bundler-cache: false`~~~;
* [x] ~~~after the packaging/boilerplate/CI baseline: bump **VERSION** and align **CHANGES**/**NEWS**~~~;


<!-- ########################### end of file ########################### -->
