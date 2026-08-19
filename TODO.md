# Pantheios.Ruby - TODO <!-- omit in toc -->


## Functional improvements

* \<none>


## Performance improvements

* \<none>


## Packaging improvements

* [x] ~~~rename gemspec so the filename stem matches `spec.name` (`Pantheios.Ruby.gemspec` → **pantheios-ruby.gemspec**)~~~;
* [x] ~~~obtain a **run_all_unit_tests.sh** (from **misc-dev-scripts**) that skips `tput` when `$TERM` is unset or stdout is not a TTY (CI: `tput: No value for $TERM and no -T specified`)~~~;
* [x] ~~~gemspec polish: README tagline as `spec.summary`, package docs, exclude **Gemfile.lock** / **.ruby-version**~~~;
* [x] ~~~stop tracking **Gemfile.lock**; **Gemfile** `lockfile false` when Bundler supports it; CI `bundler-cache: false`~~~;
* [x] ~~~after the packaging/boilerplate/CI baseline: bump **VERSION** and align **CHANGES**/**NEWS**~~~;


<!-- ########################### end of file ########################### -->
