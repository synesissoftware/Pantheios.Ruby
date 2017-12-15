#!/bin/bash

#############################################################################
# File:         test_unit.sh
#
# Purpose:      Executes the unit-tests regardless of calling directory
#
# Created:      9th June 2011
# Updated:      9th June 2011
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
#############################################################################

source="${BASH_SOURCE[0]}"
while [ -h "$source" ]; do
  dir="$(cd -P "$(dirname "$source")" && pwd)"
  source="$(readlink "$source")"
  [[ $source != /* ]] && source="$dir/$source"
done
dir="$( cd -P "$( dirname "$source" )" && pwd )"

#echo $dir
$dir/test/unit/ts_all.rb

