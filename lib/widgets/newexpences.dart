import 'package:expence_tracker/moduls/expence.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewExpence extends StatefulWidget {
  const NewExpence({super.key, required this.onaddexpence});

  final void Function(Expence expence) onaddexpence;

  @override
  State<NewExpence> createState() {
    return _NewExpance();
  }
}

class _NewExpance extends State<NewExpence> {
  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _selecteddate;
  Catagory _selectedcatagory = Catagory.food;

  void _datepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickeddate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selecteddate = pickeddate;
    });
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  void _submitexpencedata() async {
    final enterednumber = double.tryParse(_amountcontroller
        .text); //using tryparse you check enter value is number if it not number it is return null value
    final amountsinvalid = enterednumber == null || enterednumber <= 0;
    if (_titlecontroller.text.trim().isEmpty ||
        amountsinvalid ||
        _selecteddate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('invalid input'),
          content: const Text('please enter valid input'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('ok'),
            )
          ],
        ),
      );
      return;
    }
    widget.onaddexpence(
      Expence(
        title: _titlecontroller.text,
        amount: enterednumber,
        date: _selecteddate!, //! means it is not null
        catagory: _selectedcatagory,
      ),
    );
    Navigator.pop(context);
    final user = FirebaseAuth.instance.currentUser!;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('data').add({
      'title': _titlecontroller.text,
      'amount': enterednumber,
      'date': _selecteddate,
      'catagory': _selectedcatagory.name,
      'userid': user.uid,
      'username': userdata.data()!['username'],
      'userimage': userdata.data()!['image_url'],
    });

  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraint) {
      final width = constraint.maxWidth;
      return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardspace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titlecontroller,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountcontroller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titlecontroller,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedcatagory,
                        items: Catagory.values
                            .map(
                              (catagory) => DropdownMenuItem(
                                value: catagory,
                                child: Text(
                                  catagory.name.toString(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedcatagory = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selecteddate == null
                                  ? 'no date choosen'
                                  : formatter.format(_selecteddate!),
                            ),
                            IconButton(
                              onPressed: _datepicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountcontroller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selecteddate == null
                                  ? 'no date choosen'
                                  : formatter.format(_selecteddate!),
                            ),
                            IconButton(
                              onPressed: _datepicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitexpencedata,
                      child: const Text('add expence'),
                    ),
                  ])
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedcatagory,
                        items: Catagory.values
                            .map(
                              (catagory) => DropdownMenuItem(
                                value: catagory,
                                child: Text(
                                  catagory.name.toString(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedcatagory = value;
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitexpencedata,
                        child: const Text('add expence'),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
