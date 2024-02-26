import 'dart:convert';

import 'package:flutter/material.dart';

class Authorization {
  static String? username;
  static String? password;
}

Image imageFromBase64String(String base64image) {
  return Image.memory(base64Decode(base64image));
}
