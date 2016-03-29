# utorrent-webapi-ruby


## Installation

Add this line to your application's Gemfile:

    gem 'utorrent-webapi-ruby', git: 'git@github.com:PeterWuMC/utorrent-webapi-ruby.git'

## Configuration

```ruby
configuration = UTorrent::Configuration.new
configuration.url = '192.168.2.100'
configuration.port = '8085'
configuration.username = 'admin'
configuration.password = 'password'
UTorrent.configuration = configuration
```

## Limitation

The current version only support the following actions

* Querying torrents
* Perform the following actions to torrent: `start, stop, force_start, pause, unpause, recheck, remove, remove_data`
* Querying files within a specific torrent
* Add new torrent using with url
* Updating a file priority

## Usage

### Query all torrents

    UTorrent::Torrent.all

### Find one torrent using HASH

    UTorrent::Torrent.find(HASH)

### Perform actions on torrent

e.g.

    UTorrent::Torrent.all.first.stop

### Query all file of a torrent

    UTorrent::Torrent.all.first.files

### Update priority of a file

    UTorrent::Torrent.all.first.files.priority = 0 # Do not download
