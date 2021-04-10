import 'package:flutter/material.dart';

class Quote {
  Quote(
      {this.id,
      @required this.engperson,
      @required this.amhperson,
      @required this.engversion,
      @required this.amhversion,
      @required this.engcategory,
      @required this.amhcategory});

  final int id;
  final String engversion;
  final String amhversion;
  final String engperson;
  final String amhperson;
  final String engcategory;
  final String amhcategory;
  // @override
  // List<Object> get props => [id, engversion, amhversion, person];
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json['id'],
        engperson: json['engperson'],
        amhperson: json['amhperson'],
        engversion: json['engversion'],
        amhversion: json['amhversion'],
        engcategory: json['engcategory'],
        amhcategory: json['amhcategory']);
  }

  Map<String, dynamic> toMap(String colid, String colengper, String colamhper,
      String colengver, String colamhver, String colengcat, String colamhcat) {
    return {
      colid: id,
      colengper: engperson,
      colamhper: amhperson,
      colengver: engversion,
      colamhver: amhversion,
      colengcat: engcategory,
      colamhcat: amhcategory,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['ID'],
      engperson: map['EngPerson'],
      amhperson: map['AmhPerson'],
      engversion: map['EngVersion'],
      amhversion: map['AmhVersion'],
      engcategory: map['EngCategory'],
      amhcategory: map['AmhCategory'],
    );
  }
}
