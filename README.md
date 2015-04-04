DeviceOnNetwork
===============

This small sharp gem with a catchy name does something unexpected:
it tells you if it can see a device on your network.

Installation
------------
DeviceOnNetwork requires [nmap]() to be installed.
It also needs to be run in a process with root privileges to detect MAC addresses.

After that is set, simply:
- Add `gem 'device-on-network` to your `Gemfile`
or
- Run `gem install device-on-network`

Server
------
You probably don't want to use the gem and have to run your whole app as sudo, so there is a server/JSON version to let you isolate the high privileges.
From the root of the project, run
`sudo rackup`

### Querying
`get /find?mac=00:00:00:00:00:00` will return a JSON object.
#### Response JSON keys
- `found` => 'true' or 'false' depending on if that mac was found
- `mac` => the mac you requested a lookup of
- `host` => If a device was found, this field will describe it

ToDo
----
- Add more methods for detecting devices
- Try to find a graceful way of falling back if not running as root
