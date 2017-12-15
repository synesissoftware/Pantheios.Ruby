#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/util/thread_util'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_ThreadUtil_set_thread_name < Test::Unit::TestCase

	TU = ::Pantheios::Util::ThreadUtil

	def test_new_Thread_does_not_have_attribute

		t = Thread.new {}

		assert_not t.respond_to? :thread_name
	end

	def test_new_Thread_can_accept_attribute

		t = Thread.new {}

		assert_not t.respond_to? :thread_name

		TU.set_thread_name t, ''

		assert_true t.respond_to? :thread_name

		assert_equal '', t.thread_name
	end

	def test_attribute_can_be_changed

		t = Thread.new {}

		TU.set_thread_name t, 'name-1'

		assert_equal 'name-1', t.thread_name

		TU.set_thread_name t, 'name-2'

		assert_equal 'name-2', t.thread_name
	end
end

class Test_parameter_checks_as_included_module < Test::Unit::TestCase

	include ::Pantheios::Util::ThreadUtil

end

