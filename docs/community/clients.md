# Clients

Given the constraints, running crew commands remotely via SSH is fine. For certain configurations, the extra complication of manually invoking ssh can be a burden.

While crew does not yet have an official client, there are a multitude of ways in which you can interact with your crew installation. The easiest is to use the **bash** client, though you may wish to use another.

## (bash) `crew_client.sh`

Of all methods, this is the *most* official method of interacting with your crew installation. It is a bash script that interacts with a remote crew installation via ssh. It is available in `contrib/crew_client.sh` in the root of the crew repository.

To install, simply clone the crew repository down and add the `crew` alias pointing at the script:

```shell
git clone git@github.com:progrium/crew.git ~/.crew

# add the following to either your
# .bashrc, .bash_profile, or .profile file
alias crew='$HOME/.crew/contrib/crew_client.sh'
```

Configure the `CREW_HOST` environment variable or run `crew` from a repository with a git remote named crew pointed at your crew host in order to use the script as normal.

## (nodejs) crew-toolbelt

Crew-toolbelt is a node-based cli wrapper that proxies requests to the crew command running on remote hosts. You can install it via the following shell command (assuming you have nodejs and npm installed):

```shell
npm install -g crew-toolbelt
```

See [documentation here](https://www.npmjs.com/package/crew-toolbelt) for more information.

## (python) crew-client

crew-client is an extensible python-based cli wrapper for remote crew hosts.  You can install it via the following shell command (assuming you have python and pip installed):

```shell
pip install crew-client
```

See [documentation here](https://github.com/adamcharnock/crew-client) for more information.

## (ruby) Crew CLI

Crew CLI is a rubygem that acts as a client for your crew installation. You can install it via the following shell command (assuming you have ruby and rubygems installed):

```shell
gem install crew-cli
```

See [documentation here](https://github.com/SebastianSzturo/crew-cli) for more information.

## (ruby) CrewClient

CrewClient is another rubygem that acts as a client for your crew installation with built-in support for certain external plugins. You can install it via the following shell command (assuming you have ruby and rubygems installed):

```shell
gem install crew_client
```

See [documentation here](https://github.com/netguru/crew_client) for more information.

## (ruby) Crewfy

Crewfy is a rubygem that handles automation of certain tasks, such as crew setup, plugin installation, etc. You can install it via the following shell command (assuming you have ruby and rubygems installed):

```shell
gem install crewfy
```

See [documentation here](https://github.com/cbetta/crewfy) for more information.

## (ruby) Dockland

Dockland is a rubygem that acts as a client for your crew installation. You can install it via the following shell command (assuming you have ruby and rubygems installed):

```shell
gem install dockland
```

See [documentation here](https://github.com/uetchy/dockland) for more information.
