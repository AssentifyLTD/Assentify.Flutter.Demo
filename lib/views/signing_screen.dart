import 'dart:convert';
import 'dart:io';

import 'package:assentify_demo_app/constants/kyc_keys.dart';
import 'package:assentify_demo_app/controllers/app_controller.dart';
import 'package:assentify_demo_app/views/splash_screen.dart';
import 'package:assentify_sdk/assentify_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SigningScreen extends StatefulWidget {
  final String? url;
  final File? file;
  final int? documentInstanceId;
  final int? documentId;
  const SigningScreen(
      {super.key,
      this.url,
      this.file,
      this.documentInstanceId,
      this.documentId});

  @override
  State<SigningScreen> createState() => _SigningScreenState();
}

class _SigningScreenState extends State<SigningScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.file != null)
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Signature(
                        controller: _controller,
                        backgroundColor: Colors.white,
                      ))),
            if (widget.file != null)
              ElevatedButton(
                  onPressed: () {
                    _controller.toPngBytes().then((data) {
                      if (data != null) {
                        assentifySdk!.contextAwareSigning!.signature(
                            documentId: widget.documentId!,
                            documentInstanceId: widget.documentInstanceId!,
                            signature: base64.encode(data),
                            onSignature: (value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SigningScreen(
                                            url: value.signedDocumentUri,
                                          )));
                            },
                            onError: (message) {});
                      }
                    });
                  },
                  child: const Text(
                    "Sign",
                    style: TextStyle(color: Colors.white),
                  )),
            Expanded(
                flex: 2,
                child: widget.file != null
                    ? SfPdfViewer.file(widget.file!)
                    : SfPdfViewer.network(widget.url!)),
            if (widget.url != null)
              ElevatedButton(
                onPressed: () {
                  _submitData();
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ));
  }

  void _submitData() async {
    final ConfigModel configModel = AppController.configModel!;

    Map<String, dynamic>? blockLoaderStep = {};

    blockLoaderStep.addEntries([
      MapEntry(BlockLoaderKeys.deviceName, Platform.operatingSystem),
      MapEntry(BlockLoaderKeys.flowName, configModel.flowName),
      MapEntry(BlockLoaderKeys.instanceHash, configModel.instanceHash),
      MapEntry(BlockLoaderKeys.interactionID, configModel.instanceId),
      const MapEntry(BlockLoaderKeys.userAgent, BlockLoaderKeys.application),
      MapEntry(BlockLoaderKeys.timeStarted, _getCurrentFormattedTime()),
      const MapEntry(KycKeys.phoneNumber, "Your Phone Number"),
    ]);

    await assentifySdk!.submitData(
        overrideData: {},
        blockLoaderStep: blockLoaderStep,
        timeEnded: _getCurrentFormattedTime(),
        onEvent: (
          String eventName,
          String? message,
        ) async {
          if (eventName == "SubmitSuccess") {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Submitted")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please Try Again")));
          }
        });
  }

  static String _getCurrentFormattedTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
    return formattedDate;
  }
}
