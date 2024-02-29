import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Catagory { food, travel, leisure, work }

const catagoryicons = {
  Catagory.food: Icons.food_bank,
  Catagory.travel: Icons.flight,
  Catagory.leisure: Icons.movie,
  Catagory.work: Icons.work,
};

class Expence {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Catagory catagory;

  String get formatteddate {
    return formatter.format(date);
  }

  Expence({
    required this.title,
    required this.amount,
    required this.date,
    required this.catagory,
  }) : id = uuid.v4();
}//expence

class ExpenceBucket {
  const ExpenceBucket({
    required this.catagory,
    required this.expences,
  });

  ExpenceBucket.forCatagory(List<Expence> allexpences, this.catagory)
      : expences = allexpences
            .where((expence) => expence.catagory == catagory)
            .toList();

  final Catagory catagory;
  final List<Expence> expences;

  double get totalexpence {
    double sum = 0;
    for (final expence in expences) {
      sum += expence.amount; //sum=sum+expence.amount
    } 
    return sum;
  }
}
