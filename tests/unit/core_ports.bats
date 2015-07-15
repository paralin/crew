#!/usr/bin/env bats

load test_helper

setup() {
  [[ -f "$CREW_ROOT/VHOST" ]] && cp -f "$CREW_ROOT/VHOST" "$CREW_ROOT/VHOST.bak"
  [[ -f "$CREW_ROOT/HOSTNAME" ]] && cp -f "$CREW_ROOT/HOSTNAME" "$CREW_ROOT/HOSTNAME.bak"
  DOCKERFILE="$BATS_TMPDIR/Dockerfile"
}

teardown() {
  destroy_app
  [[ -f "$CREW_ROOT/VHOST.bak" ]] && mv "$CREW_ROOT/VHOST.bak" "$CREW_ROOT/VHOST"
  [[ -f "$CREW_ROOT/HOSTNAME.bak" ]] && mv "$CREW_ROOT/HOSTNAME.bak" "$CREW_ROOT/HOSTNAME"
}


check_urls() {
  local PATTERN="$1"
  run bash -c "crew --quiet urls $TEST_APP | egrep \"${1}\""
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(core) port exposure (with global VHOST)" {
  echo "crew.me" > "$CREW_ROOT/VHOST"
  deploy_app
  CONTAINER_ID=$(< $CREW_ROOT/$TEST_APP/CONTAINER.web.1)
  run bash -c "docker port $CONTAINER_ID | sed 's/[0-9.]*://' | egrep -q '[0-9]*'"
  echo "output: "$output
  echo "status: "$status
  assert_failure

  check_urls http://${TEST_APP}.crew.me
}

@test "(core) port exposure (without global VHOST and real HOSTNAME)" {
  rm "$CREW_ROOT/VHOST"
  echo "${TEST_APP}.crew.me" > "$CREW_ROOT/HOSTNAME"
  deploy_app
  CONTAINER_ID=$(< $CREW_ROOT/$TEST_APP/CONTAINER.web.1)
  run bash -c "docker port $CONTAINER_ID | sed 's/[0-9.]*://' | egrep -q '[0-9]*'"
  echo "output: "$output
  echo "status: "$status
  assert_success

  HOSTNAME=$(< "$CREW_ROOT/HOSTNAME")
  check_urls http://${HOSTNAME}:[0-9]+
}

@test "(core) port exposure (with NO_VHOST set)" {
  deploy_app
  crew config:set $TEST_APP NO_VHOST=1
  CONTAINER_ID=$(< $CREW_ROOT/$TEST_APP/CONTAINER.web.1)
  run bash -c "docker port $CONTAINER_ID | sed 's/[0-9.]*://' | egrep -q '[0-9]*'"
  echo "output: "$output
  echo "status: "$status
  assert_success

  HOSTNAME=$(< "$CREW_ROOT/HOSTNAME")
  check_urls http://${HOSTNAME}:[0-9]+
}

@test "(core) port exposure (without global VHOST and IPv4 address as HOSTNAME)" {
  rm "$CREW_ROOT/VHOST"
  echo "127.0.0.1" > "$CREW_ROOT/HOSTNAME"
  deploy_app
  CONTAINER_ID=$(< $CREW_ROOT/$TEST_APP/CONTAINER.web.1)
  run bash -c "docker port $CONTAINER_ID | sed 's/[0-9.]*://' | egrep -q '[0-9]*'"
  echo "output: "$output
  echo "status: "$status
  assert_success

  HOSTNAME=$(< "$CREW_ROOT/HOSTNAME")
  check_urls http://${HOSTNAME}:[0-9]+
}

@test "(core) port exposure (without global VHOST and IPv6 address as HOSTNAME)" {
  rm "$CREW_ROOT/VHOST"
  echo "fda5:c7db:a520:bb6d::aabb:ccdd:eeff" > "$CREW_ROOT/HOSTNAME"
  deploy_app
  CONTAINER_ID=$(< $CREW_ROOT/$TEST_APP/CONTAINER.web.1)
  run bash -c "docker port $CONTAINER_ID | sed 's/[0-9.]*://' | egrep -q '[0-9]*'"
  echo "output: "$output
  echo "status: "$status
  assert_success

  HOSTNAME=$(< "$CREW_ROOT/HOSTNAME")
  check_urls http://${HOSTNAME}:[0-9]+
}

@test "(core) port exposure" {
  create_app
  echo "output: "$output
  echo "status: "$status
  assert_success

  deploy_app
  sleep 5

  CONTAINER_ID=$(< $CREW_ROOT/$TEST_APP/CONTAINER.web.1)
  run bash -c "docker port $CONTAINER_ID | sed 's/[0-9.]*://' | egrep -q '[0-9]*'"
  echo "output: "$output
  echo "status: "$status
  assert_failure

  run bash -c "response=\"$(curl -s -S www.test.app.crew.me)\"; echo \$response; test \"\$response\" == \"nodejs/express\""
  echo "output: "$output
  echo "status: "$status
  assert_success
}

@test "(core) port exposure (dockerfile raw port)" {
  source "$PLUGIN_PATH/common/functions"
  cat<<EOF > $DOCKERFILE
EXPOSE 3001/udp
EXPOSE 3003
EXPOSE  3000/tcp
EOF
  run get_dockerfile_exposed_port $DOCKERFILE
  echo "output: "$output
  echo "status: "$status
  assert_output 3003
}

@test "(core) port exposure (dockerfile tcp port)" {
  source "$PLUGIN_PATH/common/functions"
  cat<<EOF > $DOCKERFILE
EXPOSE 3001/udp
EXPOSE  3000/tcp
EXPOSE 3003
EOF
  run get_dockerfile_exposed_port $DOCKERFILE
  echo "output: "$output
  echo "status: "$status
  assert_output 3000
}
