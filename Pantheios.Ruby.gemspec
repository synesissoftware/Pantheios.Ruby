# ######################################################################### #
# File:         Pantheios.Ruby.gemspec
#
# Purpose:      Gemspec for Pantheios.Ruby library
#
# Created:      15th December 2017
# Updated:      3rd June 2020
#
# ######################################################################### #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pantheios/version'

require 'date'

Gem::Specification.new do |spec|

	spec.name			=	'pantheios-ruby'
	spec.version		=	Pantheios::VERSION
	spec.date			=	Date.today.to_s
	spec.summary		=	'Pantheios.Ruby'
	spec.description	=	<<END_DESC
A Ruby version of the popular C++ (and .NET) logging API library
END_DESC
	spec.authors		=	[ 'Matt Wilson' ]
	spec.email			=	'matthew@synesis.com.au'
	spec.homepage		=	'http://github.com/synesissoftware/Pantheios.Ruby'
	spec.license		=	'BSD-3-Clause'

	spec.files			=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")

	spec.required_ruby_version = '>= 2'

	spec.add_development_dependency 'xqsr3', [ '~> 0.36' ]
end

