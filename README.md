DeviceOnNetwork
===============

A rough and ready API server on top of NMAP for searching for MAC addresses on your network.
This is a learning project; trying different solutions to some tricky problems. Obviously, don't use this in production!

Installation
------------
DeviceOnNetwork requires [nmap](http://nmap.org/) to be installed.
It also needs to be run in a process with root privileges to detect MAC addresses.

You probably don't want to have to run your whole app as sudo, so this project provides a JSON API server to let you isolate the high privileges.

There is also a `init.d` script provided for convenience inside the `scripts` folder. It only assumes that your root user has `ruby` on the path by default, so you may need to make some changes depending on your setup.

Usage
-----
### Start her up!
`sudo bin/device_on_network`

You can optionally set various settings. Run `bin/device_on_network -h` to see the options.

**Note:** By default, nmap will be writing it's scan results to `/var/tmp`. This will be readable by anyone on your server, so you may want to supply the option to store this file in a more secure location (depending on who you share your server with).

### Routes

#### '/'
  `GET /` => Return a JSON object listing the active (up) MAC addresses
##### Response JSON keys
- `active_mac_addresses` => An array of strings representing all of the active macs
- `scanned_at` => The UTC timestamp of the last scan being completed


Rambling notes on what I learned building this
----------------------------------------------
This project began as an experiment in both testing a tool heavily dependant on a system call, and of how Docker containers could be used to quarantine high-privilege requirements (NMAP needs to run as root to figure out MAC addresses).
Here are a few notes of what I've learned, please get in touch if you have some thoughts to add.

- Docker does a lot to isolate your container from 'real' networks. This is usually wonderful, but even in its most permissive modes, it does prevent access at Layer 2 for things. As I understand it, this prevents the app from running inside a container and being able to resolve MACs. If I'm wrong or there is a work around I just didn't find, please let me know!
- TDDing (or testing this at all) became expectionally difficult for a few reasons:
  1. I used the excellent `Program::Nmap` gem to isolate, parse and adapt NAMP searches into nice objects. As this gem returns its own data types, this left me with no clear option between stubbing the library (risking stubbing the wrong interfaces), closely integrating with the library and stubbing the system calls to namp (which I chose) and abandoning testing (which would be lazy and teach me nothing). Lesson: using a gem which returns its own data types means you need to absorb it's juicy knowledge to be able to test your app well, so it may not always be the awesome win you expected.
  2. Having to split the app in two in order to split the privileges added some interesting problems. Should the scanner just be a shell script calling namp and run as root? Could I automatically integration test the app without causing havoc to gem installations? (current answer is 'no')
  3. Testing a small script which spins up a thread without mocking/instrumenting `Thread` was very tough and not very useful. Ultimately, I ditched the tests as they were fragile mirrors of the production code. An integration test on a simulated network is too heavy handed for this, but may be sensible if this were a real production job. Refactoring the scanner into a ScannerLooper class is probably a good idea too.
- Sinatra _can_ run dynamically generated classes but the resulting code is so unobvious that I ended up using global and class level variables as the less of two evils. There is plenty of scope for refactoring the server component into something which can be initialized with config variables.
