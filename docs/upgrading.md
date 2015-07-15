# Upgrading

This document covers upgrades for the 0.3.0 series and up. If upgrading from previous versions, we recommend [a fresh install](http://progrium.viewdocs.io/crew/installation) on a new server.

> As of 0.3.18, crew is installed by default via a debian package. Source-based installations are still available, though not recommended.

## Crew

If crew was installed via a debian package, you can upgrade crew via the following command:

```shell
sudo apt-get install crew
```

For unattended upgrades, you may run the following command:

```shell
sudo apt-get install -qq -y crew
```

If you have installed crew from source, you may run the following commands to upgrade:

```shell
cd ~/crew
git pull --tags origin master

# continue to install from source
sudo CREW_BRANCH=master make install

# upgrade to debian package-based installation
sudo make install
```

All changes will take effect upon next application deployment. To trigger a rebuild of every application, simply run the following command:

```shell
crew ps:rebuildall
```

## Buildstep image

If crew was installed via a debian package, you can upgrade buildstep via the following command:

```shell
sudo apt-get install buildstep
```

For unattended upgrades, you may run the following command:

```shell
sudo apt-get install -qq -y buildstep
```

In some cases, it may be desirable to run a specific version of buildstep. To install/upgrade buildstep from source, run the following commands:

```shell
cd /tmp
git clone https://github.com/progrium/buildstep.git
cd buildstep
git pull origin master
sudo make build
```
