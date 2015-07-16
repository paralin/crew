#!/usr/bin/env bats

load test_helper

setup() {
  create_app
}

teardown() {
  rm -rf /home/crew/$TEST_APP/tls /home/crew/tls
  destroy_app
  disable_tls_wildcard
}

@test "(core) remove exited containers" {
  deploy_app
  # make sure we have many exited containers of the same 'type'
  run bash -c "for cnt in 1 2 3; do crew run $TEST_APP hostname; done"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run bash -c "docker ps -a -f 'status=exited' --no-trunc=false | grep '/exec hostname'"
  echo "output: "$output
  echo "status: "$status
  assert_success
  run crew cleanup
  echo "output: "$output
  echo "status: "$status
  assert_success
  sleep 5  # wait for crew cleanup to happen in the background
  run bash -c "docker ps -a -f 'status=exited' --no-trunc=false | grep '/exec hostname'"
  echo "output: "$output
  echo "status: "$status
  assert_failure
  run bash -c "docker ps -a -f 'status=exited' -q --no-trunc=false"
  echo "output: "$output
  echo "status: "$status
  assert_output ""
}

@test "(core) run (with tty)" {
  deploy_app
  run /bin/bash -c "crew run $TEST_APP ls /app/package.json"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(core) run (without tty)" {
  deploy_app
  run /bin/bash -c ": |crew run $TEST_APP ls /app/package.json"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(core) run (with --options)" {
  deploy_app
  run /bin/bash -c "crew --force --quiet run $TEST_APP bash --version"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(core) unknown command" {
  run /bin/bash -c "crew fakecommand"
  echo "output: "$output
  echo "status: "$status
  assert_failure
  run /bin/bash -c "crew fakecommand | grep -q 'is not a crew command'"
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(core) git-remote (off-port)" {
  run deploy_app dockerfile ssh://crew@127.0.0.1:22333/$TEST_APP
  echo "output: "$output
  echo "status: "$status
  assert_success
}
