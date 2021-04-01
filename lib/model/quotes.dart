import 'package:flutter/material.dart';

class Quote {
  Quote({
    this.id,
    @required this.engperson,
    @required this.amhperson,
    @required this.engversion,
    @required this.amhversion,
  });

  final int id;
  final String engversion;
  final String amhversion;
  final String engperson;
  final String amhperson;

  // @override
  // List<Object> get props => [id, engversion, amhversion, person];
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json['id'],
        engperson: json['engperson'],
        amhperson: json['amhperson'],
        engversion: json['engversion'],
        amhversion: json['amhversion']);
  }
}
