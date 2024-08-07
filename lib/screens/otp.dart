import 'package:umonda/custom/btn.dart';
import 'package:umonda/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umonda/custom/input_decorations.dart';
import 'package:umonda/screens/login.dart';
import 'package:umonda/repositories/auth_repository.dart';
import 'package:umonda/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:umonda/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class Otp extends StatefulWidget {
  Otp({Key key, this.verify_by = "email",this.user_id}) : super(key: key);
  final String verify_by;
  final int user_id;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onTapResend() async {
    var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(widget.user_id,widget.verify_by);

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message, gravity: Toast.center, duration: Toast.lengthLong);

    }

  }

  onPressConfirm() async {

    var code = _verificationCodeController.text.toString();

    if(code == ""){
      ToastComponent.showDialog(AppLocalizations.of(context).enter_verification_code, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var confirmCodeResponse = await AuthRepository()
        .getConfirmCodeResponse(widget.user_id,code);

    if (confirmCodeResponse.result == false) {
      ToastComponent.showDialog(confirmCodeResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(confirmCodeResponse.message, gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));

    }
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: _screen_width * (3 / 4),
              child: Image.asset(
                  "assets/splash_login_registration_background_image.png"),
            ),


            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Icon(Icons.keyboard_backspace_rounded,color: Colors.red,),

                  // Row(children: [
                  //   Icon(Icons.keyboard_backspace_rounded,color: Colors.red,),
                  // ],),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                  //   child: Container(
                  //     width: 75,
                  //     height: 75,
                  //     child:
                  //         Image.asset('assets/umondalogo.png'),
                  //   ),
                  // ),
                  Padding(
                    padding:  EdgeInsets.only(left: 16,right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      InkWell(
                          onTap:(){
                            Navigator.pop(context);
                         },
                          child: Icon(Icons.keyboard_backspace_rounded,color: Colors.black,)),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                        child: Container(
                          width: 75,
                          height: 75,
                          child:
                          Image.asset('assets/umondalogo.png'),
                        ),
                      ),
                        //Icon(Icons.keyboard_backspace_rounded,color: Colors.red,),
                       Text("       "),

                      ],),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "${AppLocalizations.of(context).verify_your} " +
                          (_verify_by == "email"
                              ? AppLocalizations.of(context).email_account_ucf
                              : AppLocalizations.of(context).phone_number_ucf),
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                        width: _screen_width * (3 / 4),
                        child: _verify_by == "email"
                            ? Text(
                            AppLocalizations.of(context).enter_the_verification_code_that_sent_to_your_email_recently,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))
                            : Text(
                            AppLocalizations.of(context).enter_the_verification_code_that_sent_to_your_phone_recently,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))),
                  ),

                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: TextField(
                                  controller: _verificationCodeController,
                                  autofocus: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "A X B 4 J H"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: Btn.basic(
                              minWidth: MediaQuery.of(context).size.width,
                              color: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Text(
                                AppLocalizations.of(context).confirm_ucf,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                               onPressConfirm();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 80),
                  //   child: InkWell(
                  //     onTap: (){
                  //       onTapResend();
                  //     },
                  //     child: Text(AppLocalizations.of(context).resend_code_ucf,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             color: Colors.black,
                  //             decoration: TextDecoration.underline,
                  //             fontSize: 13)),
                  //   ),
                  // ),
                ],
              )),
            ),
           // Icon(Icons.keyboard_backspace_rounded,color: Colors.red,),

          ],
        ),
      ),
    );
  }
}
