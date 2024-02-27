import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com";
  String clientId =
      'AdN9NdbMhZFPd_AhKXgnmD3JjcKjRTtbRQ1nIWm1v780mQufiyg7R16N87JIVWgkPbn2otjrpQfGV42B';
  String secret =
      'EMuooGqW3L4Y5z9rhtrMmVpnrifyHYmP0X2zi5L5hN4xLL48djvyDPoGn_gMqRPvAca6ccqsdfoC7gHh';

  /// for obtaining the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for generating the PayPal payment request
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// for carrying out the payment process
  Future<String?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}

class BasicAuthClient extends http.BaseClient {
  final String user;
  final String password;
  final http.Client _inner = http.Client();

  BasicAuthClient(this.user, this.password);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['authorization'] =
        'Basic ' + convert.base64Encode(convert.utf8.encode('$user:$password'));
    return _inner.send(request);
  }
}
