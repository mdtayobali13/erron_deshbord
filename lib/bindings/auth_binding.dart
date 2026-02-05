import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Initial binding that sets up AuthController
/// This ensures AuthController is available throughout the app
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthController as a permanent singleton
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}

/// Binding for all controllers (use in main.dart)
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Auth controller - permanent throughout app lifecycle
    Get.put<AuthController>(AuthController(), permanent: true);

    // Add other global controllers here if needed
    // Get.lazyPut(() => SomeOtherController());
  }
}
