# gemspec for Pantheios.Ruby

$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pantheios/version'

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
	spec.homepage		=	'http://www.pantheios.org/'
	spec.license		=	'Modified BSD'

	spec.add_development_dependency 'xqsr3', [ '>= 0.21.1', '< 1.0' ]

	spec.files			=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

