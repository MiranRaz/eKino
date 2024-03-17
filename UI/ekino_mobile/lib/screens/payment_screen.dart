import 'dart:convert';
import 'package:ekino_mobile/.env';
import 'package:ekino_mobile/providers/reservation_provider.dart';
import 'package:ekino_mobile/providers/transaction_provider.dart';
import 'package:ekino_mobile/screens/reservations_my_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PaymentScreen {
  Map<String, dynamic>? paymentIntent;

  Future<void> stripeMakePayment(
      String amount,
      String currency,
      Map<String, dynamic>? reservationSaveValue,
      Map<String, dynamic>? transactionSaveValue,
      BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent(amount, currency);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: const BillingDetails(
                      name: 'YOUR NAME',
                      email: 'YOUREMAIL@gmail.com',
                      phone: 'YOUR NUMBER',
                      address: Address(
                          city: 'YOUR CITY',
                          country: 'YOUR COUNTRY',
                          line1: 'YOUR ADDRESS 1',
                          line2: 'YOUR ADDRESS 2',
                          postalCode: 'YOUR PINCODE',
                          state: 'YOUR STATE')),
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'eCinema'))
          .then((value) {});

      displayPaymentSheet(reservationSaveValue, transactionSaveValue, context);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> displayPaymentSheet(
    Map<String, dynamic>? reservationSaveValue,
    Map<String, dynamic>? transactionSaveValue,
    BuildContext context,
  ) async {
    try {
      final _reservationProvider =
          Provider.of<ReservationProvider>(context, listen: false);
      final _transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      final reservation =
          await _reservationProvider.insert(reservationSaveValue);
      transactionSaveValue?['reservationId'] =
          reservation.reservationId.toString();

      // Display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment successfully completed');

      await _transactionProvider.insert(transactionSaveValue);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ReservationsListScreen()),
      );
    } on Exception catch (e) {
      // Handle exceptions
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: $e');
      }
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
