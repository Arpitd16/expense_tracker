import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:expence_tracker/moduls/expence.dart';

class Expenceiteam extends StatelessWidget {
  const Expenceiteam(this.expence, {super.key});

  final Expence expence;
  @override
  Widget build(BuildContext context) {
    final Authenticuser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('data').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('no message found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('error occured'),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (cnt, index) {
              var expensedata = snapshot.data!.docs;
              if (Authenticuser.uid == expensedata[index]['userid']) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          expensedata[index]['title'],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text('\$${expensedata[index]['amount']}'),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(catagoryicons[expensedata[index]
                                    ['catagory']]),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(expence.formatteddate),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              return const Text('data not found');
            });
      },
    );
  }
}
