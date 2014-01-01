# Nominatim

[![Build Status](https://drone.io/github.com/enyo/nominatim/status.png)](https://drone.io/github.com/enyo/nominatim/latest)

> Nominatim (from the Latin, 'by name') is a tool to search OSM data by name
> and address and to generate synthetic addresses of OSM points (reverse geocoding).


**This library is not fully implemented yet.** You can use it, but the `SearchResults` object and `Place`s returned
probably don't contain all information provided by OpenStreetMap.

More information on the [OpenStreetMap wiki](http://wiki.openstreetmap.org/wiki/Nominatim).


This library is basically a very simple layer in between, that takes your query and
returns a `SearchResults` object so you don't have to take care of making the http
request and parsing the results.


It can be used with the [MapQuest Nominatim Search API Web Service](http://developer.mapquest.com/web/products/open/nominatim) as well.


## Usage


```dart
import "package:nominatim/nominatim.dart";

var nominatim = new Nominatim();
nominatim.search("Paris, France").then((SearchResults results) {
  for (Place place in results.places) {
    print(place.displayName);
    print(place.longitude);
    print(place.latitude);
  });
});
```

If you want to use another *Nominatim* provider, you can do so like this:

```dart
import "package:nominatim/nominatim.dart";

var nominatim = new Nominatim("open.mapquestapi.com",
                              "nominatim/v1/search.php",
                              "nominatim/v1/reverse.php");

// Use nominatim as usual
```


## License

(The MIT License)

Copyright (c) 2014 Matias Meno <m@tias.me>
