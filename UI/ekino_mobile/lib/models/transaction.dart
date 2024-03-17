import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  int? transactionId;
  int? userId;
  int? reservationId;
  DateTime? date;
  double? number;

  Transaction(
    this.transactionId,
    this.userId,
    this.reservationId,
    this.date,
    this.number,
  );

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
