import 'package:flutter/material.dart';
import 'package:parkpaws/api/purchase_api.dart';
import 'package:parkpaws/services/pay_provider.dart';
import 'package:parkpaws/widgets/paywall.dart';
// import '../constants/apikeys.dart';
// import '../models/singletons_data.dart';
import '../widgets/drawer.dart';
import '../models/styles.dart';
import '../constants/colors.dart';
import '../utils.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';

  const AboutPage({Key? key}) : super(key: key);

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
  const Info({super.key});
  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  
  bool _isLoading = false;

  Future fetchOffers() async {
    setState(() {
      _isLoading = true;
    });
    final offerings = await PurchaseApi.fetchOffers();
    final offer = offerings
        .singleWhere((offering) => offering.offeringId == 'supporter');
    if (!mounted) return;
    Utils.showSheet(
      context,
      (context) => PayWallWidget(
        title: 'Become a Supporter',
        description: 'One time payment to support the creator',
        offer: offer,
        onClickedSku: (sku) async {
          final transaction = await PurchaseApi.purchaseSku(sku);
          debugPrint('Go here now');
          if (!mounted) return;
          debugPrint('Go here now2');

          if (transaction != null) {
            final permissions = transaction.permissions!.all!;
            final permission = permissions.firstWhere(
                (permission) => permission.permissionId == 'supporter');
                debugPrint('Go here now3');

            if (permission.isValid!) {
              final provider = context.read<GlassfyProvider>();
              provider.isSupporter = true;
              debugPrint('User is a supporter');
            }
          }
          debugPrint('exiting');
          Navigator.of(context).pop();
        },
      ),
    );
        setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSupporter = context.watch<GlassfyProvider>().isSupporter;
    return _isLoading
        ? const CircularProgressIndicator()
        : Padding(
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
                const Text(
                  'This app is free to use, but if you would like to support the creator, you can do so below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchOffers();
                    print("test");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ORANGEPOP,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                Text(isSupporter
                    ? "You are a supporter! Thank You"
                    : "You are currently not a supporter."),
                const Text(
                    "If you are a supporter, thank you so much! You are helping to keep this app running."),
                Text(_isLoading.toString())
              ],
            ),
          );
  }
}


// import 'package:flutter/material.dart';
// import 'package:glassfy_flutter/glassfy_flutter.dart';
// import 'package:parkpaws/services/pay_provider.dart';
// import 'package:parkpaws/widgets/paywall.dart';
// import 'package:provider/provider.dart';

// import '../api/purchase_api.dart';
// import '../services/pay_provider.dart';
// import '../utils.dart';
// import '../widgets/paywall.dart';

// class AboutPage extends StatefulWidget {
//   const AboutPage({super.key});

//   @override
//   State<AboutPage> createState() => _AboutPageState();
// }

// class _AboutPageState extends State<AboutPage> {
//   @override
//   Widget build(BuildContext context) {
//     final isPremium = context.watch<GlassfyProvider>().isSupporter;
//     return Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 8),
//           buildEntitlement(isPremium),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: fetchOffers,
//             child: const Text('Plans'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildEntitlement(bool isPremium) => isPremium
//       ? buildEntitlementIcon(
//           text: 'You are on Paid plan',
//           icon: Icons.paid,
//           color: Colors.green,
//         )
//       : buildEntitlementIcon(
//           text: 'You are on Free plan',
//           icon: Icons.lock,
//           color: Colors.red,
//         );

//   Widget buildEntitlementIcon({
//     required String text,
//     required IconData icon,
//     required Color color,
//   }) =>
//       Column(
//         children: [
//           Icon(icon, color: color, size: 100),
//           const SizedBox(height: 8),
//           Text(text),
//         ],
//       );

//   Future fetchOffers() async {
//     final offerings = await PurchaseApi.fetchOffers();
//     final offer = offerings
//         .singleWhere((offering) => offering.offeringId == 'All Courses');
//     if (!mounted) return;
//     Utils.showSheet(
//       context,
//       (context) => PayWallWidget(
//         title: 'Upgrade Your Plan',
//         description: 'Upgrade to a new plan to enjoy more benefits',
//         offer: offer,
//         onClickedSku: (sku) async {
//           final transaction = await PurchaseApi.purchaseSku(sku);
//           if (!mounted) return;

//           if (transaction != null) {
//             final permissions = transaction.permissions!.all!;
//             final permission = permissions.firstWhere(
//                 (permission) => permission.permissionId == 'premium');

//             if (permission.isValid!) {
//               final provider = context.read<GlassfyProvider>();
//               provider.isSupporter = true;
//             }
//           }
//           Navigator.of(context).pop();
//         },
//       ),
//     );
//   }
// }

