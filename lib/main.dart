import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int batchIconNumber = 0;

  String currentIconName = "?";

  bool loading = false;
  bool showAlert = true;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterDynamicIcon.getApplicationIconBadgeNumber().then((v) {
      setState(() {
        batchIconNumber = v;
      });
    });

    FlutterDynamicIcon.getAlternateIconName().then((v) {
      setState(() {
        currentIconName = v ?? "`primary`";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Dynamic App Icon'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Current batch number: $batchIconNumber",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextField(
              controller: controller,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("\\d+")),
              ],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Set Batch Icon Number",
                suffixIcon: loading
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                            // strokeWidth: 2,
                            ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await FlutterDynamicIcon
                                .setApplicationIconBadgeNumber(
                                    int.parse(controller.text));
                            batchIconNumber = await FlutterDynamicIcon
                                .getApplicationIconBadgeNumber();
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Successfully changed batch number"),
                              ));
                            }
                          } on PlatformException {
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Failed to change batch number"),
                              ));
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Failed to change batch number"),
                              ));
                            }
                          }

                          setState(() {
                            loading = false;
                          });
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
