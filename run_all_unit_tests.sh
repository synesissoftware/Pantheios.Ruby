#!/bin/bash

#############################################################################
# File:         run_all_unit_tests.sh
#
# Purpose:      Executes all unit-tests regardless of calling directory
#
# Created:      14th July 2015
# Updated:      14th July 2015
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

