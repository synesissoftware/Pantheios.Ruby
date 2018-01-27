#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/util/reflection_util'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_ReflectionUtil_set_thread_name < Test::Unit::TestCase

	class Grandparent; end

	class Parent < Grandparent; end

	class Child < Parent; end


	class Basic_Grandparent < BasicObject; end

	class Basic_Parent < Basic_Grandparent; end

	class Basic_Child < Basic_Parent; end


	RU = ::Pantheios::Util::ReflectionUtil

	def test_non_root_classes_end_cases

		assert_empty RU.non_root_classes(nil)

		assert_empty RU.non_root_classes(::Object)

		assert_equal [ ::Regexp ], RU.non_root_classes(//)

		assert_equal [ ::String ], RU.non_root_classes('')

		assert_equal [ ::String ], RU.non_root_classes(::String)

		assert_equal [ Grandparent ], RU.non_root_classes(Grandparent)

		assert_equal [ Parent, Grandparent ], RU.non_root_classes(Parent)

		assert_equal [ Child, Parent, Grandparent ], RU.non_root_classes(Child)

		assert_equal [ Basic_Grandparent ], RU.non_root_classes(Basic_Grandparent)

		assert_equal [ Basic_Parent, Basic_Grandparent ], RU.non_root_classes(Basic_Parent)

		assert_equal [ Basic_Child, Basic_Parent, Basic_Grandparent ], RU.non_root_classes(Basic_Child)
	end
end

