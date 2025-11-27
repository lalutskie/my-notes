import 'dart:async';

import 'package:flutter/foundation.dart';

class GoRouterStream extends ChangeNotifier {
  GoRouterStream(Stream<dynamic> stream) {
    notifyOnStream(stream);
  }
  
  void notifyOnStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

   @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}