CREW_VERSION = master

SSHCOMMAND_URL ?= https://raw.github.com/progrium/sshcommand/master/sshcommand
PLUGINHOOK_URL ?= https://s3.amazonaws.com/progrium-pluginhook/pluginhook_0.1.0_amd64.deb
PLUGINS_PATH ?= /var/lib/crew/plugins
INSTALL ?= install

# If the first argument is "vagrant-crew"...
ifeq (vagrant-crew,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "vagrant-crew"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: all apt-update debinstall copyfiles man-db version plugins dependencies sshcommand pluginhook docker aufs stack count crew-installer vagrant-acl-add vagrant-crew

include tests.mk
include deb.mk

all:
	# Type "make install" to install.

install: dependencies copyfiles plugin-dependencies plugins version

release: deb-all package_cloud packer

package_cloud:
	package_cloud push crew/crew/ubuntu/trusty sshcommand*.deb
	package_cloud push crew/crew/ubuntu/trusty pluginhook*.deb
	package_cloud push crew/crew/ubuntu/trusty rubygem*.deb
	package_cloud push crew/crew/ubuntu/trusty crew*.deb

packer:
	packer build contrib/packer.json

copyfiles:
	cp crew /usr/local/bin/crew
	mkdir -p ${PLUGINS_PATH}
	find ${PLUGINS_PATH} -mindepth 2 -maxdepth 2 -name '.core' -printf '%h\0' | xargs -0 rm -Rf
	find plugins/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | while read plugin; do \
		rm -Rf ${PLUGINS_PATH}/$$plugin && \
		cp -R plugins/$$plugin ${PLUGINS_PATH} && \
		touch ${PLUGINS_PATH}/$$plugin/.core; \
		done
	$(MAKE) addman

addman:
	mkdir -p /usr/local/share/man/man1
	help2man -Nh help -v version -n "configure and get information from your crew installation" -o /usr/local/share/man/man1/crew.1 crew
	mandb

version:
	git describe --tags > ~crew/VERSION  2> /dev/null || echo '~${CREW_VERSION} ($(shell date -uIminutes))' > ~crew/VERSION

plugin-dependencies: pluginhook
	crew plugins-install-dependencies

plugins: pluginhook docker
	crew plugins-install

dependencies: apt-update sshcommand pluginhook docker help2man man-db
	$(MAKE) -e stack

apt-update:
	apt-get update

help2man:
	apt-get install -qq -y help2man

man-db:
	apt-get install -qq -y man-db

sshcommand:
	wget -qO /usr/local/bin/sshcommand ${SSHCOMMAND_URL}
	chmod +x /usr/local/bin/sshcommand
	sshcommand create crew /usr/local/bin/crew

pluginhook:
	wget -qO /tmp/pluginhook_0.1.0_amd64.deb ${PLUGINHOOK_URL}
	dpkg -i /tmp/pluginhook_0.1.0_amd64.deb

docker: aufs
	apt-get install -qq -y curl
	egrep -i "^docker" /etc/group || groupadd docker
	usermod -aG docker crew
ifndef CI
	curl -sSL https://get.docker.com/gpg | apt-key add -
	echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
	apt-get update
ifdef DOCKER_VERSION
	apt-get install -qq -y lxc-docker-${DOCKER_VERSION}
else
	apt-get install -qq -y lxc-docker-1.6.2
endif
	sleep 2 # give docker a moment i guess
endif

aufs:
ifndef CI
	lsmod | grep aufs || modprobe aufs || apt-get install -qq -y linux-image-extra-`uname -r` > /dev/null
endif

stack:

count:
	@echo "Core lines:"
	@cat crew bootstrap.sh | egrep -v "^$$" | wc -l
	@echo "Plugin lines:"
	@find plugins -type f | xargs cat | egrep -v "^$$" | wc -l
	@echo "Test lines:"
	@find tests -type f | xargs cat | egrep -v "^$$" |wc -l

crew-installer:

vagrant-acl-add:
	vagrant ssh -- sudo sshcommand acl-add crew $(USER)

vagrant-crew:
	vagrant ssh -- "sudo -H -u root bash -c 'crew $(RUN_ARGS)'"

# Try to install without any deb stuff
install:
	-rm -rf /var/lib/crew/
	mkdir -p /var/lib/crew/plugins/
	$(INSTALL) -D ./plugins/ /var/lib/crew/plugins/ -m 0755
	$(INSTALL) -m 0755 ./crew /usr/local/bin
