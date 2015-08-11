#!/usr/bin/env bats

load test_helper

@test "(scratch) scratch:build" {
  run crew scratch:build ros:indigo
  echo "output: "$output
  echo "status: "$status
  assert_success
  run docker images | grep "ros" | grep "indigo"
  echo "output: "$output
  echo "status: "$status
  assert_success
}
