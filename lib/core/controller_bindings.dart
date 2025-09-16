
import 'package:app/core/navigation_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';



class ControllerBinding extends Bindings {

  @override
  void dependencies(){

    Get.put(NavigationController());
  }
}