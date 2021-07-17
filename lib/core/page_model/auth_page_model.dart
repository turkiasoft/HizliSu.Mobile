import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hizli_su/core/main_service.dart';
import 'package:hizli_su/core/services/auth_service.dart';
import 'package:hizli_su/models/auth/user_model.dart';
import 'package:hizli_su/models/auth/user_token.dart';
import 'package:hizli_su/pages/home_page.dart';

import '../routes.dart';


class AuthPageModel extends GetxController {
  final box = GetStorage();
  Rx<User> user = User().obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getAuthUserInfo();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }


  void signIn(String email, String password) async {
    UserToken userToken = await AuthService().signIn(emailAddress: email, password:password );

      //oturum açma başarılı ise token vb bilgileri kaydedelim...
      if(userToken.success) {
        box.write('accessToken', userToken.result.accessToken);
        box.write('encryptedAccessToken', userToken.result.encryptedAccessToken);
        box.write('userId', userToken.result.userId);
        box.write('expireInSeconds', userToken.result.expireInSeconds);
        // Get.snackbar('Oturum Açma Durumu', 'Başarıyla oturum açtınız!',
        //     colorText: Colors.black,
        //     backgroundColor: Colors.green,
        //     snackPosition: SnackPosition.BOTTOM);

        Get.offAllNamed(Routes.mainPage);
      }
  }
  Future<void> getAuthUserInfo() async {
    loading.value = true;
    var userResult = await AuthService().getAuthUserInfo();
    user.value = userResult.result;
    loading.value = false;
  }
  Future<void> updateUser(User user) async {
    loading.value = true;
    await AuthService().updateUser(user);
    // user.value = userResult.result;
    loading.value = false;
  }

}
