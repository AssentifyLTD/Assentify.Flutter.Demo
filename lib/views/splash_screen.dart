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
        apiKey: "",
        hashKey: "",
        tenantIdentifier: "",
        customColor: "#016FFF",
        manualClickColor: "#016FFF",
        activePerformLivenessFace: false,
        enableDetect: true,  // Default  false
        enableGuide: true,  // Default  true// Default  true
        androidMotionCardLimit: 10, // Default  10
        androidMotionPassportLimit: 15, // Default  15
        iOSMotionCardsLimit: 30, //Default  30
        iOSMotionFaceLimit: 5, // Default  5
        androidBrightnessHighThreshold: 180, // Default  180
        androidBrightnessLowThreshold: 50, //  Default  50
        iOSBrightnessHighThreshold: 255, // Default  255
        iOSBrightnessLowThreshold: 50, // Default  50
        activeLiveType: ActiveLiveType.blink, // Default  none
        activeLivenessCheckCount: 1, // Default  0,
        retryCount: 2, // Default  3,
        faceLivenessRetryCount: 2, // Default  2,
        minRam: 0, // Default  8,
        iOSMinRam: 0, // Default  2,
        minCPUCores: 0, //  Default  6,
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
