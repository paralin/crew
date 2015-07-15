#!/usr/bin/env bats

load test_helper

setup() {
  create_app
}

teardown() {
  destroy_app
}

@test "(events) check conffiles" {
  run bash -c "test -f /etc/logrotate.d/crew"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "test -f /etc/rsyslog.d/99-crew.conf"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "stat -c '%U:%G:%a' /var/log/crew/"
  echo "output: "$output
  echo "status: "$status
  assert_output "syslog:crew:775"
  run bash -c "stat -c '%U:%G:%a' /var/log/crew/events.log"
  echo "output: "$output
  echo "status: "$status
  assert_output "syslog:crew:664"
}

@test "(events) log commands" {
  run crew events:on
  deploy_app
  run crew events
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew events:off
}
