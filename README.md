# Hiera

[![Build Status](https://travis-ci.org/puppetlabs/hiera.png?branch=master)](https://travis-ci.org/puppetlabs/hiera)

A simple pluggable Hierarchical Database.

-
**Tutorials:** Check the docs directory for tutorials.

## Why?

Hierarchical data is a good fit for the representation of infrastructure information.
Consider the example of a typical company with 2 datacenters and on-site development,
staging etc.

All machines need:

 - ntp servers
 - sysadmin contacts

By thinking about the data in a hierarchical manner you can resolve these to the most
correct answer easily:

<pre>
     /------------- DC1 -------------\             /------------- DC2 -------------\
    | ntpserver: ntp1.dc1.example.com |           | ntpserver: ntp1.dc2.example.com |
    | sysadmin: dc1noc@example.com    |           |                                 |
    | classes: users::dc1             |           | classes: users::dc2             |
     \-------------------------------/             \-------------------------------/
                                \                      /
                                  \                  /
                           /------------- COMMON -------------\
                          | ntpserver: 1.pool.ntp.org          |
                          | sysadmin: "sysadmin@%{domain}"     |
                          | classes: users::common             |
                           \----------------------------------/
</pre>

In this simple example machines in DC1 and DC2 have their own NTP servers, additionaly
DC1 has its own sysadmin contact - perhaps because its a remote DR site - while DC2
and all the other environments would revert to the common contact that would have the
machines domain fact expanded into the result.

The _classes_ variable can be searched using the array method which would build up a
list of classes to include on a node based on the hierarchy.  Machines in DC1 would have
the classes _users::common_ and _users::dc1_.

The other environment like development and staging would all use the public NTP infrastructure.

This is the data model that extlookup() have promoted in Puppet, Hiera has taken this
data model and extracted it into a standalone project that is pluggable and have a few
refinements over extlookup.

### Variable expansion

When the data contains a pattern like %{foo}, then this will be expanded using the supplied data.

This expansion is done on the values as well as the configuration items.

### Array Searches

Hiera can search through all the tiers in a hierarchy and merge the result into a single
array.

## Installation

Hiera is available as a Gem called _hiera_ and out of the box it comes with
just a YAML and a JSON backend.

Hiera is also available as a native package via apt (http://apt.puppetlabs.com)
and yum (http://yum.puppetlabs.com). Instructions for adding these repositories
can be found at
http://docs.puppetlabs.com/guides/installation.html#debian-and-ubuntu and
http://docs.puppetlabs.com/guides/installation.html#enterprise-linux
respectively.

## Configuration

You can configure Hiera using a YAML file or by providing it using a hash in your code.  There
isn't a default config path - the CLI script will probably assume _/etc/hiera.yaml_ though.
The default data directory for file based storage is _/var/lib/hiera_.

A sample configuration file can be seen here:

<pre>
---
logger: { type: console }

hierarchy:
  - name: "%{location}"
    type: yaml
    config:
      dir: /etc/puppet/hieradata
</pre>

This configuration will require YAML files in  _/etc/puppet/hieradata_ these need to contain
Hash data, sample files matching the hierarchy described in the _Why?_ section are below:

_/etc/puppet/hieradata/dc1.yaml_:
<pre>
---
ntpserver: ntp1.dc1.example.com
sysadmin: dc1noc@example.com
</pre>

_/etc/puppet/hieradata/dc2.yaml_:
<pre>
---
ntpserver: ntp1.dc2.example.com
</pre>

_/etc/puppet/hieradata/common.yaml_:
<pre>
---
sysadmin: "sysadmin@%{domain}"
ntpserver: 1.pool.ntp.org
</pre>

## Querying from CLI

You can query your data from the CLI.  By default the CLI expects a config file in _/etc/hiera.yaml_
but you can pass _--config_ to override that.

This example searches Hiera for node data.  Scope is loaded from a Puppet created YAML facts
store as found on your Puppet Masters.

If no data is found and the facts had a location=dc1 fact the default would be _sites/dc1_

<pre>
$ hiera acme_version 'sites/%{location}' --yaml /var/lib/puppet/yaml/facts/example.com.yaml
</pre>

You can also supply extra facts on the CLI, assuming Puppet facts did not have a location fact:

<pre>
$ hiera acme_version 'sites/%{location}' location=dc1 --yaml /var/lib/puppet/yaml/facts/example.com.yaml
</pre>

You can also do array merge searches on the CLI:

<pre>
$ hiera -a classes location=dc1
["users::common", "users::dc1"]
</pre>

## License

See LICENSE file.

## Support

Please log tickets and issues at our [Projects site](http://projects.puppetlabs.com)

