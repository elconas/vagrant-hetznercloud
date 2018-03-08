
# Vagrant Hetznercloud Provider

This is a [Vagrant](http://www.vagrantup.com/) plugin that adds a
[Hetznercloud](https://cloud.hetzner.com/) provider to Vagrant, allowing Vagrant to
control and provision machines in Hetznercloud.

**NOTE: This is currently a MVP Prototyp (and my first vagrant plugin). Probably the interface will change. Development is tracked at [Trello](https://trello.com/b/zJx9W0OY/vagrant-hetznercloud)**


## Features

- Boot Hetznercloud servers (supports types, user_data and ssh_keys)
- SSH into the servers.
- Provision the servers with any built-in Vagrant provisioner.
- Minimal synced folder support via rsync.

Missing Features:

- cli "command" support for listing server types, prieces, datacenters, locations ... everything
- proper cli "command" support with multi machine vagrantfiles
- probably a lot :)

## Prerequisites

Prior to using this plugin, you will first need to create an API token and
identify your organization ID. Please see the following help pages for
instructions.

- [Hetznercloud Getting Started Guide](https://docs.hetzner.cloud/#header-getting-started-1)

## Installation

Install using standard Vagrant plugin installation methods.

    $ vagrant plugin install vagrant-hetznercloud

**Note**: As this plugin is not yet released you have to:

- checkout the code
- run $rake build
- vagrant install pkd/plugin.gem
- vagrant box add --name base hetznercloud.box

## Usage

1) Generate Token in the Web GUI of Hetznercloud

Create new API token in the Hetznercloud [Console](https://console.hetzner.cloud/).

2) Optional: Install the hcloud cli

If you install the [Hetzner cli](https://github.com/hetznercloud/cli) and configure it with credentials,
the vagrant-hetznercloud driver automatically picks up your default context
from the ~/.config/hcloud/cli.toml settings file. Therefor you do not need to
set the credentials in the environment or in the Vagrantfile.

1) Create Vagrantfile

See [examples/Vagrantfile](examples/Vagrantfile) for an example Vagrantfile:

2) Start your machines

And then run `vagrant up` and specify the `hetznercloud` provider:

2.1) With hcloud cli installed and configured

    $ vagrant up --provider=hetznercloud

2.1) With Token via environment

    $ export HETZNERCLOUD_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
    $ vagrant up --provider=hetznercloud

2.2) With Token in Vagrantfile

See [examples/Vagrantfile](examples/Vagrantfile).

**Note: This is not recommended, as this tends to leak credentials in SCM**

## Configurations

FIXME: Write proper documentation

## Development

To work on the `vagrant-hetznercloud` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

    $ bundle

If those pass, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by just
creating a `Vagrantfile` in the top level of this directory (it is gitignored)
that uses it, and uses bundler to execute Vagrant:

    $ bundle exec vagrant up --provider=scaleway

For Debugging you can run:

	$ LANG=C VAGRANT_LOG=debug VAGRANT_DEFAULT_PROVIDER=hetznercloud VAGRANT_HOME=~/.vagrant.develop.d bundle exec -- vagrant up

Development is tracked at [Trello](https://trello.com/b/zJx9W0OY/vagrant-hetznercloud)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elconas/vagrant-hetznercloud.

## License

The plugin is available as open source under the terms of the [APACHE-2.0](https://opensource.org/licenses/APACHE-2.0).
