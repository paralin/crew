CREW_DESCRIPTION = 'Docker powered mini-Heroku in around 100 lines of Bash'
CREW_REPO_NAME ?= progrium/crew
CREW_ARCHITECTURE = amd64

PLUGINHOOK_DESCRIPTION = 'Simple dispatcher and protocol for shell-based plugins, an improvement to hook scripts'
PLUGINHOOK_REPO_NAME ?= progrium/pluginhook
PLUGINHOOK_VERSION ?= 0.0.1
PLUGINHOOK_ARCHITECTURE = amd64
PLUGINHOOK_PACKAGE_NAME = pluginhook_$(PLUGINHOOK_VERSION)_$(PLUGINHOOK_ARCHITECTURE).deb

SSHCOMMAND_DESCRIPTION = 'Turn SSH into a thin client specifically for your app'
SSHCOMMAND_REPO_NAME ?= progrium/sshcommand
SSHCOMMAND_VERSION ?= 0.0.1
SSHCOMMAND_ARCHITECTURE = amd64
SSHCOMMAND_PACKAGE_NAME = sshcommand_$(SSHCOMMAND_VERSION)_$(SSHCOMMAND_ARCHITECTURE).deb

GEM_ARCHITECTURE = amd64

GOROOT = /usr/lib/go
GOBIN = /usr/bin/go
GOPATH = /home/vagrant/gocode

.PHONY: install-from-deb deb-all deb-crew deb-gems deb-pluginhook deb-setup deb-sshcommand

install-from-deb:
	echo "--> Initial apt-get update"
	sudo apt-get update > /dev/null
	sudo apt-get install -y apt-transport-https curl

	echo "--> Installing docker gpg key"
	curl -sSL https://get.docker.com/gpg | apt-key add -

	echo "--> Installing crew gpg key"
	curl --silent https://packagecloud.io/gpg.key 2> /dev/null | apt-key add - 2>&1 >/dev/null

	echo "--> Setting up apt repositories"
	echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
	echo "deb https://packagecloud.io/crew/crew/ubuntu/ trusty main" > /etc/apt/sources.list.d/crew.list

	echo "--> Running apt-get update"
	sudo apt-get update > /dev/null

	echo "--> Installing pre-requisites"
	sudo apt-get install -y linux-image-extra-`uname -r`

	echo "--> Installing crew"
	sudo apt-get install -y crew

	echo "--> Done!"

deb-all: deb-crew deb-gems deb-pluginhook deb-sshcommand
	mv /tmp/*.deb .
	echo "Done"

deb-setup:
	echo "-> Updating deb repository and installing build requirements"
	sudo apt-get update > /dev/null
	sudo apt-get install -qq -y gcc git ruby1.9.1-dev 2>&1 > /dev/null
	command -v fpm > /dev/null || sudo gem install fpm --no-ri --no-rdoc
	ssh -o StrictHostKeyChecking=no git@github.com || true

deb-crew: deb-setup
	rm -rf /tmp/tmp /tmp/build crew_*_$(CREW_ARCHITECTURE).deb
	mkdir -p /tmp/tmp /tmp/build

	cp -r debian /tmp/build/DEBIAN
	mkdir -p /tmp/build/usr/local/bin
	mkdir -p /tmp/build/var/lib/crew
	mkdir -p /tmp/build/usr/local/share/man/man1
	mkdir -p /tmp/build/usr/local/share/crew/contrib

	cp crew /tmp/build/usr/local/bin
	cp -r plugins /tmp/build/var/lib/crew
	find plugins/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | while read plugin; do touch /tmp/build/var/lib/crew/plugins/$$plugin/.core; done
	$(MAKE) help2man
	$(MAKE) addman
	cp /usr/local/share/man/man1/crew.1 /tmp/build/usr/local/share/man/man1/crew.1
	cp contrib/crew-installer.rb /tmp/build/usr/local/share/crew/contrib
	git describe --tags > /tmp/build/var/lib/crew/VERSION
	cat /tmp/build/var/lib/crew/VERSION | cut -d '-' -f 1 | cut -d 'v' -f 2 > /tmp/build/var/lib/crew/STABLE_VERSION
	git rev-parse HEAD > /tmp/build/var/lib/crew/GIT_REV
	sed -i "s/^Version: .*/Version: `cat /tmp/build/var/lib/crew/STABLE_VERSION`/g" /tmp/build/DEBIAN/control
	dpkg-deb --build /tmp/build "/vagrant/crew_`cat /tmp/build/var/lib/crew/STABLE_VERSION`_$(CREW_ARCHITECTURE).deb"
	mv *.deb /tmp

