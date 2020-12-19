// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

List<Location> locationFromJson(String str) => List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String locationToJson(List<Location> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
  Location({
    this.id,
    this.typeId,
    this.parentId,
    this.name,
    this.gps,
    this.borderNodes,
    this.isActive,
    this.children,
  });

  int id;
  int typeId;
  int parentId;
  String name;
  dynamic gps;
  dynamic borderNodes;
  bool isActive;
  List<Location> children;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    typeId: json["typeId"],
    parentId: json["parentId"] == null ? null : json["parentId"],
    name: json["name"],
    gps: json["gps"],
    borderNodes: json["borderNodes"],
    isActive: json["isActive"],
    children: List<Location>.from(json["children"].map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "typeId": typeId,
    "parentId": parentId == null ? null : parentId,
    "name": name,
    "gps": gps,
    "borderNodes": borderNodes,
    "isActive": isActive,
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
  };
}
