# Crew [![IRC Network](https://img.shields.io/badge/irc-freenode-blue.svg "IRC Freenode")](https://webchat.freenode.net/?channels=crew)[![Circle CI](https://circleci.com/gh/paralin/crew.svg?style=svg)](https://circleci.com/gh/paralin/crew)

A fork of Docker powered mini-Heroku Dokku oriented towards embedded linux containerized software.

## Requirements

- A linux machine.

## Installing

There is no non-source way of installing yet.

## Documentation

No documentation for this fork yet.

## Differences from Crew

This fork removes any need for external dependencies other than Docker. This means there is no nginx support, and buildstep is not supported (Dockerfile only deployment). Since this is oriented more towards just managing software and not necessarily web services, crew does not need to have a HTTP server running.

## License

MIT
