

import "dart:async";
import "dart:io";
import "dart:convert";
import "package:xml/xml.dart";


/**
 * Holds information about an OpenStreetMap Nominatim SearchResult and
 * the list of places returned.
 * 
 * An instance of this class is returned when using [Nominatim.search].
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

  /**
   * Create a place instance. You get a list of those in a [SearchResults] object.
   */
  Place(this.id, { this.latitude, this.longitude, this.displayName, this.importance, this.city, this.county, this.state, this.country, this.countryCode, this.postcode, this.town, this.village, this.road, this.house });
  
}


/**
 * Class to use the [Nomatim API](http://wiki.openstreetmap.org/wiki/Nominatim)
 * for openstreetmap.
 */
class Nominatim {
  
  final String uriAuthority;
  
  final String searchPath;
  
  final String reversePath;
  
  /**
   * Use any other URI String for the search.
   * 
   * E.g.: http://open.mapquestapi.com/nominatim/v1/search.php
   */
  Nominatim([ String this.uriAuthority = 'nominatim.openstreetmap.org', String this.searchPath = 'search', String this.reversePath = 'reverse' ]);
 
  static convertXmlToSearchResults(String xml) {
    XmlElement tree = XML.parse(xml);
    
    List places = new List<Place>();
    
    for (XmlElement placeXml in tree.children) {
      var place = new Place(
          int.parse(placeXml.attributes['place_id']),
          latitude: double.parse(placeXml.attributes['lat']),
          longitude: double.parse(placeXml.attributes['lon']),
          displayName: placeXml.attributes['display_name'],
          importance: double.parse(placeXml.attributes['importance'])
      );
      places.add(place);
    }
    
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
  
  /**
   * Queries the OpenStreetMap server for given query and returns a [SearchResults] instance.
   * 
   * The Uri to retrieve the places is defined with [uriAuthory] and [searchPath].
   */
  Future<SearchResults> search(final String query) {
    HttpClient client = new HttpClient();

    Uri uri = new Uri.http(this.uriAuthority, this.searchPath, { "q": query, "format": "xml", "addressdetails": "1" });
    print(uri);

//    uri.queryParameters["query"] = query;
//    uri.queryParameters["format"] = "xml";
//    uri.queryParameters["addressdetails"] = "1";

    return client.getUrl(uri)
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