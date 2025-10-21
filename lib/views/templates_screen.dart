import 'package:assentify_demo_app/constants/kyc_keys.dart';
import 'package:assentify_demo_app/models/kyc_entity.dart';
import 'package:assentify_demo_app/views/id_verification_screen.dart';
import 'package:assentify_demo_app/views/splash_screen.dart';
import 'package:assentify_sdk/assentify_sdk.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:flutter/services.dart';
KycEntity? kycEntity;

class TemplatesScreen extends StatefulWidget {
  final List<TemplatesByCountry> templatesByCountryList;

  const TemplatesScreen({required this.templatesByCountryList, super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  TemplatesByCountry? selectedCountry;

  @override
  void initState() {
    selectedCountry = widget.templatesByCountryList[0];
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
          children: [
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "Select ID Issuing Country",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TemplatesByCountry>(
                  items: widget.templatesByCountryList
                      .map((TemplatesByCountry item) =>
                          DropdownMenuItem<TemplatesByCountry>(
                            value: item,
                            child: _BuildCountryRow(
                              templatesByCountry: item,
                            ),
                          ))
                      .toList(),
                  value: selectedCountry,
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        )),
                  ),
                  iconStyleData: const IconStyleData(
                    icon:
                        Icon(Icons.arrow_forward_ios, color: Color(0xFF2782FD)),
                    iconEnabledColor: Color(0xFF2782FD),
                    iconDisabledColor: Color(0xFF2782FD),
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    )),
                    offset: Offset(0, 0),
                    elevation: 12,
                    scrollbarTheme: ScrollbarThemeData(
                      radius: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              "Select ID Type Available",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            if (selectedCountry!.name == "Rest of the world")
              Column(
                children: [
                  TemplateItem(
                    isPassport: true,
                    onTap: () {
                      assentifySdk!.startScanPassport(
                          stepID: -1, // Need to by set from the flow
                          language: Language.english,
                          onEvent: (String eventName,
                              PassportExtractedModel? passportDataModel,DoneFlags? doneFlag,) async {
                            if (eventName == EventsKeys.onComplete) {

                              if (eventName == EventsKeys.onComplete) {
                                final ByteData data = await rootBundle.load("assets/images/nfc_image.png");
                                final Uint8List bytes = data.buffer.asUint8List();
                                assentifySdk!.startNfc(
                                    stepID: -1, // Need to by set from the flow
                                    image: bytes,
                                    backGroundColor: "#FFFFFF",
                                    textColor: "#000000",
                                    title: "NFC DETECTED",
                                    subTitle: "Position the passport or ID on the bottom of the phone where the NFC chip reader is and ensure that you have the passport or ID close enough for detection and reading.",
                                    backIconColor: "#000000",
                                    backIconBackGroundColor: "#FFFFFF",
                                    progressBarColor: "#F5A103",
                                    onEvent: (String eventName,
                                        PassportExtractedModel? dataModel) {
                                      kycEntity = KycEntity(
                                          extractedData: _transformOutputProperties(
                                            dataModel!.transformedProperties,
                                          ),
                                          faces: dataModel.faces,
                                          images: [dataModel.imageUrl],
                                          outputProperties:
                                          dataModel.outputProperties,
                                          transformedProperties:
                                          dataModel.transformedProperties,
                                          percentageMatch: 0.0,
                                          baseImageFace: "",
                                          secondImageFace: "",
                                          isLive: false,
                                          nationality: dataModel
                                              .identificationDocumentCapture.nationality
                                              .toString());
                                      _navigateToIdVerificationScreen(
                                        kycEntity: kycEntity!,
                                      );
                                    });
                              }


                            }
                          });
                    },
                    title: "Passport",
                  ),
                  TemplateItem(
                    isPassport: false,
                    onTap: () {
                      assentifySdk!.startScanOther(
                          stepID: -1, // Need to by set from the flow
                          language: Language.english,
                          onEvent: (String eventName,
                              OtherExtractedModel? otherExtractedModel ,   DoneFlags? doneFlag,) async {
                            if (eventName == EventsKeys.onComplete) {
                              kycEntity = KycEntity(
                                  extractedData: _transformOutputProperties(
                                      otherExtractedModel!
                                          .transformedProperties),
                                  faces: otherExtractedModel.faces,
                                  images: [otherExtractedModel.imageUrl],
                                  outputProperties:
                                      otherExtractedModel.outputProperties,
                                  transformedProperties:
                                      otherExtractedModel.transformedProperties,
                                  percentageMatch: 0.0,
                                  baseImageFace: "",
                                  secondImageFace: "",
                                  isLive: false,
                                  nationality: otherExtractedModel
                                          .identificationDocumentCapture
                                          .country ??
                                      selectedCountry!.name);

                              _navigateToIdVerificationScreen(
                                  kycEntity: kycEntity!);
                            }
                          });
                    },
                    title: "Other",
                  ),
                ],
              ),
            if (selectedCountry!.name != "Rest of the world" &&
                selectedCountry!.templates.isNotEmpty)
              ListView.builder(
                  itemCount: selectedCountry!.templates.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 100,
                      child: TemplateItem(
                        onTap: () {
                          assentifySdk!.startScanID(
                              stepID: -1, // Need to by set from the flow
                              language: Language.english,
                              templates: selectedCountry!
                                  .templates[index].kycDocumentDetails,
                              flippingCard: true,
                              onEvent: (
                                String eventName,
                                IDExtractedModel? idDataModel,
                                int order,
                               DoneFlags? doneFlag,
                              ) {
                                if (eventName == EventsKeys.onComplete) {
                                  if (order ==
                                      selectedCountry!.templates[index]
                                              .kycDocumentDetails.length -
                                          1) {
                                    if (selectedCountry!.templates[index]
                                            .kycDocumentDetails.length ==
                                        1) {
                                      kycEntity = KycEntity(
                                          extractedData:
                                              _transformOutputProperties(
                                                  idDataModel!
                                                      .transformedProperties),
                                          faces: idDataModel.faces,
                                          images: [idDataModel.imageUrl],
                                          outputProperties:
                                              idDataModel.outputProperties,
                                          transformedProperties:
                                              idDataModel.transformedProperties,
                                          percentageMatch: 0.0,
                                          baseImageFace: "",
                                          secondImageFace: "",
                                          isLive: false,
                                          nationality:
                                              selectedCountry!.name.toString());
                                      _navigateToIdVerificationScreen(
                                          kycEntity: kycEntity!);
                                    } else {
                                      kycEntity = kycEntity!.merge(
                                        KycEntity(
                                            extractedData:
                                                _transformOutputProperties(
                                                    idDataModel!
                                                        .transformedProperties),
                                            faces: idDataModel.faces,
                                            images: [idDataModel.imageUrl],
                                            outputProperties:
                                                idDataModel.outputProperties,
                                            transformedProperties: idDataModel
                                                .transformedProperties,
                                            percentageMatch: 0.0,
                                            baseImageFace: "",
                                            secondImageFace: "",
                                            isLive: false,
                                            nationality: selectedCountry!.name
                                                .toString()),
                                      );
                                      _navigateToIdVerificationScreen(
                                          kycEntity: kycEntity!);
                                    }
                                  } else {
                                    kycEntity = KycEntity(
                                        extractedData:
                                            _transformOutputProperties(
                                                idDataModel!
                                                    .transformedProperties),
                                        faces: idDataModel.faces,
                                        images: [idDataModel.imageUrl],
                                        outputProperties:
                                            idDataModel.outputProperties,
                                        transformedProperties:
                                            idDataModel.transformedProperties,
                                        percentageMatch: 0.0,
                                        baseImageFace: "",
                                        secondImageFace: "",
                                        nationality: selectedCountry!.name);
                                  }
                                }
                              });
                        },
                        title: removeWord(
                            selectedCountry!.templates[index].kycDocumentType,
                            "Lebanese"),
                        icon: selectedCountry!
                                .templates[index].kycDocumentDetails.isNotEmpty
                            ? selectedCountry!.templates[index]
                                .kycDocumentDetails[0].templateSpecimen
                            : "",
                      ),
                    );
                  }),
          ],
        ),
      ),
    );
  }

  _navigateToIdVerificationScreen({required KycEntity kycEntity}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const IdVerificationScreen()));
  }

  String removeWord(String input, String word) {
    RegExp regExp = RegExp('\\b${RegExp.escape(word)}\\b');
    String output = input.replaceAll(regExp, '');
    output = output.replaceAll(RegExp(' +'), ' ').trim();

    return output;
  }

  Map<String, dynamic> _transformOutputProperties(
      Map<String, dynamic>? outputProperties) {
    final Map<String, dynamic> extractedData = {};
    outputProperties?.forEach((key, value) {
      if (key.contains(KycKeys.identificationDocumentCaptureBirthDate)) {
        extractedData["Birth Date"] = value;
      } else if (key
          .contains(KycKeys.identificationDocumentCaptureExpiryDate)) {
        extractedData["Expiry Date"] = value;
      } else {
        final newKey = key.split("_").last.replaceAll("_", " ");
        extractedData[newKey] = value;
      }
    });
    return extractedData;
  }
}

class TemplateItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isPassport;
  final Function? onTap;

  const TemplateItem(
      {super.key,
      required this.onTap,
      required this.title,
      this.icon = "",
      this.isPassport = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF707070).withAlpha(25),
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            )),
        child: ListTile(
          onTap: () {
            onTap!();
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          title: Row(
            children: [
              if (icon.isNotEmpty && !isPassport)
                Row(
                  children: [
                    Image.network(
                      icon,
                      width: 50,
                      height: 40,
                    ),
                  ],
                ),
              if (isPassport)
                const Row(
                  children: [
                    Icon(
                      Icons.perm_identity_outlined,
                      size: 30,
                    )
                  ],
                ),
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF2782FD)),
        ),
      ),
    );
  }
}

class _BuildCountryRow extends StatelessWidget {
  final TemplatesByCountry templatesByCountry;

  const _BuildCountryRow({required this.templatesByCountry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        templatesByCountry.flag == ""
            ? const SizedBox(
                width: 50,
                height: 40,
                child: Icon(Icons.public),
              )
            : Image.network(
                templatesByCountry.flag,
                width: 50,
                height: 40,
              ),
        const SizedBox(
          width: 10,
        ),
        Text(
          templatesByCountry.name,
        ),
      ],
    );
  }
}
