# Plugins

Crew itself is built out of plugins and uses [pluginhook](https://github.com/progrium/pluginhook) for its plugin system. In essence a plugin is a collection of scripts that will be run based on naming convention.

Let's take a quick look at the current crew nginx plugin that's shipped with crew by default.

    nginx-vhosts/
    ├── commands     # contains additional commands
    ├── install      # runs on crew installation
    └── post-deploy  # runs after an app is deployed

## Installing a plugin

```shell
cd /var/lib/crew/plugins
git clone <git url>
crew plugins-install
```

> todo: add a command to crew to install a plugin, given a git repository `crew plugin:install <git url>`?

## Creating your own plugin

[See the full documentation](http://progrium.viewdocs.io/crew/development/plugin-creation).

## Community plugins

Note: The following plugins have been supplied by our community and may not have been tested by crew maintainers.

[agco-adm]: https://github.com/agco-adm
[ademuk]: https://github.com/ademuk
[alessio]: https://github.com/alessio
[alex-sherwin]: https://github.com/alex-sherwin
[alexanderbeletsky]: https://github.com/alexanderbeletsky
[Aomitayo]: https://github.com/Aomitayo
[apmorton]: https://github.com/apmorton
[blag]: https://github.com/blag
[cameron-martin]: https://github.com/cameron-martin
[cedricziel]: https://github.com/cedricziel
[cef]: https://github.com/cef
[cjblomqvist]: https://github.com/cjblomqvist
[darkpixel]: https://github.com/darkpixel
[dyson]: https://github.com/dyson
[F4-Group]: https://github.com/F4-Group
[fermuch]: https://github.com/fermuch
[fgrehm]: https://github.com/fgrehm
[gdi2290]: https://github.com/gdi2290
[heichblatt]: https://github.com/heichblatt
[hughfletcher]: https://github.com/hughfletcher
[iskandar]: https://github.com/iskandar
[jeffutter]: https://github.com/jeffutter
[jezdez]: https://github.com/jezdez
[jlachowski]: https://github.com/jlachowski
[krisrang]: https://github.com/krisrang
[Kloadut]: https://github.com/Kloadut
[luxifer]: https://github.com/luxifer
[mlebkowski]: https://github.com/mlebkowski
[matto1990]: https://github.com/matto1990
[michaelshobbs]: https://github.com/michaelshobbs
[mikecsh]: https://github.com/mikecsh
[mikexstudios]: https://github.com/mikexstudios
[motin]: https://github.com/motin
[musicglue]: https://github.com/musicglue
[neam]: https://github.com/neam
[nickstenning]: https://github.com/nickstenning
[nornagon]: https://github.com/nornagon
[ohardy]: https://github.com/ohardy
[pauldub]: https://github.com/pauldub
[pnegahdar]: https://github.com/pnegahdar
[RaceHub]: https://github.com/racehub
[rlaneve]: https://github.com/rlaneve
[robv]: https://github.com/robv
[scottatron]: https://github.com/scottatron
[sehrope]: https://github.com/sehrope
[statianzo]: https://github.com/statianzo
[stuartpb]: https://github.com/stuartpb
[thrashr888]: https://github.com/thrashr888
[wmluke]: https://github.com/wmluke
[Zenedith]: https://github.com/Zenedith
[sekjun9878]: https://github.com/sekjun9878
[Flink]: https://github.com/Flink
[ribot]: https://github.com/ribot
[Benjamin-Dobell]: https://github.com/Benjamin-Dobell
[jagandecapri]: https://github.com/jagandecapri
[mixxorz]: https://github.com/mixxorz
[Maciej Łebkowski]: https://github.com/mlebkowski
[abossard]: https://github.com/dudagroup

### Datastores

#### Relational

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [MariaDB](https://github.com/Kloadut/crew-md-plugin)                                             | [Kloadut][]           | Compatible with 0.2.0 |
| [MariaDB (single container)](https://github.com/ohardy/crew-mariadb)                             | [ohardy][]            | Compatible with 0.2.0 |
| [MySQL](https://github.com/hughfletcher/crew-mysql-plugin)                                       | [hughfletcher][]      |                       |
| [PostgreSQL](https://github.com/Kloadut/crew-pg-plugin)                                          | [Kloadut][]           | Compatible with 0.2.0 |
| [PostgreSQL](https://github.com/jezdez/crew-postgres-plugin)                                     | [jezdez][]            | Compatible with 0.2.0 |
| [PostgreSQL](https://github.com/jlachowski/crew-pg-plugin)                                       | [jlachowski][]        | IP & PORT available directly in linked app container env variables (requires link plugin)|
| [PostgreSQL (single container)](https://github.com/jeffutter/crew-postgresql-plugin)             | [jeffutter][]         | This plugin creates a single postgresql container that all your apps can use. Thus only one instance of postgresql running (good for servers without a ton of memory). |
| [PostgreSQL (single container)](https://github.com/ohardy/crew-psql)                             | [ohardy][]            | Compatible with 0.2.0 |
| [PostgreSQL (single container)](https://github.com/Flink/crew-psql-single-container)             | [Flink][]             | Single Postgresql container with official Postgresql docker image. Compatible with 0.3.16 |
| [PostGIS](https://github.com/fermuch/crew-pg-plugin)                                             | [fermuch][]           |                       |

#### Caching

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [Memcached](https://github.com/jezdez/crew-memcached-plugin)                                     | [jezdez][]            | Compatible with 0.2.0 |
| [Memcached](https://github.com/jlachowski/crew-memcached-plugin)                                 | [jlachowski][]        | IP & PORT available directly in linked app container env variables (requires link plugin)|
| [Redis](https://github.com/jezdez/crew-redis-plugin)                                             | [jezdez][]            | Requires https://github.com/rlaneve/crew-link; compatible with 0.2.0 |
| [Redis](https://github.com/luxifer/crew-redis-plugin)                                            | [luxifer][]           |                       |
| [Redis](https://github.com/sekjun9878/crew-redis-plugin)                                         | [sekjun9878][]        | A better Redis plugin with automatic instance creation and Crew Link support
| [Redis (single container)](https://github.com/ohardy/crew-redis)                                 | [ohardy][]            | Compatible with 0.2.0 |
| [Varnish](https://github.com/Zenedith/crew-varnish-plugin)                                       | [Zenedith][]          | Varnish cache between nginx and application with base configuration|

#### Queuing

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [RabbitMQ](https://github.com/jlachowski/crew-rabbitmq-plugin)                                   | [jlachowski][]        | IP & PORT available directly in linked app container env variables (requires link plugin)|
| [RabbitMQ (single container)](https://github.com/jlachowski/crew-rabbitmq-single-plugin)         | [jlachowski][]        | IP & PORT available directly in linked app container env variables (requires link plugin)|

#### Other

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [CouchDB](https://github.com/racehub/crew-couchdb-plugin)                                        | [RaceHub][]           | Compatible with 0.2.0 |
| [Elasticsearch](https://github.com/robv/crew-elasticsearch)                                      | [robv][]              | Not compatible with >= 0.3.0 (still uses /home/git) |
| [Elasticsearch](https://github.com/jezdez/crew-elasticsearch-plugin)                             | [jezdez][]            | Compatible with 0.2.0 to 0.3.13 |
| [Elasticsearch](https://github.com/blag/crew-elasticsearch-plugin)<sup>1</sup>                   | [blag][]              | Compatible with 0.2.0 |
| [MongoDB (single container)](https://github.com/jeffutter/crew-mongodb-plugin)                   | [jeffutter][]         |                       |
| [Neo4j](https://github.com/Aomitayo/crew-neo4j-plugin)                                           | [Aomitayo][]          |                       |
| [RethinkDB](https://github.com/stuartpb/crew-rethinkdb-plugin)                                   | [stuartpb][]          | 2014-02-22: targeting crew @ [latest][217d00a]; will fail with Crew earlier than [28de3ec][]. |
| [RiakCS (single container)](https://github.com/jeffutter/crew-riakcs-plugin)                     | [jeffutter][]         | Incompatible with 0.2.0 (checked at [dccee02][]) |

[dccee02]: https://github.com/jeffutter/crew-riakcs-plugin/commit/dccee02702e7001851917b7814e78a99148fb709

### Process Managers

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [Circus](https://github.com/apmorton/crew-circus)                                                | [apmorton][]          |                       |
| [Forego](https://github.com/iskandar/crew-forego)                                                | [iskandar][]          | Compatible with 0.2.x |
| [Logging Supervisord](https://github.com/sehrope/crew-logging-supervisord)                       | [sehrope][]           | Works with crew @ [c77cbf1][] - no 0.2.0 compatibility |
| [Monit](https://github.com/cjblomqvist/crew-monit)                                               | [cjblomqvist][]       |                       |
| [Shoreman ](https://github.com/statianzo/crew-shoreman)                                          | [statianzo][]         | Compatible with 0.2.0 |
| [Supervisord](https://github.com/statianzo/crew-supervisord)                                     | [statianzo][]         | Compatible with 0.2.0 |

[c77cbf1]: https://github.com/progrium/crew/commit/c77cbf1d3ae07f0eafb85082ed7edcae9e836147
[28de3ec]: https://github.com/progrium/crew/commit/28de3ecaa3231a223f83fd8d03f373308673bc40

### Crew Features

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [app-url](https://github.com/mikecsh/crew-app-url)                                               | [mikecsh][]           | Works with 0.2.0      |
| [Docker Direct](https://github.com/heichblatt/crew-docker-direct)                                | [heichblatt][]        |                       |
| [Crew Name](https://github.com/alex-sherwin/crew-name)                                          | [alex-sherwin][]      | crew >= [c77cbf1][]  |
| [Crew Registry](https://github.com/agco-adm/crew-registry)<sup>1</sup>                          | [agco-adm][]          |                       |
| [git rev-parse HEAD in env](https://github.com/cjblomqvist/crew-git-rev)                         | [cjblomqvist][]       | Compatible with 0.3.0 |
| [Graduate (Environment Management)](https://github.com/glassechidna/crew-graduate)               | [Benjamin-Dobell][]   | crew >= v0.3.14      |
| [HTTP Auth](https://github.com/Flink/crew-http-auth)                                             | [Flink][]             |                       |
| [HTTP Auth Secure Apps](https://github.com/matto1990/crew-secure-apps)                           | [matto1990][]         | Works with v0.2.3     |
| [Hostname](https://github.com/michaelshobbs/crew-hostname)                                       | [michaelshobbs][]     |                       |
| [Link Containers](https://github.com/rlaneve/crew-link)                                          | [rlaneve][]           | crew >= [c77cbf1][]  |
| [Maintenance mode](https://github.com/Flink/crew-maintenance)                                    | [Flink][]             |                       |
| [Multi-Buildpack](https://github.com/pauldub/crew-multi-buildpack)                               | [pauldub][]           |                       |
| [Ports](https://github.com/heichblatt/crew-ports)                                                | [heichblatt][]        |                       |
| [Pre-Deploy Tasks](https://github.com/michaelshobbs/crew-app-predeploy-tasks)                    | [michaelshobbs][]     |                       |
| [SSH Deployment Keys](https://github.com/cedricziel/crew-deployment-keys)<sup>2</sup>            | [cedricziel][]        | 2014-01-17: compatible with upstream/master |
| [SSH Hostkeys](https://github.com/cedricziel/crew-hostkeys-plugin)<sup>3</sup>                   | [cedricziel][]        | 2014-01-17: compatible with upstream/master |
| [Volume (persistent storage)](https://github.com/ohardy/crew-volume)                             | [ohardy][]            | Compatible with 0.2.0 |

[217d00a]: https://github.com/progrium/crew/commit/217d00a1bc47a7e24d8847617bb08a1633025fc7

<sup>1</sup> On Heroku similar functionality is offered by the [heroku-labs pipeline feature](https://devcenter.heroku.com/articles/labs-pipelines), which allows you to promote builds across multiple environments (staging -> production)

<sup>2</sup> Adds the possibility to add SSH deployment keys to receive private hosted packages

<sup>3</sup> Adds the ability to add custom hosts to the containers known_hosts file to be able to ssh them easily (useful with deployment keys)

### Other Plugins

| Plugin                                                                                            | Author                | Compatibility         |
| ------------------------------------------------------------------------------------------------- | --------------------- | --------------------- |
| [Airbrake deploy](https://github.com/Flink/crew-airbrake-deploy)                                 | [Flink][]             |                       |
| [APT](https://github.com/F4-Group/crew-apt)                                                      | [F4-Group][]          |                       |
| [Chef cookbooks](https://github.com/fgrehm/chef-crew)                                            | [fgrehm][]            |                       |
| [Bower install](https://github.com/alexanderbeletsky/crew-bower-install)                         | [alexanderbeletsky][] |                       |
| [Bower/Grunt](https://github.com/thrashr888/crew-bower-grunt-build-plugin)                       | [thrashr888][]        |                       |
| [Bower/Gulp](https://github.com/gdi2290/crew-bower-gulp-build-plugin)                            | [gdi2290][]           |                       |
| [Bower/Gulp](https://github.com/jagandecapri/crew-bower-gulp-build-plugin)                       | [jagandecapri][]      |                       |
| [Docker auto volumes](https://github.com/Flink/crew-docker-auto-volumes)                         | [Flink][]             | 0.3.17+, auto-persist docker volumes |
| [HipChat Notifications](https://github.com/cef/crew-hipchat)                                     | [cef][]               |                       |
| [Graphite/statsd](https://github.com/jlachowski/crew-graphite-plugin)                            | [jlachowski][]        |                       |
| [Logspout](https://github.com/michaelshobbs/crew-logspout)                                       | [michaelshobbs][]     |                       |
| [Node](https://github.com/pnegahdar/crew-node)                                                   | [pnegahdar][]         |                       |
| [Node](https://github.com/ademuk/crew-nodejs)                                                    | [ademuk][]            |                       |
| [Rails logs](https://github.com/Flink/crew-rails-logs)                                           | [Flink][]             |                       |
| [Reset mtime](https://github.com/mixxorz/crew-docker-reset-mtime)                                | [mixxorz][]           | 0.3.15+, Dockerfile support |
| [Slack Notifications](https://github.com/ribot/crew-slack)                                       | [ribot][]             |                       |
| [User ACL](https://github.com/mlebkowski/crew-acl)                                               | [Maciej Łebkowski][]  |                       |
| [Webhooks](https://github.com/nickstenning/crew-webhooks)                                        | [nickstenning][]      |                       |
| [Wordpress](https://github.com/dudagroup/crew-wordpress-template)                                | [abossard][]          | Crew dev, mariadb, volume, domains |

<sup>1</sup> Forked from [jezdez/crew-elasticsearch-plugin](https://github.com/jezdez/crew-elasticsearch-plugin): uses Elasticsearch 1.2 (instead of 0.90), doesn't depend on crew-link, runs as elasticsearch user instead of root, and turns off multicast autodiscovery for use in a VPS environment.

### Deprecated Plugins

The following plugins have been removed as their functionality is now in Crew Core.

| Plugin                                                                                            | Author                | In Crew Since                  |
| ------------------------------------------------------------------------------------------------- | --------------------- | ------------------------------- |
| [Custom Domains](https://github.com/neam/crew-custom-domains)                                    | [motin][]             | v0.3.10 (domains plugin)        |
| [Debug](https://github.com/heichblatt/crew-debug)                                                | [heichblatt][]        | v0.3.9 (trace command)          |
| [Docker Options](https://github.com/dyson/crew-docker-options)                                   | [dyson][]             | v0.3.17 (docker-options plugin) |
| [Events Logger](https://github.com/alessio/crew-events)                                          | [alessio][]           | v0.3.21 (events plugin)         |
| [Host Port binding](https://github.com/stuartpb/crew-bind-port)                                  | [stuartpb][]          | v0.3.17 (docker-options plugin) |
| [Multiple Domains](https://github.com/wmluke/crew-domains-plugin)<sup>1</sup>                    | [wmluke][]            | v0.3.10 (domains plugin)        |
| [Nginx-Alt](https://github.com/mikexstudios/crew-nginx-alt)                                      | [mikexstudios][]      | v0.3.10 (domains plugin)        |
| [Persistent Storage](https://github.com/dyson/crew-persistent-storage)                           | [dyson][]             | v0.3.17 (docker-options plugin) |
| [PrimeCache](https://github.com/darkpixel/crew-prime-cache)                                      | [darkpixel][]         | v0.3.0 (zero downtime deploys)  |
| [Rebuild application](https://github.com/scottatron/crew-rebuild)                                | [scottatron][]        | v0.3.14 (ps plugin)             |
| [Supply env vars to buildpacks](https://github.com/cameron-martin/crew-build-env)<sup>2</sup>    | [cameron-martin][]    | v0.3.9 (build-env plugin)       |
| [user-env-compile](https://github.com/musicglue/crew-user-env-compile)<sup>2</sup>               | [musicglue][]         | v0.3.9 (build-env plugin)       |
| [user-env-compile](https://github.com/motin/crew-user-env-compile)<sup>2</sup>                   | [motin][]             | v0.3.9 (build-env plugin)       |
| [VHOSTS Custom Configuration](https://github.com/neam/crew-nginx-vhosts-custom-configuration)    | [motin][]             | v0.3.10 (domains plugin)        |


<sup>1</sup> Conflicts with [VHOSTS Custom Configuration](https://github.com/neam/crew-nginx-vhosts-custom-configuration)
<sup>2</sup> Similar to the heroku-labs feature (see https://devcenter.heroku.com/articles/labs-user-env-compile)

[a043e98]: https://github.com/stuartpb/crew-bind-port/commit/a043e9892f4815b6525c850131e09fd64db5c1fa
