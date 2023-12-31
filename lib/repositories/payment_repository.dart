
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../app_config.dart';
import '../custom/toast_component.dart';
import '../data_model/bkash_begin_response.dart';
import '../data_model/bkash_payment_process_response.dart';
import '../data_model/check_response_model.dart';
import '../data_model/flutterwave_url_response.dart';
import '../data_model/iyzico_payment_success_response.dart';
import '../data_model/nagad_begin_response.dart';
import '../data_model/nagad_payment_process_response.dart';
import '../data_model/order_create_response.dart';
import '../data_model/payment_type_response.dart';
import '../data_model/paypal_url_response.dart';
import '../data_model/paystack_payment_success_response.dart';
import '../data_model/razorpay_payment_success_response.dart';
import '../data_model/sslcommerz_begin_response.dart';
import '../helpers/response_check.dart';
import '../helpers/shared_value_helper.dart';
import '../presenter/home_presenter.dart';
import '../screens/main.dart';
import '../screens/order_list.dart';
import 'package:get/get.dart';



class PaymentRepository {
  Future<dynamic> getPaymentResponseList(
      {mode = "", list = "both"}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/payment-types?mode=${mode}&list=${list}");

    print("getPaymentResponseList url " + url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return paymentTypeResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponse(
      @required payment_method) async {
    var post_body = jsonEncode({"payment_type": "${payment_method}","user_id":user_id.$});


    //  "owner_id":176,
    //     "user_id":198,
    //     "payment_type": "stripe"
    Uri url = Uri.parse("${AppConfig.BASE_URL}/order/store");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);
    print("order details 1 ${response.body}");
    print("pay cod ${response.body}");

    if(!checkResult)
      return responseCheckModelFromJson(response.body);
    print("order details 2 ${response.body}");
    return orderCreateResponseFromJson(response.body);

  }

  Future<PaypalUrlResponse> getPaypalUrlResponse(@required String payment_type,
      @required int combined_order_id, @required var package_id, @required double amount) async {
    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/paypal/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id",
    );
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    //print(response.body.toString());
    return paypalUrlResponseFromJson(response.body);
  }

  Future<FlutterwaveUrlResponse> getFlutterwaveUrlResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/flutterwave/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}");
       // "${AppConfig.BASE_URL}/flutterwave/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    print(url);
    print("payment url ${response.body.toString()}");
    return flutterwaveUrlResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromWallet(
      @required payment_method, @required double amount) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/payments/pay/wallet");

    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
      "amount": "${amount}"
    });

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromCod(
      @required payment_method,
      ) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/payments/pay/cod");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
      },
      body: post_body,
    );

    // Check the HTTP status code
    if (response.statusCode == 200) {
      print('Successfully submitted! govind');

     // ToastComponent.showDialog("Remove to wish list",);
      // Navigate to another screen using Get.to
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return OrderList(from_checkout: true);
      // }));

      //Provider.of<HomePresenter>(context,listen: false).dispose();


      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      //   return Main();
      // }),(newRoute)=>false);

      //Get.to(Main());
     // Get.to(OrderList(from_checkout: true));

    } else {
      print('Error submitting: ${response.statusCode}');
    }

    // Continue with the rest of your code
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }


  Future<dynamic> getOrderCreateResponseFromManualPayment(
      @required payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/payments/pay/manual");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<RazorpayPaymentSuccessResponse> getRazorpayPaymentSuccessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    //print(post_body.toString());

    Uri url = Uri.parse("${AppConfig.BASE_URL}/razorpay/success");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    //print(response.body.toString());
    return razorpayPaymentSuccessResponseFromJson(response.body);
  }

  Future<PaystackPaymentSuccessResponse> getPaystackPaymentSuccessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/paystack/success");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    //print(response.body.toString());
    return paystackPaymentSuccessResponseFromJson(response.body);
  }

  Future<IyzicoPaymentSuccessResponse> getIyzicoPaymentSuccessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/paystack/success");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    //print(response.body.toString());
    return iyzicoPaymentSuccessResponseFromJson(response.body);
  }

  Future<BkashBeginResponse> getBkashBeginResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/bkash/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=${package_id}");

    print(url.toString());
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );

    print(response.body.toString());
    return bkashBeginResponseFromJson(response.body);
  }

  Future<BkashPaymentProcessResponse> getBkashPaymentProcessResponse(
      {
    @required payment_type,
    @required double amount,
    @required int combined_order_id,
    @required String payment_id,
    @required String token,
    @required String package_id,
  }) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "package_id": "${package_id}",
      "amount": "${amount}",
      "payment_id": "${payment_id}",
      "token": "${token}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/bkash/api/success");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: post_body);

    //print(response.body.toString());
    return bkashPaymentProcessResponseFromJson(response.body);
  }

  Future<SslcommerzBeginResponse> getSslcommerzBeginResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    print(response.body.toString());
    return sslcommerzBeginResponseFromJson(response.body);
  }

  Future<NagadBeginResponse> getNagadBeginResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/nagad/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    print(response.body.toString());
    return nagadBeginResponseFromJson(response.body);
  }

  Future<NagadPaymentProcessResponse> getNagadPaymentProcessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/nagad/process");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: post_body);

    //print(response.body.toString());
    return nagadPaymentProcessResponseFromJson(response.body);
  }
}
