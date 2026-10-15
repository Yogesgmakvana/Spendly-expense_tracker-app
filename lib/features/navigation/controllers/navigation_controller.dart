import 'package:get/get.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    if (index == 2) return; // FAB action handled separately
    currentIndex.value = index;
  }
}
