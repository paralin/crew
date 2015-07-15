#!/usr/bin/env bats

load test_helper

@test "(apps) apps" {
  create_app
  run bash -c "crew apps | grep $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_output $TEST_APP
  destroy_app
}

@test "(apps) apps:create" {
  run crew apps:create $TEST_APP
  echo "output: "$output
  echo "status: "$status
  assert_success
  destroy_app
}

@test "(apps) apps:destroy" {
  create_app
  run bash -c "crew --force apps:destroy $TEST_APP"
  echo "output: "$output
  echo "status: "$status
  assert_success
}
