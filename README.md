# Pantheios.Ruby <!-- omit in toc -->

Pantheios, for Ruby

![Language](https://img.shields.io/badge/Ruby-CC342D?style=flat&logo=ruby&logoColor=white)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Gem Version](https://badge.fury.io/rb/pantheios-ruby.svg)](https://badge.fury.io/rb/pantheios-ruby)
[![GitHub release](https://img.shields.io/github/v/release/synesissoftware/Pantheios.Ruby.svg)](https://github.com/synesissoftware/Pantheios.Ruby/releases/latest)
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
    - [Development Dependencies](#development-dependencies)
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

Examples are provided in the `examples` directory, along with a markdown description where present. A detailed list is provided in [EXAMPLES.md](./EXAMPLES.md).


## Project Information


### Where to get help

[GitHub Page](https://github.com/synesissoftware/Pantheios.Ruby "GitHub Page")


### Contribution guidelines

Defect reports, feature requests, and pull requests are welcome on https://github.com/synesissoftware/Pantheios.Ruby.


### Dependencies

* \<none>


#### Development Dependencies

* [**xqsr3**](https://github.com/synesissoftware/xqsr3/)


### Related projects

* [**Pantheios**](https://github.com/synesissoftware/Pantheios/)
* [**Pantheios.NET**](https://github.com/synesissoftware/Pantheios.NET/)
* [**Pantheios.Rust**](https://github.com/synesissoftware/Pantheios.Rust/)


### License

**Pantheios.Ruby** is released under the 3-clause BSD license. See [LICENSE](./LICENSE) for details.


<!-- ########################### end of file ########################### -->
