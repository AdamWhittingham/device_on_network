DeviceOnNetwork
===============

A tiny app to provide a JSON API on top of NMAP for detecting MAC addresses on your network.

It can be useful to know what is connected to your network- maybe for intrution detection, or perhaps your home automation could be boosted by knowing when your phone reconnects to your wifi? This project runs [nmap](http://nmap.org) to detect all the active devices on your network.
This scan requires root priveledges and you probably don't want to have to run your whole app as root just for this one feature, so the project provides a JSON API server to let you isolate the high privileges. By default, this server only responds to queries from localhost.

Installation
------------
DeviceOnNetwork requires [nmap](http://nmap.org/) to be installed.
It also needs to be run in a process with root privileges to detect MAC addresses.

Just clone this repo, run `bundle install --without test development` to install the dependencies, and you should be good to go.

### Running as a service (Init.d)
There is also a `init.d` script provided for convenience inside the `scripts` folder. It only assumes that your root user has `ruby` on the path by default, so you may need to make some changes depending on your setup.

Usage
-----
### Start her up!
`sudo bin/device_on_network`

You can optionally set various settings like the scan period and target network. Run `bin/device_on_network -h` to see the options.

### Routes

#### '/'
  `GET /` => Return a JSON object listing the active (up) MAC addresses
##### Response JSON keys
- `active_mac_addresses` => An array of strings representing all of the active macs
- `scanned_at` => The UTC timestamp of the last scan being completed

HELP!
-----

### I can't see my devices!
The main culprit for this will be scannig the wrong IP address range. By default, IPs in the range `192.168.0.*` are scanned. If your network runs on a different range, (`192.168.1.*` is also a popular default for home networks), you can overide the default by providing the `-n` option. For example, `bin/device_on_network -n '192.168.1.*'` or `bin/device_on_network -n 10.0.0.*`.Note that while you _can_ scan every IP but this will take a long, long time!

### I can't see the API!
By default, the API server only accepts requests from the same machine as it is running on. This is both for security and because DeviceOnNetwork is supposed to be run as a component of a larger system. If you need to change this setting, you can provide the `-b` option to change the binding. For example, `bin/device_on_network -b 0.0.0.0` will make the server accessible to _anyone_, which is probably a bad idea.

### My /var/tmp directory defaults all files to world readable and I don't want anyone reading the nmap output
By default, nmap will be writing it's scan results to `/var/tmp`. Depending on the setup of your environment, `/var/tmp` _might_ write files with global read access. If you want to supply the option to store this file in a more secure location (depending on who you share your server with), you can do so with the `-f` option. For example, `bin/device_on_network -f /home/deployer/device_on_network/working`


Notes on design decisions and interesting things I learned building this
------------------------------------------------------------------------

This project began as an experiment in testing a tool heavily dependant on a system call and using Docker containers to quarantine high-privilege requirements (NMAP needs to run as root to figure out MAC addresses).
Here are a few notes of what I've learned, please get in touch if you have some thoughts to add.

- Docker does a lot to isolate your container from 'real' networks. This is usually a wonderful, but even its most permissive modes prevent access to Layer 2. This prevents the app from running inside a container and being able to resolve MACs. If I'm wrong or there is a work around I just didn't find, please let me know!
- TDDing (or testing this at all) became exceptionally difficult for a few reasons:
  1. I used the excellent [Program::Nmap gem](https://github.com/sophsec/ruby-nmap) to trigger and parse NMAP scans into objects. As this gem returns its own data types, this left me with no clear option between stubbing the library (risking stubbing the wrong interfaces), closely coupling to the library and stubbing the system calls to namp (which I chose) and abandoning testing (which would be lazy and teach me nothing, as well as rarely being the right choice). Lesson: using a gem which returns its own data types means you need to absorb it's juicy knowledge to be able to test your app well, so it may not always be the awesome win you expected.
  2. Having to split my original app in two in order to split the privileges added some interesting problems. Should the scanner just be a shell script calling namp and run as root? Could I automatically integration test the app without causing havoc to gem installations? (current answer is 'no')
  3. Testing a small script which spins up a thread without mocking/instrumenting `Thread` was very tough and not very useful. Ultimately, I ditched the tests as they were fragile mirrors of the production code. An integration test on a simulated network is too heavy handed for this, but may be sensible if this were a real production job.
- Sinatra _can_ run dynamically generated classes but the resulting code is so unobvious that I ended up using global and class level variables as the less of two evils. There is plenty of scope for refactoring the server component into something which can be initialized with config variables.
