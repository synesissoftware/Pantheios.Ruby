# Pantheios.Ruby - Installation and Use <!-- omit in toc -->


## Table of Contents <!-- omit in toc -->

- [Install the gem](#install-the-gem)
- [From a source checkout](#from-a-source-checkout)
- [Using the library](#using-the-library)


## Install the gem

```
gem install pantheios-ruby
```

or add to a **Gemfile**:

```Ruby
gem 'pantheios-ruby'
```

then `bundle install`.

On **Ruby 4+**, also add `gem 'logger'` (or `gem install logger`): **logger** left the default-gem set and is required by the file and standard-adapter log services.


## From a source checkout

```
bundle install
bundle exec rake test
```


## Using the library

```Ruby
require 'pantheios'
```


<!-- ########################### end of file ########################### -->
