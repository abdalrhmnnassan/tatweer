import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

Store_Info storeFromJson(String str) => Store_Info.fromJson(json.decode(str));

String storeToJson(Store_Info data) => json.encode(data.toJson());

class Store_Info {
  Store_Info({
    this.mainStore,
    this.countriesBranches,
  });

  MainStore mainStore;
  List<CountriesBranch> countriesBranches;

  factory Store_Info.fromJson(Map<String, dynamic> json) => Store_Info(
    mainStore: MainStore.fromJson(json["mainStore"]),
    countriesBranches: List<CountriesBranch>.from(json["countriesBranches"].map((x) => CountriesBranch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mainStore": mainStore.toJson(),
    "countriesBranches": List<dynamic>.from(countriesBranches.map((x) => x.toJson())),
  };
}

class CountriesBranch {
  CountriesBranch({
    this.id,
    this.countryName,
    this.citiesBranches,
  });

  int id;
  String countryName;
  List<CitiesBranch> citiesBranches;

  factory CountriesBranch.fromJson(Map<String, dynamic> json) => CountriesBranch(
    id: json["id"],
    countryName: json["countryName"],
    citiesBranches: List<CitiesBranch>.from(json["citiesBranches"].map((x) => CitiesBranch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "countryName": countryName,
    "citiesBranches": List<dynamic>.from(citiesBranches.map((x) => x.toJson())),
  };
}

class CitiesBranch {
  CitiesBranch({
    this.id,
    this.cityName,
    this.branches,
  });

  int id;
  String cityName;
  List<MainStore> branches;

  factory CitiesBranch.fromJson(Map<String, dynamic> json) => CitiesBranch(
    id: json["id"],
    cityName: json["cityName"],
    branches: List<MainStore>.from(json["branches"].map((x) => MainStore.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cityName": cityName,
    "branches": List<dynamic>.from(branches.map((x) => x.toJson())),
  };
}

class MainStore {
  MainStore({
    this.id,
    this.name,
    this.code,
    this.subDescription,
    this.description,
    this.typeId,
    this.gps,
    this.address,
    this.freeNumber,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.website,
    this.email,
    this.parentId,
    this.originalLogoPath,
    this.originalLogoId,
    this.originalPicturePath,
    this.originalPictureId,
    this.picturePath,
    this.isActive,
    this.storeType,
  });

  int id;
  String name;
  Code code;
  dynamic subDescription;
  String description;
  String typeId;
  dynamic gps;
  Address address;
  dynamic freeNumber;
  String phoneNumber1;
  String phoneNumber2;
  dynamic phoneNumber3;
  String website;
  String email;
  int parentId;
  String originalLogoPath;
  String originalLogoId;
  String originalPicturePath;
  String originalPictureId;
  String picturePath;
  bool isActive;
  StoreType storeType;

  factory MainStore.fromJson(Map<String, dynamic> json) => MainStore(
    id: json["id"],
    name: json["name"],
    code: codeValues.map[json["code"]],
    subDescription: json["subDescription"],
    description: json["description"],
    typeId: json["typeID"],
    gps: json["gps"],
    address: Address.fromJson(json["address"]),
    freeNumber: json["freeNumber"],
    phoneNumber1: json["phoneNumber1"],
    phoneNumber2: json["phoneNumber2"] == null ? null : json["phoneNumber2"],
    phoneNumber3: json["phoneNumber3"],
    website: json["website"],
    email: json["email"] == null ? null : json["email"],
    parentId: json["parentId"] == null ? null : json["parentId"],
    originalLogoPath: json["originalLogoPath"] == null ? null : json["originalLogoPath"],
    originalLogoId: json["originalLogoId"],
    originalPicturePath: json["originalPicturePath"] == null ? null : json["originalPicturePath"],
    originalPictureId: json["originalPictureId"],
    picturePath: json["picturePath"],
    isActive: json["isActive"],
    storeType: StoreType.fromJson(json["storeType"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": codeValues.reverse[code],
    "subDescription": subDescription,
    "description": description,
    "typeID": typeId,
    "gps": gps,
    "address": address.toJson(),
    "freeNumber": freeNumber,
    "phoneNumber1": phoneNumber1,
    "phoneNumber2": phoneNumber2 == null ? null : phoneNumber2,
    "phoneNumber3": phoneNumber3,
    "website": website,
    "email": email == null ? null : email,
    "parentId": parentId == null ? null : parentId,
    "originalLogoPath": originalLogoPath == null ? null : originalLogoPath,
    "originalLogoId": originalLogoId,
    "originalPicturePath": originalPicturePath == null ? null : originalPicturePath,
    "originalPictureId": originalPictureId,
    "picturePath": picturePath,
    "isActive": isActive,
    "storeType": storeType.toJson(),
  };
}

class Address {
  Address({
    this.id,
    this.gps,
    this.distance,
    this.country,
    this.city,
    this.district,
    this.note,
  });

  int id;
  String gps;
  double distance;
  City country;
  City city;
  City district;
  String note;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    gps: json["gps"],
    distance: json["distance"],
    country: City.fromJson(json["country"]),
    city: City.fromJson(json["city"]),
    district: City.fromJson(json["district"]),
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gps": gps,
    "distance": distance,
    "country": country.toJson(),
    "city": city.toJson(),
    "district": district.toJson(),
    "note": note,
  };
}

class City {
  City({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

enum Code { O3, ABC }

final codeValues = EnumValues({
  "ABC": Code.ABC,
  "O3": Code.O3
});

class StoreType {
  StoreType({
    this.id,
    this.name,
    this.isActive,
  });

  String id;
  Name name;
  bool isActive;

  factory StoreType.fromJson(Map<String, dynamic> json) => StoreType(
    id: json["id"],
    name: nameValues.map[json["name"]],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "isActive": isActive,
  };
}

enum Name { EMPTY }

final nameValues = EnumValues({
  "البسة": Name.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}