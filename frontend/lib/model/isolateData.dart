import 'dart:isolate';

import 'package:flutter/services.dart';

class IsolateData {
  final RootIsolateToken token;
  final bool isLoadMore;
  final SendPort answerPort;

  IsolateData({
    this.isLoadMore = false,
    required this.token,
    required this.answerPort,
  });
}
