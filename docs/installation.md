# Installation

## Requirements

- A fresh VM running Ubuntu `14.04 x64`

Ubuntu 14.04 x64 x64. Ideally have a domain ready to point to your host. It's designed for and is probably best to use a fresh VM. The bootstrapper will install everything it needs.

## Installing the latest Stable version

To install the latest stable version of crew, you can run the following bootstrapper command:

```shell
# installs crew via apt-get
wget https://raw.github.com/progrium/crew/v0.3.21/bootstrap.sh
sudo CREW_TAG=v0.3.21 bash bootstrap.sh

# By default, this will do cli-based setup, though you may *also*
# go to your server's IP and follow the web installer
```

For various reasons, certain hosting providers may have other steps that should be preferred to the above. If hosted on any of the following popular hosts, please follow the linked to instructions:

- [Digital Ocean Installation Notes](http://progrium.viewdocs.io/crew/getting-started/install/digitalocean)
- [Linode Installation Notes](http://progrium.viewdocs.io/crew/getting-started/install/linode)

As well, you may wish to customize your installation in some other fashion. or experiment with vagrant. The guides below should get you started:

- [Debian Package Installation Notes](http://progrium.viewdocs.io/crew/getting-started/install/debian)
- [Vagrant Installation Notes](http://progrium.viewdocs.io/crew/getting-started/install/vagrant)
- [Advanced Install Customization](http://progrium.viewdocs.io/crew/advanced-installation)
