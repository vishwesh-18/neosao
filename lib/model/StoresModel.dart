class StoresModel {
  String? code;
  String? storeLocation;
  String? latitude;
  String? longitude;
  String? storeAddress;
  String? timezone;
  double? distance;
  int? isNearestStore;
  String? dayOfWeek;
  String? startTime;
  String? endTime;

  StoresModel(
      {this.code,
      this.storeLocation,
      this.latitude,
      this.longitude,
      this.storeAddress,
      this.timezone,
      this.distance,
      this.isNearestStore,
      this.dayOfWeek,
      this.startTime,
      this.endTime});

  StoresModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    storeLocation = json['storeLocation'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    storeAddress = json['storeAddress'];
    timezone = json['timezone'];
    distance = json['distance'];
    isNearestStore = json['isNearestStore'];
    dayOfWeek = json['dayOfWeek'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }
}
