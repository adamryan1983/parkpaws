import 'package:flutter/foundation.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:glassfy_flutter/models.dart';

class PurchaseApi {

  static const _apiKey = '519129fb4d89482d88e1a4de5cbf90e3';

  static Future<void> init() async {
    await Glassfy.initialize(_apiKey, watcherMode: false);
  }

  static Future<List<GlassfyOffering>> fetchOffers() async {
    try {
      final offerings = await Glassfy.offerings();
      return offerings.all ?? [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  } 

  static Future<GlassfyTransaction?> purchaseSku(GlassfySku sku) async {
    try {
      return await Glassfy.purchaseSku(sku);
    } catch (e) {
      return null;
    }
  }
}