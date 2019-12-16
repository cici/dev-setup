#!/usr/bin/env bash

echo "This is a script to test the issues\n"

source ./log_utils.sh

log_info "From log info"


test_func() {
   echo "Inside test_func\n"
   ./test2.sh
}

test_func

echo "This is the end of the test script\n"
