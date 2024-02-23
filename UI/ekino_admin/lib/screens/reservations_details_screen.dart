import 'package:ekino_admin/models/projection.dart';
import 'package:ekino_admin/models/reservation.dart';
import 'package:ekino_admin/models/user.dart';
import 'package:ekino_admin/providers/projections_provider.dart';
import 'package:ekino_admin/providers/reservation_provider.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ReservationDetailsScreen extends StatefulWidget {
  final Reservation? reservation;

  const ReservationDetailsScreen({Key? key, this.reservation})
      : super(key: key);

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
  List<int> selectedColumns = [];

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
      "column": widget.reservation?.column ?? '',
      "numTickets": widget.reservation?.numTickets ?? '',
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
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildForm(),
              SizedBox(height: 20),
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
          ),
          FormBuilderTextField(
            name: 'row',
            decoration: InputDecoration(labelText: "Row"),
          ),
          FormBuilderTextField(
            name: 'column',
            decoration: InputDecoration(labelText: "Column"),
          ),
          FormBuilderTextField(
            name: 'numTickets',
            decoration: InputDecoration(labelText: "Number of Tickets"),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.save();
              final formData = _formKey.currentState?.value;
              if (formData != null) {
                try {
                  await _saveReservation(formData);
                } catch (error) {
                  print('Error: $error');
                  _showMessageDialog('Error', 'An error occurred: $error');
                }
              }
            },
            child: Text(widget.reservation != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveReservation(Map<String, dynamic> formData) async {}

  Future<void> _showMessageDialog(String title, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title.contains('Success')) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSeatPicker() {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Movie screen',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          CustomPaint(
            size: Size(1200, 10), // Adjust size as needed
            painter: ScreenPainter(),
          ),
          SizedBox(height: 48),
          const Text(
            'Select a Seat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // Reduced number of columns
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8,
              childAspectRatio: 5, // Adjust aspect ratio as needed
            ),
            itemCount: 40, // Reduced total number of seats
            itemBuilder: (context, index) {
              final row = index ~/ 8; // Row index
              final column = index % 8; // Column index
              final seatRow = String.fromCharCode(65 + row);
              final seatColumn = column + 1;

              // Check if the seat belongs to any reservation
              final isReserved = allReservations?.any((reservation) {
                    final rowList = reservation.row?.split(',') ?? [];
                    final columnList = reservation.column?.split(',') ?? [];
                    if (rowList.isNotEmpty &&
                        columnList.isNotEmpty &&
                        rowList.length == columnList.length) {
                      return rowList.asMap().entries.any((entry) {
                        final rowIndex = entry.key;
                        final rowValue = entry.value;
                        final columnValue =
                            int.tryParse(columnList.elementAt(rowIndex));
                        return seatRow == rowValue && seatColumn == columnValue;
                      });
                    }
                    return false;
                  }) ??
                  false;

              final currentUserReservation = widget.reservation;
              final currentUserReserved = currentUserReservation != null &&
                  currentUserReservation.row
                          ?.split(',')
                          .asMap()
                          .entries
                          .any((entry) {
                        final rowIndex = entry.key;
                        final rowValue = entry.value;
                        final columnList =
                            currentUserReservation.column?.split(',') ?? [];
                        if (columnList.isNotEmpty &&
                            rowIndex < columnList.length) {
                          final columnValue =
                              int.tryParse(columnList[rowIndex]);
                          return seatRow == rowValue &&
                              seatColumn == columnValue;
                        }
                        return false;
                      }) ==
                      true;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    // You can add logic here if needed
                  });
                },
                child: Container(
                  color: currentUserReserved
                      ? Colors.green // Current user's reservation
                      : (isReserved
                          ? Colors.red
                          : Colors.grey), // Other reservations
                  child: Center(
                    child: Text(
                      '${String.fromCharCode(65 + row)}${column + 1}',
                      style: TextStyle(
                        color: currentUserReserved || isReserved
                            ? Colors.white
                            : Colors.black,
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
      ..strokeWidth = 12.0 // Adjust stroke width as needed
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
