# ######################################################################### #
# File:     Pantheios.Ruby.gemspec
#
# Purpose:  Gemspec for Pantheios.Ruby library
#
# Created:  15th December 2017
# Updated:  15th August 2026
#
# ######################################################################### #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pantheios/version'


Gem::Specification.new do |spec|

  spec.name         = "pantheios-ruby"
  spec.version      = Pantheios::VERSION
  spec.summary      = 'Pantheios.Ruby'
  spec.description  = <<END_DESC
A Ruby version of the popular C++ (and .NET) logging API library
END_DESC

  spec.authors      = [
    "Matt Wilson",
  ]
  spec.email        = [
    "matthew@synesis.com.au",
  ]
  spec.homepage     = 'https://github.com/synesissoftware/Pantheios.Ruby'
  spec.license      = 'BSD-3-Clause'

  spec.files        = Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")

  spec.required_ruby_version = [ '>= 2.0' ]

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/synesissoftware/Pantheios.Ruby/issues',
    'changelog_uri' => 'https://github.com/synesissoftware/Pantheios.Ruby/blob/master/CHANGES.md',
    'homepage_uri' => 'https://github.com/synesissoftware/Pantheios.Ruby',
    'source_code_uri' => 'https://github.com/synesissoftware/Pantheios.Ruby',
  }

  spec.add_development_dependency "xqsr3", [ '>= 0.39.5', '< 1.0' ]
end


# ############################## end of file ############################# #
