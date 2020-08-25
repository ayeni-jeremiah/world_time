class Cities {
  String id;
  String name;
  String countryCode;
  String lon;
  String lat;

  Cities({this.id, this.name, this.countryCode, this.lat, this.lon});

  factory Cities.fromJson(Map<String, dynamic> parsedJson) {
    return Cities(
        id: parsedJson['id'].toString(),
        name: parsedJson['name'].toString(),
        countryCode: parsedJson['country'].toString(),
        lat: parsedJson['coord']['lat'].toString(),
        lon: parsedJson['coord']['lon'].toString()
    );
  }

  @override
  String toString() {
    return '{id: ${this.name}, name: ${this.name}, countryCode: ${this.countryCode}, lat: ${this.lat}, lon: ${this.lon}}';
  }
}
