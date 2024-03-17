import 'package:ekino_mobile/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingsScreen extends StatefulWidget {
  final int userId;
  final int movieId;

  const RatingsScreen({Key? key, required this.userId, required this.movieId})
      : super(key: key);

  @override
  _RatingsScreenState createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  late RatingProvider _ratingsProvider;
  late TextEditingController _valueController;
  int? existingRatingValue;
  dynamic existingRating; // Declare as dynamic

  @override
  void initState() {
    super.initState();

    _ratingsProvider = Provider.of<RatingProvider>(context, listen: false);
    _valueController = TextEditingController();

    _loadExistingRating();
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _loadExistingRating() async {
    existingRating = await _ratingsProvider.get(filter: {
      'UserId': widget.userId,
      'MovieId': widget.movieId,
    });

    if (existingRating.result.isNotEmpty) {
      final int existingValue = existingRating.result[0].value!;
      setState(() {
        existingRatingValue = existingValue;
        _valueController.text = existingValue.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("existingRating -> $existingRating-");
    return AlertDialog(
      title: Text('Enter Rating'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: TextEditingController(text: widget.userId.toString()),
              enabled: false,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextFormField(
              controller:
                  TextEditingController(text: widget.movieId.toString()),
              enabled: false,
              decoration: InputDecoration(labelText: 'Movie ID'),
            ),
            TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Value'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final int value = int.tryParse(_valueController.text) ?? 0;
            _saveRating(widget.userId, widget.movieId, value);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _saveRating(int userId, int movieId, int value) async {
    final ratingData = {
      'userId': userId,
      'movieId': movieId,
      'value': value,
    };

    try {
      if (existingRatingValue != null) {
        // If there is an existing rating value, update the rating
        await _ratingsProvider.update(
            existingRating.result[0].ratingId, ratingData);
        _showSnackbar('Rating updated successfully', true);
      } else {
        // If there is no existing rating value, insert a new rating
        await _ratingsProvider.insert(ratingData);
        _showSnackbar('Rating saved successfully', true);
      }
    } catch (error) {
      _showSnackbar('Failed to save rating: $error', false);
    }
  }

  void _showSnackbar(String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
