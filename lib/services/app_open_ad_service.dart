// // ignore_for_file: unused_field

// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:get/get.dart';

// class AppOpenAdService extends GetxService {
//   AppOpenAd? _appOpenAd;
//   DateTime? _appOpenAdLoadTime;
//   bool _isShowingAd = false;
//   bool _isLoading = false;

//   // Test Ad Unit ID - This is Google's official test ID
//   static const String _testAppOpenAdUnitId =
//       'ca-app-pub-3940256099942544/9257395921';

//   Future<AppOpenAdService> init() async {
//     print('✅ AppOpenAdService initialized');
//     return this;
//   }

//   // Call this before showing the ad
//   Future<void> loadAndShowAd() async {
//     if (_isShowingAd) {
//       print('Already showing an ad');
//       return;
//     }

//     if (_isLoading) {
//       print('Already loading an ad');
//       return;
//     }

//     _isLoading = true;
//     print('🔄 Loading App Open Ad...');

//     AppOpenAd.load(
//       adUnitId: _testAppOpenAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           _appOpenAd = ad;
//           _appOpenAdLoadTime = DateTime.now();
//           _isLoading = false;
//           print('✅ App Open Ad loaded successfully');

//           // Show the ad immediately after loading
//           _showAd();
//         },
//         onAdFailedToLoad: (error) {
//           print('❌ App Open Ad failed to load: ${error.message}');
//           _appOpenAd = null;
//           _appOpenAdLoadTime = null;
//           _isLoading = false;
//         },
//       ),
//     );
//   }

//   Future<void> _showAd() async {
//     if (_appOpenAd == null) {
//       print('No ad available to show');
//       return;
//     }

//     _isShowingAd = true;

//     _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (ad) {
//         print('✅ App Open Ad showed');
//       },
//       onAdDismissedFullScreenContent: (ad) {
//         _isShowingAd = false;
//         ad.dispose();
//         _appOpenAd = null;
//         print('✅ App Open Ad dismissed');
//       },
//       onAdFailedToShowFullScreenContent: (ad, error) {
//         _isShowingAd = false;
//         ad.dispose();
//         _appOpenAd = null;
//         print('❌ App Open Ad failed to show: ${error.message}');
//       },
//     );

//     await _appOpenAd!.show();
//   }
// }
// ignore_for_file: unused_field

import 'package:get/get.dart';

class AppOpenAdService extends GetxService {
  Future<AppOpenAdService> init() async {
    print('✅ AppOpenAdService initialized');
    return this;
  }

  // Empty method - ads disabled
  Future<void> loadAndShowAd() async {
    print('ℹ️ Ads are disabled - App Open Ad not shown');
    return;
  }
}