import 'package:assentify_demo_app/controllers/app_controller.dart';
import 'package:assentify_demo_app/models/kyc_entity.dart';
import 'package:assentify_demo_app/views/face_verification_screen.dart';
import 'package:assentify_demo_app/views/flip_image_widget.dart';
import 'package:assentify_demo_app/views/splash_screen.dart';
import 'package:assentify_demo_app/views/templates_screen.dart';
import 'package:assentify_sdk/assentify_sdk.dart';
import 'package:flutter/material.dart';

class IdVerificationScreen extends StatefulWidget {
  const IdVerificationScreen({super.key});

  @override
  State<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends State<IdVerificationScreen> {
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  MediaQuery.sizeOf(context).height * 0.55 +
                  56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: FlipImageWidget(images: kycEntity!.images),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Text(
                          "Scanning Successfully",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 1.6,
                          child: const Text(
                            "Please Check Your Data Before Submitting it",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.5,
                child: GestureDetector(
                  onTap: () {
                    _draggableScrollableController.animateTo(
                      1.0, // Fully expand to 100% height
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: DraggableScrollableSheet(
                      controller: _draggableScrollableController,
                      initialChildSize: 0.55,
                      // Initially show 55% of the screen height
                      minChildSize: 0.55,
                      // The minimum height (collapsed)
                      maxChildSize: 1.0,
                      // The maximum height (expanded)
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 22),
                          decoration: const BoxDecoration(
                              color: Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(43),
                                  topRight: Radius.circular(43))),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 66,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Scanning Data",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )),
                              ),
                              Column(
                                  children: kycEntity!.extractedData.entries
                                      .map((entry) {
                                return !isUrl(entry.value.toString()) &&
                                        !isNull(entry.value)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4),
                                                    child: Text(
                                                      entry.key,
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  entry.value.toString(),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      )
                                    : const Center();
                              }).toList()),
                              const SizedBox(
                                height: 75,
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
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
                      onPressed: () async {
                        if (kycEntity!.images.isNotEmpty) {
                          await AppController.urlToBase64(
                                  kycEntity!.images[0], apiKey)
                              .then((cardImage) => {
                                    assentifySdk!.startFaceMatch(
                                        image: cardImage,
                                        onEvent: (
                                          String eventName,
                                          FaceExtractedModel?
                                              faceExtractedModel,
                                        ) async {
                                          if (eventName ==
                                              EventsKeys.onComplete) {
                                            kycEntity = KycEntity(
                                              extractedData: faceExtractedModel!
                                                  .extractedData,
                                              faces: const [],
                                              images: const [],
                                              outputProperties:
                                                  faceExtractedModel
                                                      .outputProperties,
                                              transformedProperties: const {},
                                              percentageMatch:
                                                  faceExtractedModel
                                                      .percentageMatch!
                                                      .toDouble(),
                                              baseImageFace: faceExtractedModel
                                                  .baseImageFace,
                                              secondImageFace:
                                                  faceExtractedModel
                                                      .secondImageFace,
                                              isLive: false,
                                              nationality:
                                                  kycEntity!.nationality,
                                            );

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FaceVerificationScreen()));
                                          }
                                        })
                                  });
                        }
                      }),
                ))
          ],
        ));
  }

  bool isUrl(String item) {
    return item.contains("http") || item.contains("Http");
  }

  bool isNull(String? value) {
    return value == null || value == "null" || value == "Null";
  }
}
