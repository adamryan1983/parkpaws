import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/apikeys.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';

import '../constants/store_config.dart' as sc;

class PurchaseTester extends StatelessWidget {
  static const String routeName = '/purchase';
  const PurchaseTester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RevenueCat Sample',
      home: InitialScreen(),
    );
  }
}

// ignore: public_member_api_docs
class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<InitialScreen> {
  late CustomerInfo _customerInfo;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isIOS || Platform.isMacOS) {
    sc.StoreConfig(
      store: sc.Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    sc.StoreConfig(
      store: sc.Store.googlePlay,
      apiKey: googleApiKey,
    );
  }
    await Purchases.setDebugLogsEnabled(true);
    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(sc.StoreConfig.instance.apiKey);
    await Purchases.configure(configuration);

    await Purchases.enableAdServicesAttributionTokenCollection();

    final customerInfo = await Purchases.getCustomerInfo();

    Purchases.addReadyForPromotedProductPurchaseListener(
        (productID, startPurchase) async {
      print('Received readyForPromotedProductPurchase event for '
          'productID: $productID');

      try {
        final purchaseResult = await startPurchase.call();
        debugPrint('Promoted purchase for productID '
            '${purchaseResult.productIdentifier} completed, or product was'
            'already purchased. customerInfo returned is:'
            ' ${purchaseResult.customerInfo}');
      } on PlatformException catch (e) {
        debugPrint('Error purchasing promoted product: ${e.message}');
      }
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _customerInfo = customerInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_customerInfo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('RevenueCat Sample App')),
        body: const Center(
          child: Text('Loading...'),
        ),
      );
    } else {
      final isPro = _customerInfo.entitlements.active.containsKey('support');
      if (isPro) {
        return const CatsScreen();
      } else {
        return const UpsellScreen();
      }
    }
  }
}

// ignore: public_member_api_docs
class UpsellScreen extends StatefulWidget {
  const UpsellScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpsellScreenState();
}

class _UpsellScreenState extends State<UpsellScreen> {
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      debugPrint('error $e');
    }

    if (!mounted) return;

    setState(() {
      _offerings = offerings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_offerings != null) {
      final offering = _offerings!.current;
      if (offering != null) {
        final monthly = offering.monthly;
        final lifetime = offering.lifetime;

        if (monthly != null && lifetime != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Upsell Screen')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _PurchaseButton(package: monthly),
                  _PurchaseButton(package: lifetime)
                ],
              ),
            ),
          );
        }
      }
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Upsell Screen')),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  final Package package;

  // ignore: public_member_api_docs
  const _PurchaseButton({ Key? key, required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () async {
          try {
            final customerInfo = await Purchases.purchasePackage(package);
            final isPro = customerInfo.entitlements.all['pro_cat']?.isActive;
            if (isPro == true ) {
              const CatsScreen();
            }
          } on PlatformException catch (e) {
            final errorCode = PurchasesErrorHelper.getErrorCode(e);
            if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
              print('User cancelled');
            } else if (errorCode ==
                PurchasesErrorCode.purchaseNotAllowedError) {
              print('User not allowed to purchase');
            } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
              debugPrint('Payment is pending');
            }
          }
          const InitialScreen();
        },
        child: Text('Buy - (${package.storeProduct.priceString})'),
      );
}

// ignore: public_member_api_docs
class CatsScreen extends StatelessWidget {
  const CatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cats Screen')),
        body: const Center(
          child: Text('User is pro'),
        ),
      );
}