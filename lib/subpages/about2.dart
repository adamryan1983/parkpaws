import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import '../constants/apikeys.dart';
import '../models/singletons_data.dart';
import '../widgets/drawer.dart';
import '../models/styles.dart';

class AboutPage2 extends StatelessWidget {
  static const String routeName = '/about2';

  const AboutPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("About The App"),
        ),
        body: const Info());
  }
}

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InfoState();
}

class InfoState extends State<Info> {
  static var isSupporter = false;
  bool _isLoading = false;

  void setSupport() async {
    setState(() {
      _isLoading = true;
    });
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null && 
        customerInfo.entitlements.all[entitlementID]!.isActive == true)
    {
      isSupporter = true;
      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();

      } on PlatformException catch (e) {
       
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Uh oh, something went wrong!"),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK", style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
      }
      
      setState(() {
        _isLoading = false;
      });
      
      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: kColorBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings!.current!,
              );
            });
          },
        );
      }
    }
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }
  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setDebugLogsEnabled(true);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    await Purchases.configure(configuration);

    appData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      (customerInfo.entitlements.all[entitlementID] != null &&
              customerInfo.entitlements.all[entitlementID]!.isActive)
          ? appData.entitlementIsActive = true
          : appData.entitlementIsActive = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const CircularProgressIndicator() : Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Park Paws is a mobile app for locating dogs in the park.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          ElevatedButton(
            onPressed: () {
              setSupport();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                "Support The Creator",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
          ),
          const Text(
            'Creator: Adam Ryan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
              isSupporter ? "You are a supporter!" : "You are not a supporter.")
        ],
      ),
    );
  }
}
