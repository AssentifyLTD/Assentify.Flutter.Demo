import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageWithHeaders extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit; // Added fit parameter

  const ImageWithHeaders({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover, // Default value for fit
  });

  @override
  State<ImageWithHeaders> createState() => _ImageWithHeadersState();
}

class _ImageWithHeadersState extends State<ImageWithHeaders> {
  Uint8List? _imageBytes;
  Map<String, String> headers = {};
  @override
  void initState() {
    super.initState();

    headers = {
      "X-Api-Key": "Yor Api Key",
    };
    _loadImageWithHeaders();
  }

  Future<void> _loadImageWithHeaders() async {
    try {
      final response =
          await http.get(Uri.parse(widget.imageUrl), headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
        });
      } else {
        debugPrint('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageBytes == null) {
      return const CircularProgressIndicator();
    } else {
      return Image.memory(
        _imageBytes!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }
  }
}
