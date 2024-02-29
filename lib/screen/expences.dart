//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/moduls/expence.dart';
import 'package:expence_tracker/widgets/expenceslist/expenceslist.dart';
import 'package:expence_tracker/widgets/newexpences.dart';
import 'package:expence_tracker/widgets/chart/chart.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});
  @override
  State<Expences> createState() {
    return _ExpenceState();
  }
}

class _ExpenceState extends State<Expences> {
  final List<Expence> _registerexpence = [
    Expence(
      title: 'flutter course',
      amount: 19.99,
      date: DateTime.now(),
      catagory: Catagory.work,
    ),
    Expence(
      title: 'cinema',
      amount: 15.69,
      date: DateTime.now(),
      catagory: Catagory.leisure,
    ),
  ];

  void _openAddexpenceoverly() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (cnt) => NewExpence(
        onaddexpence: _addexpence,
      ),
    );
  }

  void _addexpence(Expence expence) {


    setState(() {
      _registerexpence.add(expence);
    });
  }

  void _removeexpence(Expence expence) {
    final expenceindex = _registerexpence.indexOf(expence);
    setState(() {
      _registerexpence.remove(expence);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("expense deleted"),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(
              () {
                _registerexpence.insert(expenceindex, expence);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(MediaQuery.of(context).size.width);
    Widget maincontent = const Center(
      child: Text('No expence found. start adding some!'),
    );
    if (_registerexpence.isNotEmpty) {
      maincontent = Expencelist(
        expences: _registerexpence,
        onremoveexpence: _removeexpence,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expence Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddexpenceoverly,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:
       width < 600
            ? Column(
                children: [
                  Chart(expences: _registerexpence),
                  Expanded(
                    child: maincontent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expences: _registerexpence),
                  ),
                  Expanded(
                    child: maincontent,
                  ),
                ],
              ), 
      
    );
  }
}

