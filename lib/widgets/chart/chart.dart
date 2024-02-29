import 'package:flutter/material.dart';

import 'package:expence_tracker/widgets/chart/chartbar.dart';
import 'package:expence_tracker/moduls/expence.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expences});

  final List<Expence> expences;

  List<ExpenceBucket> get buckets {
    return [
      ExpenceBucket.forCatagory(expences, Catagory.food),
      ExpenceBucket.forCatagory(expences, Catagory.leisure),
      ExpenceBucket.forCatagory(expences, Catagory.travel),
      ExpenceBucket.forCatagory(expences, Catagory.work),
    ];
  }

  double get maxTotalExpence {
    double maxTotalExpence = 0;

    for (final bucket in buckets) {
      if (bucket.totalexpence > maxTotalExpence) {
        maxTotalExpence = bucket.totalexpence;
      }
    }

    return maxTotalExpence;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalexpence == 0
                        ? 0
                        : bucket.totalexpence / maxTotalExpence,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        catagoryicons[bucket.catagory],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
