

import 'package:flutter/cupertino.dart';

extension Sizes on num {
  SizedBox get height => SizedBox(
    height: toDouble(),
  );
  SizedBox get width => SizedBox(
    width: toDouble(),
  );
}