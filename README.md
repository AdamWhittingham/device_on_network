DeviceOnNetwork
===============

A rough and ready API server on top of NMAP for searching for MAC addresses on your network.
This is a learning project; trying different solutions to some tricky problems. Obviously, don't use this in production!

Installation
------------
DeviceOnNetwork requires [nmap](http://nmap.org/) to be installed.
It also needs to be run in a process with root privileges to detect MAC addresses.

You probably don't want to have to run your whole app as sudo, so this project provides a JSON API server to let you isolate the high privileges.

Usage
-----
### Start her up!
`sudo bin/device_on_network`

### Routes

`GET /` => Return a timestamp and message so you know the server is up

#### Active
  `GET /active` => Return an object describing the active (up) MAC addresses
##### Response JSON keys
- `macs` => An array of strings representing all of the active macs
- `timestamp` => The UTC timestamp of the last scan

#### Find
`GET /find?mac=00:00:00:00:00:00` => Returns a JSON object describing the results of scanning for the given MAC
##### Response JSON keys
- `found` => 'true' or 'false' depending on if that mac was found
- `mac` => the mac you requested a lookup of
- `timestamp` => The UTC timestamp of the last scan


Rambling notes on what I learned building this
----------------------------------------------
This project began as an experiment in both testing a tool heavily dependant on a system call, and of how Docker containers could be used to quarantine high-privilege requirements (NMAP needs to run as root to figure out MAC addresses).
Here are a few notes of what I've learned, please get in touch if you have some thoughts to add.

- Docker does a lot to isolate your container from 'real' networks. This is usually wonderful, but even in its most permissive modes, it does prevent access at Layer 2 for things. As I understand it, this prevents the app from running inside a container and being able to resolve MACs. If I'm wrong or there is a work around I just didn't find, please let me know!
- TDDing (or testing this at all) became expectionally difficult for a few reasons:
  1. I used the excellent `Program::Nmap` gem to isolate, parse and adapt NAMP searches into nice objects. As this gem returns its own data types, this left me with no clear option between stubbing the library (risking stubbing the wrong interfaces), closely integrating with the library and stubbing the system calls to namp (which I chose) and abandoning testing (which would be lazy and teach me nothing). Lesson: using a gem which returns its own data types means you need to absorb it's juicy knowledge to be able to test your app well, so it may not always be the awesome win you expected.
  2. Having to split the app in two in order to split the privileges added some interesting problems. Should the scanner just be a shell script calling namp and run as root? Could I automatically integration test the app without causing havoc to gem installations? (current answer is 'no')
  3. Testing a small script which spins up a thread without mocking/instrumenting `Thread` was very tough and not very useful. Ultimately, I ditched the tests as they were fragile mirrors of the production code. An integration test on a simulated network is too heavy handed for this, but may be sensible if this were a real production job. Refactoring the scanner into a ScannerLooper class is probably a good idea too.
