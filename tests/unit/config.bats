#!/usr/bin/env bats

load test_helper

setup() {
  [[ -f $CREW_ROOT/ENV ]] && mv -f $CREW_ROOT/ENV $CREW_ROOT/ENV.bak
  sudo -H -u crew /bin/bash -c "echo 'export global_test=true' > $CREW_ROOT/ENV"
  create_app
}

teardown() {
  destroy_app
  [[ -f $CREW_ROOT/ENV.bak ]] && mv -f $CREW_ROOT/ENV.bak $CREW_ROOT/ENV
}

@test "(config) config:set --global" {
  run ssh crew@crew.me config:set --global test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(config) config:get --global" {
  run ssh crew@crew.me config:set --global test_var=true test_var2=\"hello world\" test_var3=\"with\\nnewline\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:get --global test_var2
  echo "output: "$output
  echo "status: "$status
  assert_output 'hello world'
  run crew config:get --global test_var3
  echo "output: "$output
  echo "status: "$status
  assert_output 'with\nnewline'
}

@test "(config) config:unset --global" {
  run ssh crew@crew.me config:set --global test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:get --global test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:unset --global test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:get --global test_var
  echo "output: "$output
  echo "status: "$status
  assert_output ""
}

@test "(config) config:set" {
  run ssh crew@crew.me config:set $TEST_APP test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(config) config:get" {
  run ssh crew@crew.me config:set $TEST_APP test_var=true test_var2=\"hello world\" test_var3=\"with\\nnewline\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:get $TEST_APP test_var2
  echo "output: "$output
  echo "status: "$status
  assert_output 'hello world'
  run crew config:get $TEST_APP test_var3
  echo "output: "$output
  echo "status: "$status
  assert_output 'with\nnewline'
}

@test "(config) config:unset" {
  run ssh crew@crew.me config:set $TEST_APP test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:get $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:unset $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew config:get $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_output ""
}

@test "(config) global config (dockerfile)" {
  deploy_app dockerfile
  run bash -c "crew run $TEST_APP env | egrep '^global_test=true'"
  echo "output: "$output
  echo "status: "$status
  assert_success
}
