import 'package:assentify_demo_app/controllers/app_controller.dart';
import 'package:assentify_demo_app/views/templates_screen.dart';
import 'package:assentify_sdk/assentify_sdk.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

AssentifySdk? assentifySdk;
const String apiKey = "Your Api  Key";
const String hashKey = "Your Flow Hash Key";
const String tenantIdentifier = "Your Tenant Identifier";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final List<TemplatesByCountry> templatesByCountry;

  @override
  void initState() {
    initAssentifySdk();
    super.initState();
  }

  void initAssentifySdk() async {
    if (await Permission.camera.request().isGranted) {
      assentifySdk = AssentifySdk(
        onAssentifySdkInitError: (String message) {
          debugPrint("onAssentifySdkInitError : $message");
        },
        onAssentifySdkInitSuccess: (ConfigModel configModel) {
          var templates = assentifySdk!.getTemplates();

          templates.add(TemplatesByCountry(
            id: -1,
            name: "Rest of the world",
            sourceCountryCode: "",
            flag: "",
            templates: [],
          ));

          templatesByCountry = templates;

          AppController.setgettingData(true);
          AppController.setConfigModel(configModel);
          setState(() {});
        },
      );

      assentifySdk!.init(
        apiKey: apiKey,
        hashKey: hashKey,
        holdHandColor: "#016FFF",
        tenantIdentifier: tenantIdentifier,
        processingColor: "#FFFFFF",
        processMrz: true,
        storeCapturedDocument: true,
        performLivenessDocument: false,
        performLivenessFace: false,
        storeImageStream: true,
        saveCapturedVideoID: true,
        saveCapturedVideoFace: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!AppController.gettingData)
              Image.asset(
                "assets/images/grey loader.gif",
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        minimumSize: WidgetStateProperty.all(
                            Size(MediaQuery.sizeOf(context).width / 2.5, 56)),
                        foregroundColor: WidgetStateProperty.all(
                            AppController.gettingData
                                ? const Color(0xFF2782FD)
                                : Colors.grey.withOpacity(0.5)),
                        backgroundColor: WidgetStateProperty.all(
                            AppController.gettingData
                                ? const Color(0xFF2782FD)
                                : Colors.grey.withOpacity(0.5)),
                      ),
                  onPressed: () {
                    AppController.gettingData
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TemplatesScreen(
                                      templatesByCountryList:
                                          templatesByCountry,
                                    )))
                        : null;
                  },
                  child: Text(
                    "Start",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
