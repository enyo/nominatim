

import "dart:async";
import "dart:io";
import "dart:convert";
import "package:xml/xml.dart";


/**
 * Holds information about an OpenStreetMap Nominatim SearchResult and
 * the list of places returned.
 */
class SearchResults {
  
  final List<Place> places;

  final String timestamp;
  
  final String attribution;
 
  final String moreUrl;

  final String queryString;
  
  final bool polygon;
  
  /**
   * Creates a new [SearchResult] with given attributes.
   */
  SearchResults({ this.timestamp, this.attribution, this.moreUrl, this.queryString, this.polygon, this.places });
  
  String toString() {
    var string = new List();
    string.add("SearchResult (${timestamp})");
    
    this.places.forEach((place) {
      string.add("  - ${place.displayName}");
    });
    return string.join("\n");
  }
  
}

/**
 * Holds information about an OpenStreetMap Nominatim Place.
 */
class Place {
  
  
  /// E.g.: 1620612
  final int id;
  
  /// Latitude of this place
  final double latitude;
  
  /// Longitude of this place
  final double longitude;
  
  /// E.g.: 135, Pilkington Avenue, Wylde Green, City of Birmingham, West Midlands (county), B72, United Kingdom
  final String displayName;
  
  
  final double importance;
    
  /// E.g.: 135
  final String house;
  
  /// E.g.: Pilkington Avenue
  final String road;
  
  /// E.g.: City of Birmingham
  final String city;
  
  /// E.g.: Sutton Coldfield
  final String town;
  
  /// E.g.: Wylde Green
  final String village;
  
  /// E.g.: West Midlands (county)
  final String county;
  
  /// E.g.: Wien
  final String state;
  
  /// E.g.: B72
  final String postcode;
  
  /// E.g.: United Kingdom
  final String country;
  
  /// Two letter code
  final String countryCode;

  Place(this.id, { this.latitude, this.longitude, this.displayName, this.importance, this.city, this.county, this.state, this.country, this.countryCode, this.postcode, this.town, this.village, this.road, this.house });
  
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
      places.add(place);
    });
    
    var searchResults = new SearchResults(
        timestamp: tree.attributes['timestamp'],
        attribution: tree.attributes['attribution'],
        moreUrl: tree.attributes['more_url'],
        queryString: tree.attributes['querystring'],
        polygon: tree.attributes['polygon'] == "true" ? true : false,
        places: places
    );

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