
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app_config.dart';
import '../data_model/check_response_model.dart';
import '../data_model/refund_request_response.dart';
import '../data_model/refund_request_send_response.dart';
import '../helpers/response_check.dart';
import '../helpers/shared_value_helper.dart';


class RefundRequestRepository {

  Future<dynamic> getRefundRequestListResponse({@required page = 1}) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/refund-request/get-list");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return refundRequestResponseFromJson(response.body);
  }

  Future<dynamic> getRefundRequestSendResponse({@required int id,@required String reason}
      ) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "reason": "${reason}",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/refund-request/send");
    final response =
    await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,
        },
        body: post_body);
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return refundRequestSendResponseFromJson(response.body);
  }

}