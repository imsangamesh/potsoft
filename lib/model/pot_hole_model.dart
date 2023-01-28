import 'package:cloud_firestore/cloud_firestore.dart';

class PotholeModel {
  final String id, image, name, street, subArea, city, country, postCode;
  final double lat, long;
  final String date;
  final Timestamp createdAt;
  final String isVerified, description;

  PotholeModel({
    required this.id,
    required this.image,
    required this.name,
    required this.street,
    required this.subArea,
    required this.city,
    required this.country,
    required this.postCode,
    required this.lat,
    required this.long,
    required this.date,
    required this.createdAt,
    required this.isVerified,
    required this.description,
  });

  toMap() => {
        'id': id,
        'image': image,
        'name': name,
        'street': street,
        'subArea': subArea,
        'city': city,
        'country': country,
        'postCode': postCode,
        'date': date,
        'lat': lat,
        'long': long,
        'createdAt': createdAt,
        'isVerified': isVerified,
        'description': description,
      };

  static PotholeModel fromMap(Map<String, dynamic> map) {
    return PotholeModel(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      street: map['street'],
      subArea: map['subArea'],
      city: map['city'],
      country: map['country'],
      postCode: map['postCode'],
      date: map['date'],
      lat: map['lat'],
      long: map['long'],
      createdAt: map['createdAt'],
      isVerified: map['isVerified'],
      description: map['description'],
    );
  }
}
