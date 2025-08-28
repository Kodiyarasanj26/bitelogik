import 'package:bitelogik/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';


class AppLoader extends StatelessWidget {
  final String? message;
  final Color? color;
  const AppLoader({this.message, this.color,super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(
          color: color,
        ),
        if (message != null) 8.height,
        if (message != null) CustomText(text:message!),
      ]),
    );
  }
}
