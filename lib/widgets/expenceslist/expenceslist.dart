import 'package:flutter/material.dart';
import 'package:expence_tracker/moduls/expence.dart';
import 'package:expence_tracker/widgets/expenceslist/expenceiteam.dart';

class Expencelist extends StatelessWidget {
  const Expencelist({
    super.key,
    required this.expences,
    required this.onremoveexpence,
  });

  final List<Expence> expences;

  final void Function(Expence expence) onremoveexpence;

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      itemCount: expences.length,
      itemBuilder: (cnt, index) => Dismissible(
        key: ValueKey(expences[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.50),
          margin:EdgeInsets.symmetric(horizontal:Theme.of(context).cardTheme.margin!.horizontal ) ,
        ),
        onDismissed: (direction) {
          onremoveexpence(expences[index]);
        },
        child: Expenceiteam(expences[index]),
      ),
    );
  }
} 
