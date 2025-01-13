import 'dart:convert';
import 'dart:io';

import 'package:assentify_demo_app/views/network_image_with_headers.dart';
import 'package:assentify_demo_app/views/signing_screen.dart';
import 'package:assentify_demo_app/views/splash_screen.dart';
import 'package:assentify_demo_app/views/templates_screen.dart';
import 'package:assentify_sdk/assentify_sdk.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({super.key});

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        match(kycEntity!.percentageMatch!.toInt())
                            ? "Verification Successful"
                            : "Verification Failed",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageWithHeaders(
                      imageUrl: kycEntity!.baseImageFace!,
                      width: MediaQuery.sizeOf(context).height / 4,
                      height: MediaQuery.sizeOf(context).height / 4,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          if (match(kycEntity!.percentageMatch!.toInt()))
                            const Icon(Icons.verified)
                          else
                            const Icon(
                              Icons.unpublished_outlined,
                              size: 100,
                            ),
                          Text("${kycEntity!.percentageMatch!}% matches"),
                        ],
                      ),
                    ),
                    ImageWithHeaders(
                      imageUrl: kycEntity!.faces.isNotEmpty
                          ? kycEntity!.faces[0]
                          : kycEntity!.secondImageFace!,
                      width: MediaQuery.sizeOf(context).height / 4,
                      height: MediaQuery.sizeOf(context).height / 4,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                  child: ElevatedButton(
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        assentifySdk!.startContextAwareSigning(
                            onHasTokens: (documentTokens) {
                          final Map<String, String> data = {
                            for (DocumentTokensModel token in documentTokens)
                              token.id.toString(): "Test Token",
                          };

                          _createDocument(data);
                        }, onError: (message) {
                          throw Exception(message);
                        });
                      }),
                )),
          ],
        ));
  }

  bool notMatch(int value) {
    return value <= 40;
  }

  bool match(int value) {
    return value >= 60;
  }

  bool partialMatch(int value) {
    return value > 40 && value < 60;
  }

  void _createDocument(Map<String, String> data) async {
    await assentifySdk!.contextAwareSigning!.createUserDocument(
        data: data,
        onCreateUserDocumentInstance: (createUserDocumentResponseModel) async {
          final bytes =
              base64Decode(createUserDocumentResponseModel.templateInstance);

          final tempDir = await getTemporaryDirectory();

          // Create a file path for the PDF
          final filePath = '${tempDir.path}/document.pdf';

          // Write the bytes to a file
          final file = File(filePath);
          await file.writeAsBytes(bytes);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SigningScreen(
                      file: file,
                      documentId: createUserDocumentResponseModel.documentId,
                      documentInstanceId:
                          createUserDocumentResponseModel.templateInstanceId)));
        },
        onError: (message) {
          throw Exception(message);
        });
  }
}
