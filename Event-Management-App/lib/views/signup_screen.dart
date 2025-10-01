// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/size_config.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static const String routeName = '/signupScreen';

  AuthenticateController controller = Get.put(AuthenticateController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  vertical: MarginManager.marginXL,
                  horizontal: MarginManager.marginXL),
              child: Form(
                key: controller.signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/signup.svg',
                        height: SizeManager.svgImageSize,
                        width: SizeManager.svgImageSize,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    const Txt(
                      textAlign: TextAlign.start,
                      text: StringsManager.registerTxt,
                      fontWeight: FontWeightManager.bold,
                      fontSize: FontSize.headerFontSize,
                      fontFamily: FontsManager.fontFamilyPoppins,
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.nameController,
                      labelText: StringsManager.nameTxt,
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kUserNameNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.phoneController,
                      labelText: StringsManager.phoneTxt,
                      autofocus: false,
                      hintText: StringsManager.phoneHintTxt,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kPhoneNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.emailController,
                      labelText: StringsManager.emailTxt,
                      autofocus: false,
                      hintText: StringsManager.emailHintTxt,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kEmailNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    Obx(
                      () => CustomTextFormField(
                        controller: controller.passwordController,
                        autofocus: false,
                        labelText: StringsManager.passwordTxt,
                        obscureText: controller.isObscure.value,
                        prefixIconData: Icons.vpn_key_rounded,
                        suffixIconData: controller.isObscure.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        onSuffixTap: controller.toggleVisibility,
                        textInputAction: TextInputAction.done,
                        onFieldSubmit: (_) async {
                          final isValid = await controller.signUpUser(
                            email: controller.emailController.text,
                            name: controller.nameController.text,
                            password: controller.passwordController.text,
                            phone: controller.phoneController.text,
                          );
                          await controller.removeToken();
                          if (isValid) {
                            firstTimeLoginDialog(controller);
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ErrorManager.kPasswordNullError;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Obx(
                      () => CustomButton(
                        color: ColorManager.blackColor,
                        hasInfiniteWidth: true,
                        loadingWidget: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  backgroundColor:
                                      ColorManager.scaffoldBackgroundColor,
                                ),
                              )
                            : null,
                        onPressed: () async {
                          final isValid = await controller.signUpUser(
                            email: controller.emailController.text,
                            name: controller.nameController.text,
                            password: controller.passwordController.text,
                            phone: controller.phoneController.text,
                          );
                          await controller.removeToken();
                          if (isValid) {
                            firstTimeLoginDialog(controller);
                          }
                        },
                        text: StringsManager.registerTxt,
                        textColor: ColorManager.backgroundColor,
                        buttonType: ButtonType.loading,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          StringsManager.alreadyHaveAccTxt,
                          style: TextStyle(
                              fontSize: FontSize.textFontSize,
                              color: ColorManager.primaryColor),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAllNamed(LoginScreen.routeName);
                          },
                          child: const Text(
                            StringsManager.loginTxt,
                            style: TextStyle(
                              fontSize: FontSize.textFontSize,
                              color: ColorManager.blackColor,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> firstTimeLoginDialog(AuthenticateController controller) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          title: const Txt(
            text: StringsManager.firstTimeLoginTitle,
            color: ColorManager.blackColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.textFontSize,
            fontWeight: FontWeightManager.bold,
          ),
          content: const Txt(
            text: StringsManager.firstTimeLogin,
            color: ColorManager.blackColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.subTitleFontSize,
            fontWeight: FontWeightManager.regular,
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.logout();
                controller.clearfields();
                Get.offAll(LoginScreen());
              },
              child: const Txt(
                text: StringsManager.loginTxt,
                color: ColorManager.blackColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.textFontSize,
                fontWeight: FontWeightManager.bold,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
