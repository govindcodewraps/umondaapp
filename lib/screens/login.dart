import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:umonda/Social_Login/authservice.dart';
import 'package:umonda/app_config.dart';
import 'package:umonda/custom/btn.dart';
import 'package:umonda/my_theme.dart';
import 'package:umonda/other_config.dart';
import 'package:umonda/presenter/home_presenter.dart';
import 'package:umonda/social_config.dart';
import 'package:umonda/ui_elements/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umonda/custom/input_decorations.dart';
import 'package:umonda/custom/intl_phone_input.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:umonda/screens/registration.dart';
import 'package:umonda/screens/main.dart';
import 'package:umonda/screens/password_forget.dart';
import 'package:umonda/custom/toast_component.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:umonda/repositories/auth_repository.dart';
import 'package:umonda/helpers/auth_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:umonda/helpers/shared_value_helper.dart';
import 'package:umonda/repositories/profile_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io'; //show Platform;

import '../Social_Login/applelogin.dart';
import '../Social_Login/googleloginn.dart';
import '../custom/device_info.dart';
import '../repositories/address_repository.dart';
import 'common_webview_screen.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  //String FCM="cVosQPN2TqGQAafxIfXHDa:APA91bHQkGsOi_Td6Err-8Dlhi0jgGskr7ycI8Q9cbkR5noh_mimvn84YcfgsNHav-bKE0MJCwwXF9m7KgJaWn6wvn9MFA565_plqUgSTQng468kvUtqA9BcIyHjo-Cwp0X4APwQMjBf";

  // PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  var countries_code = <String>[];
  bool _isAgree = false;
  String _phone = "";

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    fetch_country();
  }

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries.forEach((c) => countries_code.add(c.code));
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).enter_email,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).enter_password,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);


      // push notification starts

      // if (OtherConfig.USE_PUSH_NOTIFICATION) {
      //   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
      //
      //   await _fcm.requestPermission(
      //     alert: true,
      //     announcement: false,
      //     badge: true,
      //     carPlay: false,
      //     criticalAlert: false,
      //     provisional: false,
      //     sound: true,
      //   );
      //
      //   String fcmToken = await _fcm.getToken();
      //   print("mobile token${fcmToken}");
      //   if (fcmToken != null) {
      //     print("--fcm token--");
      //     print(fcmToken);
      //    // print(FCM);
      //     if (is_logged_in.$ == true) {
      //       print("device token api>>>");
      //       // update device token
      //       var deviceTokenUpdateResponse = await ProfileRepository()
      //           .getDeviceTokenUpdateResponse(fcmToken);
      //       print("device token api>>>");
      //     }
      //   }
      // }

      //push norification ends

      Provider.of<HomePresenter>(context,listen: false).dispose();


      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
        return Main();
      }),(newRoute)=>false);
    }
  }

  //onPressedFacebookLogin() async {
  //   final facebookLogin =
  //       await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);
  //
  //   if (facebookLogin.status == LoginStatus.success) {
  //     // get the user data
  //     // by default we get the userId, email,name and picture
  //     final userData = await FacebookAuth.instance.getUserData();
  //     var loginResponse = await AuthRepository().getSocialLoginResponse(
  //         "facebook",
  //         userData['name'].toString(),
  //         userData['email'].toString(),
  //         userData['id'].toString(),
  //         access_token: facebookLogin.accessToken.token);
  //     print("..........................${loginResponse.toString()}");
  //     if (loginResponse.result == false) {
  //       ToastComponent.showDialog(loginResponse.message,
  //           gravity: Toast.center, duration: Toast.lengthLong);
  //     } else {
  //       ToastComponent.showDialog(loginResponse.message,
  //           gravity: Toast.center, duration: Toast.lengthLong);
  //
  //       AuthHelper().setUserData(loginResponse);
  //       Navigator.push(context, MaterialPageRoute(builder: (context) {
  //         return Main();
  //       }));
  //       FacebookAuth.instance.logOut();
  //     }
  //     // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
  //
  //   } else {
  //     print("....Facebook auth Failed.........");
  //     print(facebookLogin.status);
  //     print(facebookLogin.message);
  //   }
  // }

  onPressedGoogleLogin() async {


    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      print("GR email ${googleUser.email}");
      print(googleUser.toString());

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser.authentication;
      String accessToken = googleSignInAuthentication.accessToken;

      print("GR accessToken $accessToken");
      print("GR displayName ${googleUser.displayName}");
      print("GR email ${googleUser.email}");
      print("GR googleUser.id ${googleUser.id}");

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "google", googleUser.displayName, googleUser.email, googleUser.id,
          access_token: accessToken);

      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message,
            gravity: Toast.center, duration: Toast.lengthLong);
        print("GR email ${googleUser.email}");
      } else {
        print("GR email ${googleUser.email}");

        ToastComponent.showDialog(loginResponse.message,
            gravity: Toast.center, duration: Toast.lengthLong);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
      GoogleSignIn().disconnect();
    } on Exception catch (e) {
      print("error is ....... $e");

      // TODO
    }
  }

  onPressedTwitterLogin() async {
    try {
      final twitterLogin = new TwitterLogin(
          apiKey: SocialConfig().twitter_consumer_key,
          apiSecretKey: SocialConfig().twitter_consumer_secret,
          redirectURI: 'activeecommerceflutterapp://');
      // Trigger the sign-in flow

      final authResult = await twitterLogin.login();

      print("authResult");

      // print(json.encode(authResult));

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "twitter",
          authResult.user.name,
          authResult.user.email,
          authResult.user.id.toString(),
          access_token: authResult.authToken,
          secret_token: authResult.authTokenSecret);

      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message,
            gravity: Toast.center, duration: Toast.lengthLong);
      } else {
        ToastComponent.showDialog(loginResponse.message,
            gravity: Toast.center, duration: Toast.lengthLong);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
    } on Exception catch (e) {
      print("error is ....... $e");
      // TODO
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );
  //
  //     var loginResponse = await AuthRepository().getSocialLoginResponse(
  //         "apple",
  //         appleCredential.givenName,
  //         appleCredential.email,
  //         appleCredential.userIdentifier,
  //         access_token: appleCredential.identityToken);
  //
  //     if (loginResponse.result == false) {
  //       ToastComponent.showDialog(loginResponse.message,
  //           gravity: Toast.center, duration: Toast.lengthLong);
  //     } else {
  //       ToastComponent.showDialog(loginResponse.message,
  //           gravity: Toast.center, duration: Toast.lengthLong);
  //       AuthHelper().setUserData(loginResponse);
  //       Navigator.push(context, MaterialPageRoute(builder: (context) {
  //         return Main();
  //       }));
  //     }
  //   } on Exception catch (e) {
  //     print("APPLEAPLEAPLE");
  //     print(e);
  //     print("APPLEAPLEAPLE");
  //     // TODO
  //   }
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   // final oauthCredential = OAuthProvider("apple.com").credential(
  //   //   idToken: appleCredential.identityToken,
  //   //   rawNonce: rawNonce,
  //   // );
  //   //print(oauthCredential.accessToken);
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   //return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }



  signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);


    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    var loginResponse = await AuthRepository().getSocialLoginResponse(
        "apple",
        appleCredential.givenName,
        appleCredential.email,
        appleCredential.userIdentifier,
        access_token: appleCredential.identityToken);

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(loginResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }


    // Request credential for the currently signed in Apple account.
    // try {
    //   final appleCredential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //     nonce: nonce,
    //   );
    //
    //   var loginResponse = await AuthRepository().getSocialLoginResponse(
    //       "apple",
    //       appleCredential.givenName,
    //       appleCredential.email,
    //       appleCredential.userIdentifier,
    //       access_token: appleCredential.identityToken);
    //
    //   if (loginResponse.result == false) {
    //     ToastComponent.showDialog(loginResponse.message,
    //         gravity: Toast.center, duration: Toast.lengthLong);
    //   } else {
    //     ToastComponent.showDialog(loginResponse.message,
    //         gravity: Toast.center, duration: Toast.lengthLong);
    //     AuthHelper().setUserData(loginResponse);
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return Main();
    //     }));
    //   }
    // } on Exception catch (e) {
    //   print("Apple errorrrrrr");
    //   print(e);
    //   print("Apple errorrrrrr");
    //   // TODO
    // }

    // Create an `OAuthCredential` from the credential returned by Apple.
    // final oauthCredential = OAuthProvider("apple.com").credential(
    //   idToken: appleCredential.identityToken,
    //   rawNonce: rawNonce,
    // );
    //print(oauthCredential.accessToken);

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    //return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }




  ////

  @override
  Widget build(BuildContext context) {


    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        "${AppLocalizations.of(context).login_to} " +
            AppConfig.app_name,
        buildBody(context, _screen_width));
  }

  Widget buildBody(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  _login_by == "email"
                      ? AppLocalizations.of(context).email_ucf
                      : AppLocalizations.of(context).login_screen_phone,
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              if (_login_by == "email")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 36,
                        child: TextField(
                          controller: _emailController,
                          autofocus: false,
                          decoration: InputDecorations.buildInputDecoration_1(
                              hint_text: "johndoe@example.com"),
                        ),
                      ),
                      otp_addon_installed.$
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _login_by = "phone";
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .or_login_with_a_phone,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          : Container()
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Container(
                      //   height: 36,
                      //   child: CustomInternationalPhoneNumberInput(
                      //     countries: countries_code,
                      //     onInputChanged: (PhoneNumber number) {
                      //       print(number.phoneNumber);
                      //       setState(() {
                      //         _phone = number.phoneNumber;
                      //       });
                      //     },
                      //     onInputValidated: (bool value) {
                      //       print(value);
                      //     },
                      //     selectorConfig: SelectorConfig(
                      //       selectorType: PhoneInputSelectorType.DIALOG,
                      //     ),
                      //     ignoreBlank: false,
                      //     autoValidateMode: AutovalidateMode.disabled,
                      //     selectorTextStyle:
                      //         TextStyle(color: MyTheme.font_grey),
                      //     textStyle: TextStyle(color: MyTheme.font_grey),
                      //     initialValue: PhoneNumber(
                      //         isoCode: countries_code[0].toString()),
                      //     textFieldController: _phoneNumberController,
                      //     formatInput: true,
                      //     keyboardType: TextInputType.numberWithOptions(
                      //         signed: true, decimal: true),
                      //     inputDecoration:
                      //         InputDecorations.buildInputDecoration_phone(
                      //             hint_text: "01XXX XXX XXX"),
                      //     onSaved: (PhoneNumber number) {
                      //       print('On Saved: $number');
                      //     },
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _login_by = "email";
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .or_login_with_an_email,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  AppLocalizations.of(context).password_ucf,
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   height: 36,
                    //   child: TextField(
                    //     controller: _passwordController,
                    //     autofocus: false,
                    //     obscureText: true,
                    //     enableSuggestions: false,
                    //     autocorrect: false,
                    //     decoration: InputDecorations.buildInputDecoration_1(
                    //         suffixIcon: GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               _obscureText = !_obscureText;
                    //             });
                    //           },
                    //           child: _obscureText
                    //               ? Icon(Icons.visibility
                    //             // Feather.eye_off, // Use Feather for Flutter icons
                    //           )
                    //               : Icon(
                    //               Icons.visibility_off
                    //           ),
                    //         ),
                    //         hint_text: "• • • • • • • •"
                    //     ),
                    //   ),
                    // ),


                    Container(
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(5, 12, 0, 0),
                      child:
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration:
                        InputDecoration(
                            hintText: "• • • • • • • •",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: _obscureText
                                  ? Icon(Icons.visibility,color: MyTheme.accent_color
                                // Feather.eye_off, // Use Feather for Flutter icons
                              )
                                  : Icon(
                                  Icons.visibility_off,color: Colors.grey,
                              ),
                            ),
                            filled: true,
                            fillColor: MyTheme.white,
                            hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.noColor,
                                  width: 0.2),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyTheme.accent_color,
                                  width: 0.5),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0)
                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PasswordForget();
                        }));
                      },
                      child: Text(
                        AppLocalizations.of(context)
                            .login_screen_forgot_password,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          value: _isAgree,
                          onChanged: (newValue) {
                            _isAgree = newValue;
                            setState(() {});
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: Container(
                        width: DeviceInfo(context).width - 130,
                        child: RichText(
                            maxLines: 2,
                            text: TextSpan(
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: "I agree to the",
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonWebviewScreen(
                                                      page_name:
                                                      "Terms Conditions",
                                                      url:
                                                      //"https://umonm.com/",
                                                      "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                                    )));
                                      },
                                    style:
                                    TextStyle(color: MyTheme.accent_color),
                                    text: " Terms Conditions",
                                  ),


                                  TextSpan(
                                    text: " &",
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonWebviewScreen(
                                                      page_name:
                                                      "Privacy Policy",
                                                      url:
                                                      "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                                    )));
                                      },
                                    text: " Privacy Policy",
                                    style:
                                    TextStyle(color: MyTheme.accent_color),
                                  )
                                ])),
                      ),
                    ),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 45,
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(6.0))),
                    child: Text(
                      AppLocalizations.of(context)
                          .login_screen_log_in,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: _isAgree
                        ? () {
                      onPressedLogin();
                    }
                        : null,
                  ),
                ),
              ),



              // Padding(
              //   padding: const EdgeInsets.only(top: 30.0),
              //   child: Container(
              //     height: 45,
              //     decoration: BoxDecoration(
              //         border:
              //             Border.all(color: MyTheme.textfield_grey, width: 1),
              //         borderRadius:
              //             const BorderRadius.all(Radius.circular(12.0))),
              //     child: Btn.minWidthFixHeight(
              //       minWidth: MediaQuery.of(context).size.width,
              //       height: 50,
              //       color: MyTheme.accent_color,
              //       shape: RoundedRectangleBorder(
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(6.0))),
              //       child: Text(
              //         AppLocalizations.of(context).login_screen_log_in,
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600),
              //       ),
              //       onPressed: () {
              //         onPressedLogin();
              //       },
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context)
                      .login_screen_or_create_new_account,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
                )),
              ),
              Container(
                height: 45,
                child: Btn.minWidthFixHeight(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  color: MyTheme.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    AppLocalizations.of(context).login_screen_sign_up,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Registration();
                    }));
                  },
                ),
              ),
              // if(Platform.isIOS)
              // Padding(
              //   padding: const EdgeInsets.only(top: 20.0),
              //   child: SignInWithAppleButton(
              //     onPressed: () async {
              //      // signInWithApple();
              //
              //
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>loginapple()));
              //
              //     }
              //   ),
              // ),


              // Visibility(
              //   visible: allow_google_login.$ || allow_facebook_login.$,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 20.0),
              //     child: Center(
              //         child: Text(
              //       AppLocalizations.of(context).login_screen_login_with,
              //       style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
              //     )),
              //   ),
              // ),


    // Padding(
    //             padding: const EdgeInsets.only(top: 15.0),
    //             child: Center(
    //               child: Container(
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //
    //
    //                     Visibility(
    //                       //visible: allow_google_login.$,
    //                       child: InkWell(
    //                         onTap: () {
    //                           print("googlelogin");
    //                           // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //                           //   return HomePagegogle();
    //                           // }));
    //
    //                           // AuthService().signInWithGoogle();
    //                            onPressedGoogleLogin();
    //
    //                         },
    //                         child: Container(
    //                           width: 28,
    //                           child: Image.asset("assets/google_logo.png"),
    //                         ),
    //                       ),
    //                     ),
    //
    //
    //
    //
    //
    //           //           Padding(
    //           //             padding: const EdgeInsets.only(left: 15.0),
    //           //             child: Visibility(
    //           //               visible: allow_facebook_login.$,
    //           //               child: InkWell(
    //           //                 onTap: () {
    //           //                   //onPressedFacebookLogin();
    //           //                 },
    //           //                 child: Container(
    //           //                   width: 28,
    //           //                   child: Image.asset("assets/facebook_logo.png"),
    //           //                 ),
    //           //               ),
    //           //             ),
    //           //           ),
    //           //           if (allow_twitter_login.$)
    //           //             Padding(
    //           //               padding: const EdgeInsets.only(left: 15.0),
    //           //               child: InkWell(
    //           //                 onTap: () {
    //           //                   onPressedTwitterLogin();
    //           //                 },
    //           //                 child: Container(
    //           //                   width: 28,
    //           //                   child: Image.asset("assets/twitter_logo.png"),
    //           //                 ),
    //           //               ),
    //           //             ),
    //                    /* if (Platform.isIOS)
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 15.0),
    //                         // visible: true,
    //                         child: A(
    //                           onTap: () async {
    //                             signInWithApple();
    //                           },
    //                           child: Container(
    //                             width: 28,
    //                             child: Image.asset("assets/apple_logo.png"),
    //                           ),
    //                         ),
    //                       ),*/
    //
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),

            ],
          ),
        )
      ],
    );
  }
}
