import "package:test/test.dart";
import "package:nominatim/nominatim.dart";

var testXml = """
<?xml version="1.0"?>
<searchresults timestamp="Sun, 29 Dec 13 14:47:50 +0000" attribution="Data © OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright" querystring="Wien, Austria" polygon="false" exclude_place_ids="109757,97631645,23055105,5998169072,3670277389,932570,951393,126906308,736818,319215" more_url="http://nominatim.openstreetmap.org/search?format=xml&amp;exclude_place_ids=109757,97631645,23055105,5998169072,3670277389,932570,951393,126906308,736818,319215&amp;addressdetails=1&amp;q=Wien%2C+Austria">
  <place place_id="109757" osm_type="node" osm_id="17328659" place_rank="15" boundingbox="48.2084655761719,48.2084693908691,16.3730907440186,16.3730926513672" lat="48.2084671" lon="16.3730908" display_name="Wien, W, Wien, Österreich" class="place" type="city" importance="0.99144681705381" icon="http://nominatim.openstreetmap.org/images/mapicons/poi_place_city.p.20.png">
    <city>Wien</city>
    <county>W</county>
    <state>Wien</state>
    <country>Österreich</country>
    <country_code>at</country_code>
  </place>
  <place place_id="97631645" osm_type="relation" osm_id="109166" place_rank="8" boundingbox="48.1179046630859,48.3226699829102,16.1818313598633,16.5775146484375" lat="48.2202874" lon="16.3712691231187" display_name="Wien, Österreich" class="boundary" type="administrative" importance="0.99144681705381" icon="http://nominatim.openstreetmap.org/images/mapicons/poi_boundary_administrative.p.20.png">
    <state>Wien</state>
    <country>Österreich</country>
    <country_code>at</country_code>
  </place>
  <place place_id="23055105" osm_type="way" osm_id="8107037" place_rank="30" boundingbox="48.2347183227539,48.2362022399902,16.4134426116943,16.4157428741455" lat="48.2354611" lon="16.4145463276696" display_name="Austria Center Vienna, 1, Bruno-Kreisky-Platz, Kaisermühlen, Donaustadt, Gemeinde Wien, W, Wien, 1220, Österreich" class="place" type="house" importance="0.53865352680439">
    <house>Austria Center Vienna</house>
    <house_number>1</house_number>
    <pedestrian>Bruno-Kreisky-Platz</pedestrian>
    <suburb>Kaisermühlen</suburb>
    <city_district>Donaustadt</city_district>
    <city>Gemeinde Wien</city>
    <county>W</county>
    <state>Wien</state>
    <postcode>1220</postcode>
    <country>Österreich</country>
    <country_code>at</country_code>
  </place>
</searchresults>
""";

main() {
  group("XML Parsing", () {
    test("extracts all SearchResults attributes properly", () {
      SearchResults results = Nominatim.convertXmlToSearchResults(testXml);
      
      expect(results.attribution, equals("Data © OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright"));
      expect(results.timestamp, equals("Sun, 29 Dec 13 14:47:50 +0000"));
      expect(results.queryString, equals("Wien, Austria"));
      expect(results.moreUrl, equals("http://nominatim.openstreetmap.org/search?format=xml&exclude_place_ids=109757,97631645,23055105,5998169072,3670277389,932570,951393,126906308,736818,319215&addressdetails=1&q=Wien%2C+Austria"));
      expect(results.polygon, equals(false));
      
    });
  });
}