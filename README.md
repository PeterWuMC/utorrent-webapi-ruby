# utorrent-webapi-ruby (BETA)

 This gem is used to utilise the µTorrent 2.0 (or above) webapi

 It uses the new [authentication mechanism](https://forum.utorrent.com/topic/49550-attention-webui-developers-support-token-authentication/), also you can find the [api reference](http://help.utorrent.com/customer/portal/topics/664593/articles).

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

* Only support HTTP
* Querying torrents [attributes](https://github.com/PeterWuMC/utorrent-webapi-ruby/blob/master/lib/u_torrent/torrent.rb#L20-L26)
* Perform the following actions to torrent: `start, stop, force_start, pause, unpause, recheck, remove, remove_data`
* Querying files within a specific torrent [attributes](https://github.com/PeterWuMC/utorrent-webapi-ruby/blob/master/lib/u_torrent/file.rb#L10-L13)
* Add new torrent using with url
* Updating a file [priority](https://github.com/PeterWuMC/utorrent-webapi-ruby/blob/master/lib/u_torrent/file.rb#L3-L8)
* As of the current version, it does not have any error handling. Also the token is only valid for 30 minutes and it does not get automatically renewed.

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
