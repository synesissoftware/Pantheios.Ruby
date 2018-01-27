#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/util/process_util'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_ProcessUtil_set_thread_name < Test::Unit::TestCase

	PU = ::Pantheios::Util::ProcessUtil

	def test_derive_process_name

		assert_equal 'abc', PU.derive_process_name('abc')

		assert_equal 'abc', PU.derive_process_name('abc.rb')

		assert_equal 'abc', PU.derive_process_name('abc.rb')
	end
end

