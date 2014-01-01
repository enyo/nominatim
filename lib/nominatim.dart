/**
 * This library is basically a very simple layer for the [OpenStreetMap Nominatim API](http://wiki.openstreetmap.org/wiki/Nominatim),
 * that takes your query and returns a `SearchResults` object so you don't have to
 * take care of making the http request and parsing the results.
 * 
 * Basic usage:
 * 
 *     var nominatim = new Nominatim();
 *     nominatim.search("Paris, France").then((SearchResults results) {
 *       for (Place place in results.places) {
 *         print(place.displayName);
 *         print(place.longitude);
 *         print(place.latitude);
 *       });
 *     });
 * 
 * If you want to use another *Nominatim* provider, you can do so like this:
 * 
 *     // Using MapQuest as Nominatim service
 *     var nominatim = new Nominatim("open.mapquestapi.com",
 *                                   "nominatim/v1/search.php",
 *                                   "nominatim/v1/reverse.php");
 *     // Use nominatim as usual
 * 
 */
library nominatim;

import "dart:async";
import "dart:io";
import "dart:convert";
import "package:xml/xml.dart";

part "place.dart";
part "search_results.dart";


/**
 * Class to use the [Nomatim API](http://wiki.openstreetmap.org/wiki/Nominatim)
 * for openstreetmap.
 */
class Nominatim {
  
  /// The authority part of the request.
  /// 
  /// E.g.: "open.mapquestapi.com"
  final String uriAuthority;
  
  /// The path of a search request.
  /// 
  /// E.g.: "nominatim/v1/search.php"
  final String searchPath;
  
  /// The path of a reverse request.
  /// 
  ///  E.g.: "nominatim/v1/reverse.php"
  final String reversePath;
  
  /**
   * Create a configured instance of [Nominatim].
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