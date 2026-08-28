# ######################################################################## #
# File:     pantheios-ruby.gemspec
#
# Purpose:  Gemspec for Pantheios.Ruby library
#
# Created:  15th December 2017
# Updated:  28th August 2026
#
# ######################################################################## #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pantheios/version'


PROJECT_URL = 'https://github.com/synesissoftware/Pantheios.Ruby'


Gem::Specification.new do |spec|

  spec.name         = 'pantheios-ruby'
  spec.summary      = 'Pantheios, for Ruby'
  spec.version      = Pantheios::VERSION
  spec.description  = <<END_DESC
A Ruby version of the popular C++ (and .NET) logging API library
END_DESC

  spec.authors      = [
    'Matt Wilson',
  ]
  spec.email        = [
    'matthew@synesis.com.au',
  ]
  spec.homepage     = PROJECT_URL
  spec.license      = 'BSD-3-Clause'

  spec.required_ruby_version = [ '>= 2.0' ]

  spec.metadata = {
    'bug_tracker_uri' => "#{PROJECT_URL}/issues",
    'changelog_uri' => "#{PROJECT_URL}/blob/master/CHANGES.md",
    'homepage_uri' => PROJECT_URL,
    'source_code_uri' => PROJECT_URL,
  }

  spec.add_development_dependency "xqsr3", [ '>= 0.39.10', '< 1' ]

  spec.files = Dir[
    'Rakefile',
    '{bin,examples,lib,man,spec,test}/**/*',
    'AUTHORS*',
    'CHANGES*',
    'CONTRIBUTING*',
    'EXAMPLES*',
    'FAQ*',
    'INSTALL*',
    'LICENSE*',
    'NEWS*',
    'README*',
    'SECURITY*',
    'TODO*',
  ] & `git ls-files -z`.split("\0")
  spec.files -= [
    '.ruby-version',
    'Gemfile.lock',
  ]
end


# ############################## end of file ############################# #
