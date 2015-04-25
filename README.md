DeviceOnNetwork
===============

This small sharp gem with a catchy name does something unexpected:
it tells you if it can see a device on your network.

Installation
------------
DeviceOnNetwork requires [nmap](http://nmap.org/) to be installed.
It also needs to be run in a process with root privileges to detect MAC addresses.

After that is set, simply:
- Add `gem 'device-on-network` to your `Gemfile`
or
- Run `gem install device-on-network`

Server / Container / MicroService
---------------------------------
You probably don't want to use the gem and have to run your whole app as sudo, so there is a JSON API server to let you isolate the high privileges. Optionally, and to make this even easier, a Dockerfile is provided so the root permissions are limited entirely inside the container.

### Sinatra API server
From the root of the project, run
`sudo rackup`

#### Routes
`GET /` => Return a timestamp and message so you know the server is up
`GET /find?mac=00:00:00:00:00:00` => Returns a JSON object describing the results of scanning for the given MAC

#### Find Response JSON keys
- `found` => 'true' or 'false' depending on if that mac was found
- `mac` => the mac you requested a lookup of
- `host` => If a device was found, this field will describe it

### Docker
A container and compose file are provided for running up the container.
Once you have docker installed, you should be able to run the container with:
`docker-compose build && docker-compose up`
After this, the container will be listening on port `8000`. You can change this port by editing the left-hand portion of the PORTS section in [docker-compose.yml](docker-compose.yml)


ToDo
----
- Add more methods for detecting devices
- Find a graceful way of falling back if not running as root
