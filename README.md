katapult
========

A tool for launching container-based products

[![oclif](https://img.shields.io/badge/cli-oclif-brightgreen.svg)](https://oclif.io)
[![Version](https://img.shields.io/npm/v/@balena/katapult.svg)](https://npmjs.org/package/@balena/katapult)
[![CircleCI](https://circleci.com/gh/loop-os/katapult/tree/master.svg?style=shield)](https://circleci.com/gh/loop-os/katapult/tree/master)
[![Downloads/week](https://img.shields.io/npm/dw/@balena/katapult.svg)](https://npmjs.org/package/@balena/katapult)
[![License](https://img.shields.io/npm/l/@balena/katapult.svg)](https://github.com/loop-os/katapult/blob/master/package.json)

<!-- toc -->
* [Usage](#usage)
* [Commands](#commands)
<!-- tocstop -->

# Design

We traditionally describe katapult from bottom to top (from the outputs it produces to the inputs it consumes). 
The main purpose of katapult is to help with frames generation and deployment. Frame is a complete description 
of a state that a specific environment should be in. It's very specific and can be used to reconstruct the environment
from scratch.

Frames are generated from 2 inputs:
- frame template (a frame without environment-specific values embedded)
- config manifest (a declaration of the values the template expects in order to be rendered into a frame)

Both of them are also created by katapult too.
Config manifest is obtained as a composition of config declarations in component contracts.
The form of the frame template is determined by the target environment and is generated by a target adapter.
Possible targets include docker-compose and k8s. 

The inputs for the generated frame templates are a product keyframe and a set of contracts referred from the keyframe.
Config manifest is generated from the same set of contracts.

[See more in the linked doc.](https://docs.google.com/document/d/14r3-1wc5kLx7_qOIEtaaerl4JGEQureRGHsXIHPdlhQ/edit)

Let's now review how this works with more details for k8s target and moving from the top to bottom. 

Imagine we have a product that consists of 3 components:
- a database
- an API service
- a web app

Each of these components is located in its own repository with the following contracts definitions:

- the database
```yaml
slug: product-db
type: sw.datastore.rds
```

- the API service
```yaml
slug: product-api
type: sw.containerized-scaled-service
requires:
  - slug: product-db
```

- the web app
```yaml
slug: product-ui
type: sw.containerized-scaled-service
config:
  - name: UI_THEME
    type: string
requires:
  - slug: product-api
```

These contracts are published to the contracts registry being tagged with corresponding versions.

The product is described as a composition of these 3 components in a product keyframe:
```yaml
slug: product
type: keyframe
children:
  - slug: product-db
    version: 1.2.3
    as: db
  - slug: product-api
    version: 3.2.1
    as: api
  - slug: product-ui
    version: 2.3.1
    as: ui
links:
  api:
    product-db: db
  ui:
    product-api: api
```

Using the keyframe and contracts data, katapult can generate a frame template.
In the case of using the k8s target adapter, the frame template will include deployment, service, job definitions
that refer to corresponding secrets. However, the secrets will not be included in the template.

Using the contracts data, katapult can generate the config manifest. In our case, it may have the following form:
```
- component: ui
  config:
    - name: UI_THEME
      type: string
```  

Having the config manifest, katapult will communicate with the config store (for example Vault or AWS parameters store)
in order to ensure that all the necessary configuration values are present there and defined.s
The config store is environment specific, which means it contains values for a specific environment.
Then katapult fetches the values and completes k8s fame generation adding secrets declaration to the frame template. 

Generation of k8s definitions  

TODO before we merge this work:
- [ ] *scalability* - is going to be solved with generating a config key for scalable services that needs to define the replicas count
- [ ] *config manifest* - generation needs to be coded
- [ ] *supplying contract and keyframe inputs* 

# Usage
<!-- usage -->
```sh-session
$ npm install -g @balena/katapult
$ katapult COMMAND
running command...
$ katapult (-v|--version|version)
@balena/katapult/2.1.1 linux-x64 node-v12.13.1
$ katapult --help [COMMAND]
USAGE
  $ katapult COMMAND
...
```
<!-- usagestop -->
# Commands
<!-- commands -->
* [`katapult deploy`](#katapult-deploy)
* [`katapult generate`](#katapult-generate)
* [`katapult help [COMMAND]`](#katapult-help-command)

## `katapult deploy`

Deploy a Frame from an Environment to a Target

```
USAGE
  $ katapult deploy

OPTIONS
  -e, --environmentPath=environmentPath   (required) [default: ./environment.yml] URI of the environment configuration
                                          path

  -k, --keyframe=keyframe                 URI of the keyframe path

  -t, --target=docker-compose|kubernetes  (required) Which target to use.
```

_See code: [src/commands/deploy.ts](https://github.com/loop-os/katapult/blob/v2.1.1/src/commands/deploy.ts)_

## `katapult generate`

Generate a Frame from an Environment

```
USAGE
  $ katapult generate

OPTIONS
  -e, --environmentPath=environmentPath   (required) [default: ./environment.yml] URI of the environment configuration
                                          path

  -k, --keyframe=keyframe                 URI of the keyframe path

  -o, --outputPath=outputPath             (required) Directory to output the frame to

  -t, --target=docker-compose|kubernetes  (required) Which target to use.
```

_See code: [src/commands/generate.ts](https://github.com/loop-os/katapult/blob/v2.1.1/src/commands/generate.ts)_

## `katapult help [COMMAND]`

display help for katapult

```
USAGE
  $ katapult help [COMMAND]

ARGUMENTS
  COMMAND  command to show help for

OPTIONS
  --all  see all commands in CLI
```

_See code: [@oclif/plugin-help](https://github.com/oclif/plugin-help/blob/v2.1.6/src/commands/help.ts)_
<!-- commandsstop -->
