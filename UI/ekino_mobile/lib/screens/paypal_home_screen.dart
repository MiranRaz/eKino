import 'package:ekino_mobile/models/projection.dart';
import 'package:flutter/material.dart';
import 'payment_screen.dart';

class PaypalHomeScreen extends StatelessWidget {
  final Map<String, dynamic>? reservationSaveValue;
  final Projection projection;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Constructor
  PaypalHomeScreen(
      {Key? key, this.reservationSaveValue, required this.projection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "reservationSaveValue -> $reservationSaveValue prj -> ${projection.projectionId}");

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Paypal Payment',
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
            const Column(
              children: [
                Text(
                  "Items in your Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ListTile(
                  title: Text(
                    "Product: One plus 10",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Quantity: 1",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    "\$100",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // make PayPal payment
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => PaymentScreen(
                      onFinish: (number) async {
                        // payment done
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Payment done Successfully'),
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                'Pay with Paypal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
