import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {

  static const _apiKey = '';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    // ignore: deprecated_member_use
    await Purchases.setup(_apiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
  final offerings = await Purchases.getOfferings();
  final current = offerings.current;
  
  return current == null ? [] : [current];
} on PlatformException catch (e) {
  debugPrint('Error: $e');
  return [];
}
  }
}