deb-gems: deb-setup
	rm -rf /tmp/tmp /tmp/build rubygem-*.deb
	mkdir -p /tmp/tmp /tmp/build

	gem install --quiet --no-verbose --no-ri --no-rdoc --install-dir /tmp/tmp rack -v 1.5.2 > /dev/null
	gem install --quiet --no-verbose --no-ri --no-rdoc --install-dir /tmp/tmp rack-protection -v 1.5.3 > /dev/null
	gem install --quiet --no-verbose --no-ri --no-rdoc --install-dir /tmp/tmp sinatra -v 1.4.5 > /dev/null
	gem install --quiet --no-verbose --no-ri --no-rdoc --install-dir /tmp/tmp tilt -v 1.4.1 > /dev/null

	find /tmp/tmp/cache -name '*.gem' | xargs -rn1 fpm -d ruby -d ruby --prefix /var/lib/gems/1.9.1 -s gem -t deb -a $(GEM_ARCHITECTURE)
	mv *.deb /tmp

deb-pluginhook: deb-setup
	rm -rf /tmp/tmp /tmp/build $(PLUGINHOOK_PACKAGE_NAME)
	mkdir -p /tmp/tmp /tmp/build

	echo "-> Cloning repository"
	git clone -q "git@github.com:$(PLUGINHOOK_REPO_NAME).git" /tmp/tmp/pluginhook > /dev/null
	rm -rf /tmp/tmp/pluginhook/.git /tmp/tmp/pluginhook/.gitignore

	echo "-> Copying files into place"
	mkdir -p /tmp/build/usr/local/bin $(GOPATH)
	sudo apt-get update > /dev/null
	sudo apt-get install -qq -y git golang mercurial 2>&1 > /dev/null
	export PATH=$(PATH):$(GOROOT)/bin:$(GOPATH)/bin && export GOROOT=$(GOROOT) && export GOPATH=$(GOPATH) && go get "code.google.com/p/go.crypto/ssh/terminal"
	export PATH=$(PATH):$(GOROOT)/bin:$(GOPATH)/bin && export GOROOT=$(GOROOT) && export GOPATH=$(GOPATH) && cd /tmp/tmp/pluginhook && go build -o pluginhook
	mv /tmp/tmp/pluginhook/pluginhook /tmp/build/usr/local/bin/pluginhook

	echo "-> Creating $(PLUGINHOOK_PACKAGE_NAME)"
	sudo fpm -t deb -s dir -C /tmp/build -n pluginhook -v $(PLUGINHOOK_VERSION) -a $(PLUGINHOOK_ARCHITECTURE) -p $(PLUGINHOOK_PACKAGE_NAME) --url "https://github.com/$(PLUGINHOOK_REPO_NAME)" --description $(PLUGINHOOK_DESCRIPTION) --license 'MIT License' .
	mv *.deb /tmp

deb-sshcommand: deb-setup
	rm -rf /tmp/tmp /tmp/build $(SSHCOMMAND_PACKAGE_NAME)
	mkdir -p /tmp/tmp /tmp/build

	echo "-> Cloning repository"
	git clone -q "git@github.com:$(SSHCOMMAND_REPO_NAME).git" /tmp/tmp/sshcommand > /dev/null
	rm -rf /tmp/tmp/sshcommand/.git /tmp/tmp/sshcommand/.gitignore

	echo "-> Copying files into place"
	mkdir -p "/tmp/build/usr/local/bin"
	cp /tmp/tmp/sshcommand/sshcommand /tmp/build/usr/local/bin/sshcommand
	chmod +x /tmp/build/usr/local/bin/sshcommand

	echo "-> Creating $(SSHCOMMAND_PACKAGE_NAME)"
	sudo fpm -t deb -s dir -C /tmp/build -n sshcommand -v $(SSHCOMMAND_VERSION) -a $(SSHCOMMAND_ARCHITECTURE) -p $(SSHCOMMAND_PACKAGE_NAME) --url "https://github.com/$(SSHCOMMAND_REPO_NAME)" --description $(SSHCOMMAND_DESCRIPTION) --license 'MIT License' .
	mv *.deb /tmp
