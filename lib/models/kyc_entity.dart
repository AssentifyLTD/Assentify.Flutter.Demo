import 'dart:convert';

class KycEntity {
  final Map<String, dynamic> extractedData;
  final List<String> faces;
  final List<String> images;
  final Map<String, dynamic> outputProperties;
  final Map<String, String> transformedProperties;
  final String? baseImageFace;
  final String? secondImageFace;
  final double? percentageMatch;
  final bool? isLive;
  final String? nationality;

  KycEntity({
    required this.extractedData,
    required this.faces,
    required this.images, // Updated to List<String>
    required this.outputProperties,
    required this.transformedProperties,
    this.baseImageFace,
    this.secondImageFace,
    this.percentageMatch,
    this.isLive,
    this.nationality,
  });

  factory KycEntity.fromJson(Map<String, dynamic> json) {
    return KycEntity(
        extractedData: Map<String, dynamic>.from(json['extractedData'] ?? {}),
        faces: List<String>.from(json['faces'] ?? []),
        images: List<String>.from(json['images'] ?? []),
        outputProperties:
            Map<String, dynamic>.from(json['outputProperties'] ?? {}),
        transformedProperties:
            Map<String, String>.from(json['transformedProperties'] ?? {}),
        baseImageFace: json['baseImageFace'],
        secondImageFace: json['secondImageFace'],
        percentageMatch: json['percentageMatch'],
        isLive: json['isLive'],
        nationality: json["nationality"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'extractedData': extractedData,
      'faces': faces,
      'images': images, // Updated to List<String>
      'outputProperties': outputProperties,
      'transformedProperties': transformedProperties,
      'baseImageFace': baseImageFace,
      'secondImageFace': secondImageFace,
      'percentageMatch': percentageMatch,
      'isLive': isLive,
      'nationality': nationality,
    };
  }

  factory KycEntity.fromJsonString(String jsonString) {
    final jsonData = json.decode(jsonString);
    return KycEntity.fromJson(jsonData);
  }

  String toJsonString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }

  KycEntity merge(KycEntity other) {
    return KycEntity(
      extractedData: {...extractedData, ...other.extractedData},
      faces: [...faces, ...other.faces],
      images: [...images, ...other.images],
      outputProperties: {...outputProperties, ...other.outputProperties},
      transformedProperties: {
        ...transformedProperties,
        ...other.transformedProperties
      },
      baseImageFace: baseImageFace ?? other.baseImageFace,
      secondImageFace: secondImageFace ?? other.secondImageFace,
      percentageMatch: percentageMatch ?? other.percentageMatch,
      isLive: isLive ?? other.isLive,
      nationality: nationality ?? other.nationality,
    );
  }

  @override
  String toString() {
    return """KycEntity(
      percentageMatch: $percentageMatch,
      isLive: $isLive,
      nationality: $nationality)""";
  }
}
