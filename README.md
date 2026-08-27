# Pantheios.Ruby <!-- omit in toc -->

Pantheios, for Ruby

![Language](https://img.shields.io/badge/Ruby-CC342D?style=flat&logo=ruby&logoColor=white)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Gem Version](https://badge.fury.io/rb/pantheios-ruby.svg)](https://badge.fury.io/rb/pantheios-ruby)
[![Last Commit](https://img.shields.io/github/last-commit/synesissoftware/Pantheios.Ruby)](https://github.com/synesissoftware/Pantheios.Ruby/commits/master)
[![Ruby](https://github.com/synesissoftware/Pantheios.Ruby/actions/workflows/ruby.yml/badge.svg)](https://github.com/synesissoftware/Pantheios.Ruby/actions/workflows/ruby.yml)


## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [Installation](#installation)
- [Components](#components)
- [Examples](#examples)
- [Project Information](#project-information)
  - [Where to get help](#where-to-get-help)
  - [Contribution guidelines](#contribution-guidelines)
  - [Dependencies](#dependencies)
    - [Efferent (fan-out)](#efferent-fan-out)
      - [Runtime Dependencies (aka "Normal Dependencies")](#runtime-dependencies-aka-normal-dependencies)
      - [Development Dependencies](#development-dependencies)
    - [Afferent (fan-in)](#afferent-fan-in)
      - [Runtime dependents](#runtime-dependents)
      - [Development dependents](#development-dependents)
  - [Related projects](#related-projects)
  - [License](#license)


## Introduction

**Pantheios** is a diagnostic logging API library, originally implemented for C/C++ and later for .NET. **Pantheios.Ruby** is the **Ruby** implementation.

It provides a layered logging model: application-facing severity levels and API helpers, optional front-ends (for example threshold filtering), and pluggable back-end log services (console, coloured console, file, null, multiplexing, and adapters).


## Installation

Install via **gem** as in:

```
gem install pantheios-ruby
```

or add it to your `Gemfile`.

**Pantheios.Ruby** requires Ruby **2.0+**.

> **NOTE**: On **Ruby 4+**, also install [**logger**](https://rubygems.org/gems/logger) (`gem install logger`, or `gem 'logger'` in your Gemfile). See [Runtime Dependencies](#runtime-dependencies-aka-normal-dependencies).

Use via **require**, as in:

```Ruby
require 'pantheios'
```


## Components

* **Pantheios::API** — primary logging API surface;
* **Pantheios::ApplicationLayer** — stock severity levels and related application helpers;
* **Pantheios::Core** — core registration and back-end wiring;
* **Pantheios::FrontEnds** — front-ends such as **ThresholdFrontEnd**;
* **Pantheios::Services** — back-end log services (console, coloured console, file, null, multiplexing, adapters);
* **Pantheios::Util** — process, reflection, thread, and version utilities;


## Examples

Examples are provided in the ```examples``` directory, along with a markdown description where present. A detailed list TOC of them is provided in [EXAMPLES.md](./EXAMPLES.md).


## Project Information


### Where to get help

[GitHub Page](https://github.com/synesissoftware/Pantheios.Ruby "GitHub Page")


### Contribution guidelines

Defect reports, feature requests, and pull requests are welcome on https://github.com/synesissoftware/Pantheios.Ruby.


### Dependencies


#### Efferent (fan-out)

Libraries upon which **Pantheios.Ruby** depends:


##### Runtime Dependencies (aka "Normal Dependencies")

* \<none> declared in **pantheios-ruby.gemspec**;

> **NOTE**: On **Ruby 4+**, **logger** is required at runtime (`lib/pantheios/services/simple_file_log_service.rb`, `lib/pantheios/services/standard_log_service_adapter.rb`) but is no longer a default gem and is not listed in **pantheios-ruby.gemspec** (so older Rubies in the `[2.0, 4)` range still resolve). Install it explicitly, e.g. `gem install logger`, or add `gem 'logger'` to your Gemfile. This repository’s **Gemfile** pulls it in when `RUBY_VERSION >= '4'`.


##### Development Dependencies

* [**rake**](https://rubygems.org/gems/rake);
* [**test-unit**](https://rubygems.org/gems/test-unit);
* [**xqsr3**](https://github.com/synesissoftware/xqsr3);


#### Afferent (fan-in)

Projects that depend on **Pantheios.Ruby**:


##### Runtime dependents

* \<none>;


##### Development dependents

* \<none>;


### Related projects

* [**Pantheios**](https://github.com/synesissoftware/Pantheios/) (**C**/**C++**);
* [**Pantheios.NET**](https://github.com/synesissoftware/Pantheios.NET/);
* [**Pantheios.Rust**](https://github.com/synesissoftware/Pantheios.Rust/);


### License

**Pantheios.Ruby** is released under the 3-clause BSD license. See [LICENSE](./LICENSE) for details.


<!-- ########################### end of file ########################### -->
