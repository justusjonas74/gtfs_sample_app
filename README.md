# GTFS Sample App

A Ruby on Rails based sample application to show departures from [GTFS](https://developers.google.com/transit/gtfs/) data.  

## Install
```
git clone https://github.com/justusjonas74/gtfs_sample_app.git
bundle install
```

## Configuration

Copy `secrets.yml.example` and `database.yml.example` to native .yml files and add your credentials.

__Database adapters:__  Due to GTFS specifiation of timepoints > 23:59:59 the Postgres data type _interval_ is used for departure times. So currently only Postgres is supported. Feel free to send a pull request. 

## Import Data
```
rails gtfs:import["path/to/gtfs.zip"]
# or 
rails gtfs:import["example.com/path/to/gtfs.zip"]
```

## Usage
```
rails s
```

## Contributing
Feel free to contribute. 
