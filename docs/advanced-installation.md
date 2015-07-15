# Advanced installation

You can always install crew straight from the latest - potentially unstable - master release via the following bash command:

```shell
wget -qO- https://raw.github.com/progrium/crew/master/bootstrap.sh | sudo CREW_BRANCH=master bash
```

## Development

If you plan on developing crew, the easiest way to install from your own repository is cloning the repository and calling the install script. Example:

```shell
git clone https://github.com/yourusername/crew.git
cd crew
sudo make install
```

The `Makefile` allows source URLs to be overridden to include customizations from your own repositories. The `DOCKER_URL`, `PLUGINHOOK_URL`, `SSHCOMMAND_URL` and `STACK_URL` environment variables may be set to override the defaults (see the `Makefile` for how these apply). Example:

```shell
sudo SSHCOMMAND_URL=https://raw.github.com/yourusername/sshcommand/master/sshcommand make install
```

## Bootstrap a server from your own repository

The bootstrap script allows the crew repository URL to be overridden to bootstrap a host from your own clone of crew using the `CREW_REPO` environment variable. Example:

```shell
wget https://raw.github.com/progrium/crew/master/bootstrap.sh
chmod +x bootstrap.sh
sudo CREW_REPO=https://github.com/yourusername/crew.git CREW_BRANCH=master ./bootstrap.sh
```

## Custom buildstep build

Crew ships with a pre-built version of version of the [buildstep](https://github.com/progrium/buildstep) component by default. If you want to build your own version you can specify that with an env variable.

```shell
git clone https://github.com/progrium/crew.git
cd crew
sudo BUILD_STACK=true STACK_URL=https://github.com/progrium/buildstep.git make install
```

## Configuring

Once crew is installed, if you are not using the web-installer, you'll want to configure a the virtualhost setup as well as the push user. If you do not, your installation will be considered incomplete and you will not be able to deploy applications.

Set up a domain and a wildcard domain pointing to that host. Make sure `/home/crew/VHOST` is set to this domain. By default it's set to whatever hostname the host has. This file is only created if the hostname can be resolved by dig (`dig +short $(hostname -f)`). Otherwise you have to create the file manually and set it to your preferred domain. If this file still is not present when you push your app, crew will publish the app with a port number (i.e. `http://example.com:49154` - note the missing subdomain).

You'll have to add a public key associated with a username by doing something like this from your local machine:

    $ cat ~/.ssh/id_rsa.pub | ssh crew.me "sudo sshcommand acl-add crew $USER"

If you are using the vagrant installation, you can use the following command to add your public key to crew:

    $ cat ~/.ssh/id_rsa.pub | make vagrant-acl-add

That's it!
