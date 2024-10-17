import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/models/reservation.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:ekino_mobile/providers/projections_provider.dart';
import 'package:ekino_mobile/providers/reservation_provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReservationDetailsScreen extends StatefulWidget {
  final Reservation? reservation;

  const ReservationDetailsScreen({super.key, this.reservation});

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialValue;
  late UsersProvider _usersProvider;
  late ProjectionsProvider _projectionsProvider;
  late ReservationProvider _reservationProvider;
  List<Users>? _usersList;
  List<Projection>? _projectionsList;
  bool isLoading = true;
  late List<List<bool>> seats;
  List<String> selectedRows = [];

  List<Reservation>? allReservations; // Added to store all reservations

  @override
  void initState() {
    super.initState();
    _usersProvider = context.read<UsersProvider>();
    _projectionsProvider = context.read<ProjectionsProvider>();
    _reservationProvider = context.read<ReservationProvider>();

    _initialValue = {
      "userId": widget.reservation?.userId?.toString(),
      "projectionId": widget.reservation?.projectionId.toString(),
      "row": widget.reservation?.row ?? '',
      "numTicket": widget.reservation?.numTicket ?? '',
    };
    initForm();
    seats = List.generate(8, (_) => List.generate(8, (_) => false));
  }

  Future<void> initForm() async {
    final usersResult = await _usersProvider.get();
    _usersList = usersResult.result;
    final projectionsResult = await _projectionsProvider.get();
    _projectionsList = projectionsResult.result;
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
        title: Text(widget.reservation != null
            ? 'Reservation Details'
            : 'New Reservation'),
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
              SizedBox(height: 48),
              _buildSeatPicker(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          FormBuilderDropdown<String>(
            name: 'userId',
            decoration: InputDecoration(labelText: "User"),
            items: _usersList
                    ?.map((user) => DropdownMenuItem(
                          value: user.userId.toString(),
                          child: Text(user.username ?? ''),
                        ))
                    .toList() ??
                [],
            enabled: false,
          ),
          FormBuilderDropdown<String>(
            name: 'projectionId',
            decoration: InputDecoration(labelText: "Projection"),
            items: _projectionsList
                    ?.map(
                      (projection) => DropdownMenuItem(
                        value: projection.projectionId.toString(),
                        child: Text(projection.movie?.title ?? ''),
                      ),
                    )
                    .toList() ??
                [],
            enabled: false,
          ),
          FormBuilderTextField(
            name: 'dateOfProjection',
            decoration: InputDecoration(labelText: "Date of Projection"),
            initialValue: _projectionsList
                        ?.firstWhere((projection) =>
                            projection.projectionId.toString() ==
                            _initialValue['projectionId'])
                        .dateOfProjection !=
                    null
                ? DateFormat('dd.MM.yyyy HH:mm').format(_projectionsList!
                    .firstWhere((projection) =>
                        projection.projectionId.toString() ==
                        _initialValue['projectionId'])
                    .dateOfProjection)
                : 'Unknown',
            enabled: false,
          ),
          FormBuilderTextField(
            name: 'row',
            decoration: InputDecoration(labelText: "Row"),
            enabled: false,
          ),
          FormBuilderTextField(
            name: 'numTicket',
            decoration: InputDecoration(labelText: "Number of Tickets"),
            enabled: false,
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
          Text(
            'Select a Seat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        // If already selected, remove it from the list
                        selectedSeats.remove(seatValue);
                      } else {
                        selectedSeats.add(seatValue); // Add to the list
                      }
                      _formKey.currentState?.fields['row']
                          ?.didChange(selectedSeats.join(','));
                      _initialValue['row'] = selectedSeats.join(',');
                      seats[row][column] =
                          !isSelected; // Toggle selection state
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
