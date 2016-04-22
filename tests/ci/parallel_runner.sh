#!/usr/bin/env bash

MODE="$1"; MODE=${MODE:="testing"}

setup_circle() {
  MAKE_ENV="CI=true"
  echo "setting up with MAKE_ENV: $MAKE_ENV"
  sudo adduser --disabled-password --gecos "" crew
  sudo mkdir /home/crew/.ssh/
  sudo touch /home/crew/.ssh/authorized_keys
  sudo chmod 0700 /home/crew/.ssh/
  sudo chmod 0600 /home/crew/.ssh/authorized_keys
  sudo chown -R crew:crew /home/crew/
  # need to add the crew user to the docker group
  sudo usermod -G docker crew
  #### circle does some weird *expletive* with regards to root and gh auth (needed for gitsubmodules test)
  sudo rsync -a ~ubuntu/.ssh/ ~root/.ssh/
  sudo chown -R root:root ~root/.ssh/
  sudo sed --in-place 's:/home/ubuntu:/root:g' ~root/.ssh/config
  ####
  sudo -E $MAKE_ENV make -e install
  sudo -E make -e setup-deploy-tests
  make -e ci-dependencies
}

if [ -n "$CIRCLE_MULTINODE" ]; then
  case "$CIRCLE_NODE_INDEX" in
    0)
      echo "=====> make unit-tests (1/2) on CIRCLE_NODE_INDEX: $CIRCLE_NODE_INDEX"
      [[ "$MODE" == "setup" ]] && setup_circle && exit 0
      sudo -E UNIT_TEST_BATCH=1 make -e unit-tests
      ;;

    1)
      echo "=====> make unit-tests (2/2) on CIRCLE_NODE_INDEX: $CIRCLE_NODE_INDEX"
      [[ "$MODE" == "setup" ]] && setup_circle && exit 0
      sudo -E UNIT_TEST_BATCH=2 make -e unit-tests
      ;;
  esac
else
      echo "=====> make unit-tests (1/2)"
      [[ "$MODE" == "setup" ]] && setup_circle && exit 0

      sudo -E UNIT_TEST_BATCH=1 make -e unit-tests
      echo "=====> make unit-tests (2/2)"
      sudo -E UNIT_TEST_BATCH=2 make -e unit-tests
fi
