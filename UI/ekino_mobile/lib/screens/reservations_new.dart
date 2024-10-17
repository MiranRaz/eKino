import 'package:ekino_mobile/models/reservation.dart';
import 'package:ekino_mobile/providers/reservation_provider.dart';
import 'package:ekino_mobile/providers/transaction_provider.dart';
import 'package:ekino_mobile/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewReservationScreen extends StatefulWidget {
  final Users currentUser;
  final Projection projection;

  const NewReservationScreen({
    super.key,
    required this.currentUser,
    required this.projection,
  });

  @override
  _NewReservationScreenState createState() => _NewReservationScreenState();
}

class _NewReservationScreenState extends State<NewReservationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialValue;
  late Map<String, dynamic> _saveReservationValue;
  late Map<String, dynamic> _saveTransactionValue;
  late ReservationProvider _reservationProvider;
  late TransactionProvider _transactionProvider;
  bool isLoading = true;
  late List<List<bool>> seats;

  List<Reservation>? allReservations; // Added to store all reservations
  late String numTicket = '0';

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _transactionProvider = context.read<TransactionProvider>();

    _initialValue = {
      "userId": widget.currentUser.userId?.toString(),
      "projectionId": widget.projection.projectionId.toString(),
      "row": '',
      "numTicket": numTicket,
    };
    initForm();
    seats = List.generate(8, (_) => List.generate(8, (_) => false));
  }

  Future<void> initForm() async {
    final reservationsResult = await _reservationProvider.get();
    allReservations = reservationsResult.result;

    setState(() {
      isLoading = false;
      seats = List.generate(8, (_) => List.generate(8, (_) => false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Reservation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildForm(),
              SizedBox(height: 64),
              CustomPaint(
                size: Size(1200, 10),
                painter: ScreenPainter(),
              ),
              const SizedBox(height: 48),
              _buildSeatPicker(),
              const SizedBox(height: 20),
              ElevatedButton(
                // Button to save reservation
                onPressed: _saveReservation,
                child: const Text('Proceed to checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveReservation() async {
    _saveReservationValue = {
      "userId": widget.currentUser.userId.toString(),
      "projectionId": widget.projection.projectionId.toString(),
      "row": _initialValue['row'],
      "column": "x",
      "numTicket": numTicket,
    };

    _saveTransactionValue = {
      "dateOfTransaction": DateTime.now().toIso8601String(),
      "reservationId": "",
      "userId": widget.currentUser.userId.toString(),
      "amount":
          (widget.projection.ticketPrice! * double.parse(numTicket)).toString(),
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartScreen(
            reservationSaveValue: _saveReservationValue,
            transactionSaveValue: _saveTransactionValue,
            projection: widget.projection),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'User: ${widget.currentUser.username ?? ''}',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Projection: ${widget.projection.movie?.title ?? ''}',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Date of Projection: ${widget.projection.dateOfProjection != null ? DateFormat('dd.MM.yyyy HH:mm').format(widget.projection.dateOfProjection) : 'Unknown'}',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Row: ${_initialValue['row']}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Number of Tickets: $numTicket',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatPicker() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select a Seat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
            ),
            itemCount: 40,
            itemBuilder: (context, index) {
              final row = index ~/ 8;
              final column = index % 8;
              final seatRow = String.fromCharCode(65 + row);
              final seatColumn = column + 1;

              final seatValue = '$seatRow$seatColumn';
              final isReserved = allReservations?.any((reservation) =>
                      reservation.row!.contains(seatValue) &&
                      reservation.projectionId ==
                          int.parse(_initialValue['projectionId'])) ??
                  false;

              final isSelected = _initialValue['row']
                  ?.split(',')
                  .contains(seatValue); // Check if the seat is already selected

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (!isReserved) {
                      final selectedSeats =
                          _initialValue['row']?.split(',') ?? [];
                      if (isSelected!) {
                        selectedSeats.remove(seatValue);
                      } else {
                        selectedSeats.add(seatValue);
                      }
                      _initialValue['row'] = selectedSeats.join(',');
                      if (!isSelected!) {
                        numTicket = (int.parse(numTicket) + 1).toString();
                      } else {
                        numTicket = (int.parse(numTicket) - 1).toString();
                      }
                      _formKey.currentState?.fields['row']
                          ?.didChange(_initialValue['row']);
                      _formKey.currentState?.fields['numTicket']
                          ?.didChange(numTicket);
                      seats[row][column] = !isSelected;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: (isReserved
                        ? Colors.red
                        : (isSelected ? Colors.blue : Colors.grey)),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      '${String.fromCharCode(65 + row)}${column + 1}',
                      style: TextStyle(
                        color: isReserved ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0 // Adjust stroke width as needed
      ..style = PaintingStyle.stroke;

    Offset controlPoint1 = Offset(size.width * 0.25, size.height * 0.75);
    Offset controlPoint2 = Offset(size.width * 0.75, size.height * 0.75);

    Path path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(controlPoint1.dx, controlPoint1.dy, size.width / 2,
          size.height * 0.25)
      ..quadraticBezierTo(
          controlPoint2.dx, controlPoint2.dy, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
