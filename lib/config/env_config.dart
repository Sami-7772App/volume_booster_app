import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get privacyPolicyUrl => dotenv.env['PRIVACY_POLICY_URL'] ?? '';
  static String get termsOfServiceUrl => dotenv.env['TERMS_OF_SERVICE_URL'] ?? '';
  
  static Future<void> load() async {
    await dotenv.load();
  }
}