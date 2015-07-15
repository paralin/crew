#!/usr/bin/env bats

load test_helper

setup() {
  export CREW_HOST=crew.me
  create_app
}

teardown() {
  destroy_app
  unset CREW_HOST
}

@test "(client) unconfigured CREW_HOST" {
  unset CREW_HOST
  run ./contrib/crew_client.sh apps
  echo "output: "$output
  echo "status: "$status
  assert_exit_status 20
}

@test "(client) no args should print help" {
  run /bin/bash -c "./contrib/crew_client.sh | head -1 | egrep -q '^Usage: crew \[.+\] COMMAND <app>.*'"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(client) apps:create AND apps:destroy" {
  setup_client_repo
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh apps:create"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh --force apps:destroy"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(client) config:set" {
  run ./contrib/crew_client.sh config:set $TEST_APP test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run /bin/bash -c "./contrib/crew_client.sh config:get $TEST_APP test_var2 | grep -q 'hello world'"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(client) config:unset" {
  run ./contrib/crew_client.sh config:set $TEST_APP test_var=true test_var2=\"hello world\"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/crew_client.sh config:get $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run ./contrib/crew_client.sh config:unset $TEST_APP test_var
  echo "output: "$output
  echo "status: "$status
  assert_success
  run /bin/bash -c "./contrib/crew_client.sh config:get $TEST_APP test_var | grep test_var"
  echo "output: "$output
  echo "status: "$status
  assert_failure
}

# @test "(client) ps" {
#   # CI support: 'Ah. I just spoke with our Docker expert --
#   # looks like docker exec is built to work with docker-under-libcontainer,
#   # but we're using docker-under-lxc. I don't have an estimated time for the fix, sorry
#   skip "circleci does not support docker exec at the moment."
#   deploy_app
#   run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh ps $TEST_APP | grep -q 'node web.js'"
#   echo "output: "$output
#   echo "status: "$status
#   assert_success
# }

@test "(client) ps:start" {
  deploy_app
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh ps:stop $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh ps:start $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  for CID_FILE in $CREW_ROOT/$TEST_APP/CONTAINER.*; do
    run bash -c "docker ps -q --no-trunc | grep -q $(< $CID_FILE)"
    echo "output: "$output
    echo "status: "$status
    assert_success
  done
}

@test "(client) ps:stop" {
  deploy_app
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh ps:stop $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  for CID_FILE in $CREW_ROOT/$TEST_APP/CONTAINER.*; do
    run bash -c "docker ps -q --no-trunc | grep -q $(< $CID_FILE)"
    echo "output: "$output
    echo "status: "$status
    assert_failure
  done
}

@test "(client) ps:restart" {
  deploy_app
  run bash -c "${BATS_TEST_DIRNAME}/../../contrib/crew_client.sh ps:restart $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
  for CID_FILE in $CREW_ROOT/$TEST_APP/CONTAINER.*; do
    run bash -c "docker ps -q --no-trunc | grep -q $(< $CID_FILE)"
    echo "output: "$output
    echo "status: "$status
    assert_success
  done
}
