#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/util/version_util'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_VersionUtil_version_compare < Test::Unit::TestCase

	VU = ::Pantheios::Util::VersionUtil

	def test_equal_strings

		assert_equal 0, VU.version_compare('1.0.0', '1.0.0')
		assert_equal 0, VU.version_compare('1.2.3', '1.2.3')
		assert_equal 0, VU.version_compare('1.2', '1.2')
		assert_equal 0, VU.version_compare('1', '1')
	end

	def test_unequal_strings

		assert_not_equal 0, VU.version_compare('1.0.0', '1.0.1')
		assert_not_equal 0, VU.version_compare('1.2.3', '1.3.3')
		assert_not_equal 0, VU.version_compare('1.2.3', '1.3')
		assert_not_equal 0, VU.version_compare('1.2', '2.2')
		assert_not_equal 0, VU.version_compare('1', '2')
		assert_not_equal 0, VU.version_compare('1.2.3.4.5.6.7.8.9', '2')

		assert VU.version_compare('1.0.0', '1.0.1') < 0
		assert VU.version_compare('0.0.9', '1.0.0') < 0

		assert VU.version_compare('1.0.1', '1.0.0') > 0
		assert VU.version_compare('1.0.0', '0.0.9') > 0
	end

	def test_equal_arrays

		assert_equal 0, VU.version_compare([ 1, 0, 0 ], [ 1, 0, 0 ])
		assert_equal 0, VU.version_compare([ 1, 2, 3 ], [ 1, 2, 3 ])
		assert_equal 0, VU.version_compare([ 1, 2 ], [ 1, 2 ])
		assert_equal 0, VU.version_compare([ 1 ], [ 1 ])
	end

	def test_unequal_arrays

		assert_not_equal 0, VU.version_compare([ 1, 0, 0 ], [ 1, 0, 1 ])
		assert_not_equal 0, VU.version_compare([ 1, 2, 3 ], [ 1, 3, 3 ])
		assert_not_equal 0, VU.version_compare([ 1, 2, 3 ], [ 1, 3 ])
		assert_not_equal 0, VU.version_compare([ 1, 2 ], [ 2, 2 ])
		assert_not_equal 0, VU.version_compare([ 1 ], [ 2 ])
		assert_not_equal 0, VU.version_compare([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ], [ 2 ])

		assert VU.version_compare([ 1, 0, 0 ], [ 1, 0, 1 ]) < 0
		assert VU.version_compare([ 0, 0, 9 ], [ 1, 0, 0 ]) < 0

		assert VU.version_compare([ 1, 0, 1 ], [ 1, 0, 0 ]) > 0
		assert VU.version_compare([ 1, 0, 0 ], [ 0, 0, 9 ]) > 0
	end


	def test_equal_heterogenous_types

		assert_equal 0, VU.version_compare('1.0.0', [ 1, 0, 0 ])
		assert_equal 0, VU.version_compare([ 1, 0, 0 ], '1.0.0')

		assert_equal 0, VU.version_compare('1.2.3', [ 1, 2, 3 ])
		assert_equal 0, VU.version_compare([ 1, 2, 3 ], '1.2.3')

		assert_equal 0, VU.version_compare('1.2', [ 1, 2 ])
		assert_equal 0, VU.version_compare([ 1, 2 ], '1.2')

		assert_equal 0, VU.version_compare('1', [ 1 ])
		assert_equal 0, VU.version_compare([ 1 ], '1')
	end

end

