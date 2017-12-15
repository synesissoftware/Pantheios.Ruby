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

	class NonThread1

		include ::Pantheios::Util::ThreadUtil::ThreadName
	end

	class Thread1 < Thread

		include ::Pantheios::Util::ThreadUtil::ThreadName

		def initialize

			super
		end
	end


	def test_NonThread1_1

		t = NonThread1.new

		assert_equal Thread.current.to_s, t.thread_name
	end

	def test_NonThread1_2

		t = NonThread1.new

		t.thread_name = 'the-thread'

		assert_equal 'the-thread', t.thread_name
	end


	def test_Thread1_1

		t = Thread1.new {}

		assert_equal t.to_s, t.thread_name
	end

	def test_Thread1_2

		t = Thread1.new {}

		t.thread_name = 'another-thread'

		assert_equal 'another-thread', t.thread_name
	end
end

