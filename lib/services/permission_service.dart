import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  Future<PermissionService> init() async {
    await requestAllPermissions();
    return this;
  }
  
  Future<void> requestAllPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.notification,
    ];
    
    await permissions.request();
  }
  
  Future<bool> hasAllPermissions() async {
    final recordStatus = await Permission.microphone.status;
    final notificationStatus = await Permission.notification.status;
    
    return recordStatus.isGranted && notificationStatus.isGranted;
  }
}