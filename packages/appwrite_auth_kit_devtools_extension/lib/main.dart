import 'dart:async';
import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppwriteAuthKitDevToolsExtension());
}

class AppwriteAuthKitDevToolsExtension extends StatelessWidget {
  const AppwriteAuthKitDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    // final b = extensionManager.postMessageToDevTools(event)

    return const DevToolsExtension(
      child: ExtensionHomePage(),
    );
  }
}

class ExtensionHomePage extends StatelessWidget {
  const ExtensionHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appwrite auth kit devtools extension')),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [Text('Welcome'), Expanded(child: DebugDataWidget())],
          )),
    );
  }
}

class DebugDataWidget extends StatefulWidget {
  const DebugDataWidget({super.key});

  @override
  State<DebugDataWidget> createState() => _DebugDataWidgetState();
}

class _DebugDataWidgetState extends State<DebugDataWidget> {
  String data = '';
  String user = '';
  List<String> events = [];
  Future<void> _updateData() async {
    try {
      final response = await serviceManager
          .callServiceExtensionOnMainIsolate('ext.appwrite_auth_kit.getData');
      setState(() {
        data = response.json?.toString() ?? '';
      });
    } catch (e) {
      debugPrint('error fetching data ${e.toString()}');
      setState(() {
        data = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    serviceManager.service!.onExtensionEvent.where((e) {
      return e.extensionKind == 'appwrite_auth_kit:event';
    }).listen((event) {
      setState(() {
        if (event.extensionData?.data != null) {
          events.add(event.extensionData!.data.toString());
        }
      });
    });
    unawaited(_updateData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _updateData, child: Text('Refresh data')),
        Text(data),
        const SizedBox(height: 20.0),
        RoundedOutlinedBorder(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AreaPaneHeader(
              title: Text('Events'),
            ),
            ListView(shrinkWrap: true, children: [
              ...events.map((e) => Text(e)),
            ]),
          ],
        ))
      ],
    );
  }
}
