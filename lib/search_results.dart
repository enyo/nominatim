part of nominatim;

///
/// Holds information about an OpenStreetMap Nominatim SearchResult and
/// the list of places returned.
/// 
/// An instance of this class is returned when using [Nominatim.search].
///
class SearchResults {
  final List<Place> places;

  final String timestamp;
  
  final String attribution;
 
  final String moreUrl;

  final String queryString;
  
  final bool polygon;
  
  /// Creates a new [SearchResults] with given attributes.
  SearchResults({ this.timestamp, this.attribution, this.moreUrl, this.queryString, this.polygon, this.places });
  
  String toString() {
    var string = new List();
    string.add("SearchResults ($timestamp)");
    
    this.places.forEach((place) {
      string.add("  - ${place.displayName}");
    });
    return string.join("\n");
  }
}

