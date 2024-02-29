import 'package:flutter/material.dart';
import 'package:expence_tracker/screen/expences.dart';
import 'package:expence_tracker/screen/account.dart';

class Tabscreen extends StatefulWidget {
  const Tabscreen({super.key});

  @override
  State<Tabscreen> createState() {
    return _Tabscreen();
  }
}

class _Tabscreen extends State<Tabscreen> {
  int _selectedpageindex = 0;

  void _selectedpage(int index) {
    setState(() {
      _selectedpageindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activepage = const Expences();
    

    if(_selectedpageindex == 1){
      activepage = const Account();
    }

    return Scaffold(
      body: activepage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedpage,
          currentIndex: _selectedpageindex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: Colors.blue,
              ),
              label: 'Account',
            ),
          ]),
    );
  }
}
