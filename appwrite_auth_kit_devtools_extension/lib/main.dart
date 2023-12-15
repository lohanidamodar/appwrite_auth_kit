import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppwriteAuthKitDevToolsExtension());
}

class AppwriteAuthKitDevToolsExtension extends StatelessWidget {
  const AppwriteAuthKitDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: Placeholder(),
    );
  }
}