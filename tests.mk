shellcheck:
ifeq ($(shell shellcheck > /dev/null 2>&1 ; echo $$?),127)
ifeq ($(shell uname),Darwin)
		brew install shellcheck
else
		sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse'
		sudo apt-get update && sudo apt-get install -y shellcheck
endif
endif

ci-dependencies: shellcheck bats

setup-deploy-tests:
	mkdir -p /home/crew
ifdef ENABLE_CREW_TRACE
	echo "-----> Enabling tracing"
	echo "export CREW_TRACE=1" >> /home/crew/crewrc
endif
	@echo "Setting crew.me in /etc/hosts"
	sudo /bin/bash -c "[[ `ping -c1 crew.me > /dev/null 2>&1; echo $$?` -eq 0 ]] || echo \"127.0.0.1  crew.me *.crew.me www.test.app.crew.me\" >> /etc/hosts"

	@echo "-----> Generating keypair..."
	mkdir -p /root/.ssh
	rm -f /root/.ssh/crew_test_rsa*
	echo -e  "y\n" | ssh-keygen -f /root/.ssh/crew_test_rsa -t rsa -N ''
	chmod 600 /root/.ssh/crew_test_rsa*

	@echo "-----> Setting up ssh config..."
ifneq ($(shell ls /root/.ssh/config > /dev/null 2>&1 ; echo $$?),0)
	echo "Host crew.me \\r\\n RequestTTY yes \\r\\n IdentityFile /root/.ssh/crew_test_rsa" >> /root/.ssh/config
	echo "Host 127.0.0.1 \\r\\n Port 22333 \\r\\n RequestTTY yes \\r\\n IdentityFile /root/.ssh/crew_test_rsa" >> /root/.ssh/config
else ifeq ($(shell grep crew.me /root/.ssh/config),)
	echo "Host crew.me \\r\\n RequestTTY yes \\r\\n IdentityFile /root/.ssh/crew_test_rsa" >> /root/.ssh/config
	echo "Host 127.0.0.1 \\r\\n Port 22333 \\r\\n RequestTTY yes \\r\\n IdentityFile /root/.ssh/crew_test_rsa" >> /root/.ssh/config
endif

ifeq ($(shell grep 22333 /etc/ssh/sshd_config),)
	sed --in-place "s:^Port 22:Port 22 \\nPort 22333:g" /etc/ssh/sshd_config
	restart ssh
endif

	@echo "-----> Installing SSH public key..."
	sudo mkdir -p /home/crew/
	sudo chown -R crew:crew /home/crew/

	cat /root/.ssh/crew_test_rsa.pub | crew sshkey:add test

	@echo "-----> Intitial SSH connection to populate known_hosts..."
	ssh -o StrictHostKeyChecking=no crew@crew.me help > /dev/null
	ssh -o StrictHostKeyChecking=no crew@127.0.0.1 help > /dev/null

ifeq ($(shell grep crew.me /home/crew/VHOST 2>/dev/null),)
	@echo "-----> Setting default VHOST to crew.me..."
	echo "crew.me" > /home/crew/VHOST
endif

bats:
	git clone https://github.com/sstephenson/bats.git /tmp/bats
	cd /tmp/bats && sudo ./install.sh /usr/local
	rm -rf /tmp/bats

lint:
	# these are disabled due to their expansive existence in the codebase. we should clean it up though
	# SC2034: VAR appears unused - https://github.com/koalaman/shellcheck/wiki/SC2034
	# SC2086: Double quote to prevent globbing and word splitting - https://github.com/koalaman/shellcheck/wiki/SC2086
	# SC2143: Instead of [ -n $(foo | grep bar) ], use foo | grep -q bar - https://github.com/koalaman/shellcheck/wiki/SC2143
	# SC2001: See if you can use ${variable//search/replace} instead. - https://github.com/koalaman/shellcheck/wiki/SC2001
	# SC2076: Needed for RHS gobbing of regex functions in arch check
	@echo linting...
	@$(QUIET) shellcheck -e SC2029 ./contrib/crew_client.sh
	@$(QUIET) find . -not -path '*/\.*' | xargs file | egrep "shell|bash" | grep -v directory | awk '{ print $$1 }' | sed 's/://g' | grep -v crew_client.sh | xargs shellcheck -e SC2034,SC2086,SC2143,SC2001,SC2076

unit-tests:
	@echo running unit tests...
ifndef UNIT_TEST_BATCH
	@$(QUIET) bats tests/unit
else
	@$(QUIET) ./tests/ci/unit_test_runner.sh $$UNIT_TEST_BATCH
endif

deploy-test-checks-root:
	@echo deploying checks-root app...
	cd tests && ./test_deploy ./apps/checks-root crew.me '' true

deploy-test-dockerfile:
	@echo deploying dockerfile app...
	cd tests && ./test_deploy ./apps/dockerfile crew.me

deploy-tests:
	@echo running deploy tests...
	@$(QUIET) $(MAKE) deploy-test-checks-root
	@$(QUIET) $(MAKE) deploy-test-dockerfile

test: setup-deploy-tests lint unit-tests deploy-tests
