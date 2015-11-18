# Overview

This web application shows conflict events and related events(building a base, transfer of territory) from Africa 97-2015. Most important features are
- search by, date, type, fatalities, country and actors
- search for related conflicts. Under related conflicts we understand nearby conflicts within 28 days before or after
- search by keywords, done by postgres full text search on notes and actors
- distance(in kilometers) and general direction to capital
Some screenshots:

![Screenshot](screenshot.png)

Applications follows basic Ruby on Rails architecture. 

# Views

Views are simple as it gets. They consists of two partials, one for map itself and one for search panel. There are two other views, but they work only as containers.
 
Map partial has all of mapbox.js code. It loads geojsons from rails variable and creates map. If it is showing related conflicts(meaning variable center exists), it draws ellipse, which should contain all related conflicts. In this part of program tooltip pop up windows are formatted to show all of the important information.

Searchbox partial contains form to take user search input, it consists of several components.

Application is using my custom map style, which is based on satellite map with highlighted borders and street map with highlighted major motorways. Also whole map is in english language.

# Models and controllers

All querying is done in map controller, while building geojson, which is accepted by mapbox is done in conflict model.

## Data

Conflict data comes from ACLED datasets for Africa97-2015. This data can be downloaded in .csv, .xls or in shapefiles, which i turned into geojsons using mapshaper.org. ACLED data is very well formatted with many columns, some were not used in this application. These datasets also supports historic data by differentiating between regimes through time(e.g.  Congo/Zaire (1965-1997),  Democratic  Republic  of Congo (1997-2001). Sadly ACLED supports only Africa97-2015 and Asia2015.

There are more conflict datasets with geoinformation, however some of them are paid only and others are incopatible with ACLED, meaning i would have to merge their schema in a meaningful way.

## Api

**Find conflicts based on number of fatalities**

`GET /search?utf8=%E2%9C%93&event[date_start]=&event[date_stop]=&event[country_id]=1&event[type_id]=0&event[actor1]=0&event[actor2]=0&event[fatals]=%3E500&event[kwds]=&commit=Search`

**Find conflicts based on keywords**

`GET /search?utf8=%E2%9C%93&event[date_start]=&event[date_stop]=&event[country_id]=1&event[type_id]=0&event[actor1]=0&event[actor2]=0&event[fatals]=&event[kwds]=militia+%26+soldier+%26+ambush&commit=Search`

### Response

API calls return geojson response containing events that meet user criteria, sorted by fatalities and limited to first 200. This limiting is both done to speed database and to ease load on mapbox.js, which was not keeping up with more than 300-500 results.

Each event result is stored in this format:

{
    "type": "Feature",
    "geometry": {"type":"Point", "coordinates":[19.9166, -11.7833]},
    "properties": {
      "title": "Battle-No change of territory",
      "description": "Event notes, long wont write in documentation",
      "event_date": "2001-12-24",
      "country": "Angola",
      "fatalities": "30",
      "locfromcap": "30 km southeast to capital",
      "id": "4",
      "actor1": "UNITA: National Union for the Total Independence of Angola",
      "actor2": "Civilians",
      "marker-color": "#fc4353",
      "marker-size": "medium",
      "marker-symbol": "danger"
    }
  }

