

import "dart:async";
import "dart:io";
import "dart:convert";
import "package:xml/xml.dart";


class SearchResults {
  
  List<Place> places = new List<Place>();

  final String timestamp;
  
  final String attribution;
 
  final String moreUrl;

  final String queryString;
  
  final bool polygon;
  
  SearchResults({ this.timestamp, this.attribution, this.moreUrl, this.queryString, this.polygon });
  
  String toString() {
    var string = new List();
    string.add("SearchResult (${timestamp})");
    
    this.places.forEach((place) {
      string.add("  - ${place.displayName}");
    });
    return string.join("\n");
  }
  
}


class Place {
  
  int id;
  
  double latitude;
  double longitude;
  
  String displayName;
  
  double importance;
  
  String city;
  String county;
  String state;
  String country;
  String countryCode;

  Place(this.id, { this.latitude, this.longitude, this.displayName, this.importance, this.city, this.county, this.state, this.country, this.countryCode });
  
}


/**
 * Class to use the [Nomatim API](http://wiki.openstreetmap.org/wiki/Nominatim)
 * for openstreetmap.
 */
class Nominatim {
  
  final String baseUriSearch;
  
  final String baseUriReverse;
  
  Nominatim([ String this.baseUriSearch = 'http://nominatim.openstreetmap.org/search/', String this.baseUriReverse = 'http://nominatim.openstreetmap.org/reverse' ]);
 
  static convertXmlToSearchResults(String xml) {
    XmlElement tree = XML.parse(xml);
    var searchResults = new SearchResults(
        timestamp: tree.attributes['timestamp'],
        attribution: tree.attributes['attribution'],
        moreUrl: tree.attributes['more_url'],
        queryString: tree.attributes['querystring'],
        polygon: tree.attributes['polygon'] == "true" ? true : false
    );
    
    List places = new List<Place>();
    
    tree.children.forEach((XmlElement placeXml) {
      var place = new Place(
          int.parse(placeXml.attributes['place_id']),
          latitude: double.parse(placeXml.attributes['lat']),
          longitude: double.parse(placeXml.attributes['lon']),
          displayName: placeXml.attributes['display_name'],
          importance: double.parse(placeXml.attributes['importance'])
//            ,
//            city: placeXml.query("city").
      );
      searchResults.places.add(place);
    });
    
    return searchResults;    
  }
  
  Future<SearchResults> search(final String query) {
    HttpClient client = new HttpClient();
    var url = "${this.baseUriSearch}${Uri.encodeComponent(query)}?format=xml&addressdetails=1";
    return client.getUrl(Uri.parse(url))
      .then((HttpClientRequest request) {
        // Prepare the request then call close on it to send it.
        return request.close();
      })      
      .then((HttpClientResponse response) {
        return response.transform(UTF8.decoder).toList();
      })
      .then((List data) {
        var xml = data.join('');
        return convertXmlToSearchResults(xml);
      });
  }
  
}