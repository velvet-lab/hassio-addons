
## 1.0.0

- First Release

## 1.0.1

- Format log messages
- Fix exit code for shutdown

## 1.1.0

- Enable admin authentication

## 1.1.1

- Add translations

## 1.1.2

- Fix admin user creation for existing databases

## 1.1.3

- Make secure shutdown for initialize

## 1.1.4

- Error Handling for killing mongod process

## 1.1.5

- Error Handling for killing mongod process with gracefully shutdown

## 1.1.6

- Remove shutdown from init script

## 1.1.7

- Expose port in docker

## 1.2.0

- Change base image from debian to ubuntu

## 2.0.0

- Add replica set support
- Make dynamic configuration for mongod
- Configure apparmor settings
- Disable Host Network setttings
- Make auth configurable

## 2.0.1

- Fix replica set initialization
- Fix replica set re-initialization
- Fix replica set configuration for existing replica sets, databases and users
- Add support for keyfile authentication

## 2.0.2

- Fix port configuration

## 2.0.3

- Add support for Home Assistant API

## 2.0.4

- Add port and ip configuration for replica set members

## 2.0.5

- Fix replica set re-initialization when port and ip are configured

## 2.0.6

- Enable hassio_role and hassio_api

## 2.0.7

- Enable binding for all ips

## 2.0.8

- Enable logging validation
- Extend readme with replication instructions

## 2.0.9

- Add admin role for replicat set users

## 2.1.0

- Make replica set name configurable