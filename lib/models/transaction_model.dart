import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {

  final String id;

  final String title;

  final double amount;

  final String type;

  final String category;

  final String note;

  final DateTime date;

  final Timestamp createdAt;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.note,
    required this.date,
    required this.createdAt,
  });

  // FIRESTORE -> MODEL
  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {

    return TransactionModel(
      id: documentId,

      title:
          map["title"] ?? "",

      amount:
          (map["amount"] ?? 0)
              .toDouble(),

      type:
          map["type"] ?? "",

      category:
          map["category"] ?? "",

      note:
          map["note"] ?? "",

      date:
          (map["date"] as Timestamp)
              .toDate(),

      createdAt:
          map["createdAt"] ??
              Timestamp.now(),
    );
  }

  // MODEL -> FIRESTORE
  Map<String, dynamic> toMap() {

    return {

      "title": title,

      "amount": amount,

      "type": type,

      "category": category,

      "note": note,

      "date":
          Timestamp.fromDate(date),

      "createdAt": createdAt,
    };
  }
}