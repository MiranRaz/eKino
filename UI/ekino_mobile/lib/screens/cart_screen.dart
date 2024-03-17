import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import "../.env";

class CartScreen extends StatefulWidget {
  final Map<String, dynamic>? reservationSaveValue;
  final Map<String, dynamic>? transactionSaveValue;
  final Projection projection;

  CartScreen(
      {Key? key,
      this.transactionSaveValue,
      this.reservationSaveValue,
      required this.projection})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Stripe.publishableKey = stripePublishableKey;
    final paymentScreen = PaymentScreen();
    final totalAmount = (widget.projection.ticketPrice! *
            double.parse(widget.reservationSaveValue!['numTicket']))
        .toStringAsFixed(0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(
                  "Items in your Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ListTile(
                  title: Text(
                    "Movie: ${widget.projection.movie?.title}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Projection: ${DateFormat('dd.MM.yyyy HH:mm').format(widget.projection.dateOfProjection)}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Quantity: ${widget.reservationSaveValue?['numTicket'] ?? 0}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Price per Ticket: \$${widget.projection.ticketPrice!.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "\$$totalAmount",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => paymentScreen.stripeMakePayment(
                  totalAmount,
                  "USD",
                  widget.reservationSaveValue,
                  widget.transactionSaveValue,
                  context),
              child: const Text(
                'Pay with Stripe',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
