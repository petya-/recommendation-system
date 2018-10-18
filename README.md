# LHR Movie Recommendation System

Database design and implementation assignment. Copenhagen School of Design and Technology. October 2018

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

Make sure you have PostgreSQL installed and the right path to the pgsql files


### Creating the database and the schema
>run the following command from your terminal 
```
psql -U postgres postgres -f /Users/path/to/file/setupDB.pgsql
```

### Generating Mock Data
>run the following command from your terminal
```
psql -U postgres postgres -f /Users/path/to/file/mockData.pgsq
```

## Search and reccommendations

The following scripts will show you the implementation of a search and generating movie recommendations

### Get personalized recommendations
>run the following command in psql
```
psql -U postgres postgres -f /Users/path/to/file/recommendation.pgsql
```

## Authors

* **Petya Buchkova** - [petya-](https://github.com/petya-)
* **Toms Uluks** - [Toms-Uluks](https://github.com/Toms-Uluks)
