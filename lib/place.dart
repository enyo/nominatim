part of nominatim;

/**
 * Holds information about an OpenStreetMap Nominatim Place.
 * 
 * You normally access this through `SearchResults.places`.
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
