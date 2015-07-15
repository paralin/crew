# Remote commands

Crew commands can be run over ssh. Anywhere you would run `crew <command>`, just run `ssh -t crew@crew.me <command>`
The `-t` is used to request a pty. It is highly recommended to do so.
To avoid the need to type the `-t` option each time, simply create/modify a section in the `.ssh/config` on the client side, as follows:

```
Host crew.me
RequestTTY yes
```

## Run a command in the app environment

It's possible to run commands in the environment of the deployed application:

```shell
crew run node-js-app ls -alh
crew run <app> <cmd>
```

## Behavioral modifiers

Crew also supports certain command-line arguments that augment it's behavior. If using these over ssh, you must use the form `ssh -t crew@crew.me -- <command>`
in order to avoid ssh interpretting crew arguments for itself.

```shell
--quiet                suppress output headers
--trace                enable CREW_TRACE for current execution only
--rm|--rm-container    remove docker container after successful crew run <app> <command>
--force                force flag. currently used in apps:destroy
```
