[![Gem Version](https://badge.fury.io/rb/utorrent-webapi-ruby.svg)](https://badge.fury.io/rb/utorrent-webapi-ruby)

# utorrent-webapi-ruby (BETA)

 This gem is used to utilise the µTorrent 2.0 (or above) webapi

 It uses the new [authentication mechanism](https://forum.utorrent.com/topic/49550-attention-webui-developers-support-token-authentication/), also you can find the [api reference](http://help.utorrent.com/customer/portal/topics/664593/articles).

## Installation

Add this line to your application's Gemfile:

    gem 'utorrent-webapi-ruby', git: 'git@github.com:PeterWuMC/utorrent-webapi-ruby.git'

    require 'u_torrent'

## Configuration

```ruby
configuration = UTorrent::Configuration.new
configuration.url = '192.168.2.100'
configuration.port = '8085'
configuration.username = 'admin'
configuration.password = 'password'
configuration.logger = Logger.new(path)
UTorrent.configuration = configuration
```

## Limitation

The current version only support the following actions

* Only support HTTP
* Querying torrents [attributes](https://github.com/PeterWuMC/utorrent-webapi-ruby/blob/master/lib/u_torrent/torrent.rb#L20-L26)
* Perform the following actions to torrent: `start, stop, force_start, pause, unpause, recheck, remove, remove_data`
* Querying files within a specific torrent [attributes](https://github.com/PeterWuMC/utorrent-webapi-ruby/blob/master/lib/u_torrent/file.rb#L10-L13)
* Add new torrent using with url or magnet
* Updating a file [priority](https://github.com/PeterWuMC/utorrent-webapi-ruby/blob/master/lib/u_torrent/file.rb#L3-L8)
* As of the current version, it does not have any error handling. Also the token is only valid for 30 minutes and it does not get automatically renewed.

## Usage

### Torrent

#### Query all torrents

    UTorrent::Torrent.all

#### Find one torrent using HASH

    UTorrent::Torrent.find(HASH)

#### Torrent attributes

| method            | explain                                                 |
| ----              | ---                                                     |
| id                | torrent HASH                                            |
| name              | torrent name                                            |
| size              | torrent total size                                      |
| downloaded        | total downloaded of the torrent in BYTES                |
| uploaded          | total uploaded of the torrent in BYTES                  |
| ratio             | torrent ratio                                           |
| upload_speed      | current upload seed of the torrent (BYTES per SECOND)   |
| download_speed    | current download seed of the torrent (BYTES per SECOND) |
| eta               | ETA of the torrent in SECONDS                           |
| statuses          | list out all the statuses it was in                     |
| status            | the current status of the torrent                       |
| percentage        | the current completed percentage of the torrent         |
| label             | the current label of the torrent                        |
| peers_connected   |                                                         |
| peers_in_swarm    |                                                         |
| seeds_connected   |                                                         |
| seeds_in_swarm    |                                                         |
| availability      |                                                         |
| queue_order       | current queue order of the torrent                      |
| remaining         | reminding BYTES                                         |
| url               | the original torrent url if it was added from url       |
| current_directory | current location of the downloaded files                |

#### Torrent actions

| method       | explain                                                     |
| ----         | ---                                                         |
| label=       | set label for the torrent                                   |
| start!       | start the torrent                                           |
| stop!        | stop the torrent                                            |
| force_start! | force start the torrent, event it reaches maximum downloads |
| pause!       | pause the torrent                                           |
| unpause!     | unpause the torrent                                         |
| recheck!     | recheck the torrent                                         |
| remove!      | remove the torrent                                          |
| remove_data! | remove the torrent and delete the data                      |
| finished?    | true if the torrent current status is `Finished`            |
| downloading? | true if the torrent current status is `Downloading`         |
| seeding?     | true if the torrent current status is `Seeding`             |
| refresh!     | reload the torrent information                              |
| files        | list all files of the torrent                               |

### File

#### Query all files of a torrent

    UTorrent::Torrent#files

#### File attributes

| method                 | explain                                                                                      |
| ----                   | ---                                                                                          |
| name                   | file name                                                                                    |
| size                   | file size                                                                                    |
| downloaded             | total downloaded of the file in BYTES                                                        |
| priority               | current priority of the file                                                                 |
| priority_display_value | `{0 => "Don't Download", 1 => 'Low Priority', 2 => 'Normal Priority', 3 => 'High Priority'}` |

#### File actions

| method    | explain                        |
| ----      | ---                            |
| priority= | set priority of the file       |
| skip!     | set the file priority to 0     |
| skipped?  | true if the file priority is 0 |
| refresh!  | reload the file information    |
