# Nominatim

[![Build Status](https://drone.io/github.com/enyo/nominatim/status.png)](https://drone.io/github.com/enyo/nominatim/latest)

> Nominatim (from the Latin, 'by name') is a tool to search OSM data by name
> and address and to generate synthetic addresses of OSM points (reverse geocoding).

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


## License

(The MIT License)

Copyright (c) 2014 Matias Meno <m@tias.me>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.