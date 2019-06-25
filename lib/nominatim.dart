
/// This library is basically a very simple layer for the [OpenStreetMap Nominatim API](http://wiki.openstreetmap.org/wiki/Nominatim),
/// that takes your query and returns a `SearchResults` object so you don't have to
/// take care of making the http request and parsing the results.
/// 
/// Basic usage:
/// 
///     var nominatim = new Nominatim();
///     nominatim.search("Paris, France").then((SearchResults results) {
///       for (Place place in results.places) {
///         print(place.displayName);
///         print(place.longitude);
///         print(place.latitude);
///       });
///     });
/// 
/// If you want to use another///Nominatim* provider, you can do so like this:
/// 
///     // Using MapQuest as Nominatim service
///     var nominatim = new Nominatim("open.mapquestapi.com",
///                                   "nominatim/v1/search.php",
///                                   "nominatim/v1/reverse.php");
///     // Use nominatim as usual
library nominatim;

import "dart:async";
import "dart:io";
import "dart:convert";
import 'package:xml/xml.dart' as xml;

part "place.dart";
part "search_results.dart";

/// Class to use the [Nomatim API](http://wiki.openstreetmap.org/wiki/Nominatim)
/// for openstreetmap.
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
  
  /// Create a configured instance of [Nominatim].
  Nominatim([ this.uriAuthority = 'nominatim.openstreetmap.org', this.searchPath = 'search', this.reversePath = 'reverse' ]);
 
  static convertXmlToSearchResults(String rawXml) {
    final rootNode = xml.parse(rawXml).rootElement;

    final children = rootNode.findElements("place");
    final places = children.map((node) => new Place(
        int.parse(getXmlAttribute(node, 'place_id').value),
        latitude: double.parse(getXmlAttribute(node, 'lat').value),
        longitude: double.parse(getXmlAttribute(node, 'lon').value),
        displayName: getXmlAttribute(node, 'display_name').value,
        importance: double.parse(getXmlAttribute(node, 'importance').value)
    )).toList();

    return new SearchResults(
        timestamp: getXmlAttribute(rootNode, 'timestamp').value,
        attribution: getXmlAttribute(rootNode, 'attribution').value,
        moreUrl: getXmlAttribute(rootNode, 'more_url').value,
        queryString: getXmlAttribute(rootNode, 'querystring').value,
        polygon: getXmlAttribute(rootNode, 'polygon').value == "true" ? true : false,
        places: places
    );
  }

  static xml.XmlAttribute getXmlAttribute<T>(xml.XmlNode node, String name) {
    return node.attributes.firstWhere((n) => n.name.local == name, orElse: () => null);
  }
  
  /// Queries the OpenStreetMap server for given query and returns a [SearchResults] instance.
  /// 
  /// The Uri to retrieve the places is defined with [uriAuthory] and [searchPath].
  Future<SearchResults> search(final String query) async {
    HttpClient client = new HttpClient();

    Uri uri = new Uri.http(this.uriAuthority, this.searchPath, {
      "q": query,
      "format": "xml",
      "addressdetails": "1" 
    });

    final request = await client.getUrl(uri);
    final response = await request.close();
    final data = await response.transform(utf8.decoder).toList();

    var xml = data.join('');
    return convertXmlToSearchResults(xml);
  } 
}