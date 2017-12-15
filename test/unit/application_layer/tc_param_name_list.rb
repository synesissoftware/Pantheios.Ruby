#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/application_layer/param_name_list'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_ParamNameList_type_characteristics < Test::Unit::TestCase

	include ::Pantheios::ApplicationLayer

	def test_ParamNameList_type_exists

		assert defined? ParamNameList
	end

	def test_ParamNames_type_exists

		assert defined? ParamNames
	end

	def test_ParamNameList_type_is_a_class

		assert ParamNameList.is_a? ::Class
	end

	def test_ParamNames_type_is_a_class

		assert ParamNames.is_a? ::Class
	end
end

