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

ToDo
----
- Add more metrics for detecting devices
- Try to find a graceful way of falling back if not running as root
- Add a simple web/unix socket server so it can be run as root isolated from the rest of your application
