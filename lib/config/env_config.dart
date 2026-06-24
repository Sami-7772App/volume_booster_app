import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static bool get _isIos => !kIsWeb && Platform.isIOS;

  static String get privacyPolicyUrl =>
      _isIos ? _iosPrivacyPolicyUrl : _androidPrivacyPolicyUrl;

  static String get termsOfServiceUrl =>
      _isIos ? _iosTermsOfUseUrl : _androidTermsOfServiceUrl;

  static String get moreAppsUrl => _isIos ? _moreAppsIosUrl : _moreAppsUrl;

  static String get _androidPrivacyPolicyUrl =>
      dotenv.env['PRIVACY_POLICY_URL'] ?? '';

  static String get _androidTermsOfServiceUrl =>
      dotenv.env['TERMS_OF_SERVICE_URL'] ?? '';

  static String get _moreAppsUrl => dotenv.env['MORE_APPS_URL'] ?? '';

  static String get _iosPrivacyPolicyUrl =>
      dotenv.env['IOS_PRIVACY_POLICY_URL'] ?? '';

  static String get _iosTermsOfUseUrl =>
      dotenv.env['IOS_TERMS_OF_USE_URL'] ?? '';

  static String get _moreAppsIosUrl => dotenv.env['MORE_APPS_IOS_URL'] ?? '';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
