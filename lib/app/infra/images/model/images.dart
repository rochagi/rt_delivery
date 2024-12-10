// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum OperationType { coleta, hawb }

class Images {
  final String id;
  final OperationType operationType;
  final String imageType;
  final String imagePath;
  final String imageName;

  Images(
      {required this.id,
      required this.operationType,
      required this.imageType,
      required this.imagePath,
      required this.imageName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'operationType': operationType.name,
      'imageType': imageType,
      'imagePath': imagePath,
      'imageName': imageName,
    };
  }

  factory Images.fromMap(Map<String, dynamic> map) {
    return Images(
      id: map['id'] as String,
      operationType: map['operationType'] == OperationType.coleta.name
          ? OperationType.coleta
          : OperationType.hawb,
      imageType: map['imageType'] as String,
      imagePath: map['imagePath'] as String,
      imageName: map['imageName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Images.fromJson(String source) =>
      Images.fromMap(json.decode(source) as Map<String, dynamic>);


      

  @override
  bool operator ==(covariant Images other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.operationType == operationType &&
      other.imageType == imageType &&
      other.imagePath == imagePath &&
      other.imageName == imageName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      operationType.hashCode ^
      imageType.hashCode ^
      imagePath.hashCode ^
      imageName.hashCode;
  }
}
