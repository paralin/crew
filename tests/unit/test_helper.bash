#!/usr/bin/env bash

# constants
CREW_ROOT=${CREW_ROOT:=~crew}
PLUGIN_PATH=${PLUGIN_PATH:="/var/lib/crew/plugins"}
TEST_APP=my-cool-guy-test-app

# test functions
flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$*"
    fi
  }
  return 1
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then return 0; fi
    done
    flunk "expected line \`$1'"
  fi
}

refute_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    local num_lines="${#lines[@]}"
    if [ "$1" -lt "$num_lines" ]; then
      flunk "output has $num_lines lines"
    fi
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then
        flunk "expected to not find line \`$line'"
      fi
    done
  fi
}

assert() {
  if ! "$*"; then
    flunk "failed: $*"
  fi
}

assert_exit_status() {
  assert_equal "$status" "$1"
}

# crew functions
create_app() {
  crew apps:create $TEST_APP
}

destroy_app() {
  local RC="$1"; local RC=${RC:=0}
  local TEST_APP="$2"; local TEST_APP=${TEST_APP:=my-cool-guy-test-app}
  echo $TEST_APP | crew apps:destroy $TEST_APP
  return $RC
}

deploy_app() {
  APP_TYPE="$1"; APP_TYPE=${APP_TYPE:="nodejs-express"}
  GIT_REMOTE="$2"; GIT_REMOTE=${GIT_REMOTE:="crew@crew.me:$TEST_APP"}
  TMP=$(mktemp -d -t "crew.me.XXXXX")
  rmdir $TMP && cp -r ./tests/apps/$APP_TYPE $TMP
  cd $TMP
  git init
  git config user.email "robot@example.com"
  git config user.name "Test Robot"
  echo "setting up remote: $GIT_REMOTE"
  git remote add target $GIT_REMOTE

  [[ -f gitignore ]] && mv gitignore .gitignore
  git add .
  git commit -m 'initial commit'
  git push target master || destroy_app $?
}

setup_client_repo() {
  TMP=$(mktemp -d -t "crew.me.XXXXX")
  rmdir $TMP && cp -r ./tests/apps/nodejs-express $TMP
  cd $TMP
  git init
  git config user.email "robot@example.com"
  git config user.name "Test Robot"

  [[ -f gitignore ]] && mv gitignore .gitignore
  git add .
  git commit -m 'initial commit'
}
