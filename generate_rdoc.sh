#!/bin/bash

#############################################################################
# File:         generate_rdoc.sh
#
# Purpose:      Generates documentation
#
# Created:      11th June 2016
# Updated:      11th June 2016
#
#############################################################################

rm -rfd doc
rdoc \
	-x build_gem.sh \
	-x generate_rdoc.sh \
	-x run_all_unit_tests.sh \
	-x test \
	-x lib/clasp/old_module.rb \
	-x examples \
	-x CLASP.gemspec \


