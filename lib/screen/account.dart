import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userdata = snapshot.data!.data();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              userdata?['image_url'],
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error),
                              );
                            }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Fordata(
                    title: 'Username',
                    icon: Icons.person_2_outlined,
                    value: userdata?['username'],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Fordata(
                    title: 'Email',
                    icon: Icons.email_outlined,
                    value: userdata?['email'],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Fordata extends StatelessWidget {
  const Fordata({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          leading: Icon(icon),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.6),
        ),
      ],
    );
  }
}
