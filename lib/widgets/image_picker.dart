import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Userimagepicker extends StatefulWidget {
  const Userimagepicker({super.key, required this.onpickimg});
  final void Function(File pickedimg) onpickimg;

  @override
  State<Userimagepicker> createState() {
    return _Userimagepicker();
  }
}

class _Userimagepicker extends State<Userimagepicker> {
  File? _pickedimage;

  void _pickimg() async {
    final pickedimg = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedimg == null) {
      return;
    }

    setState(() {
      _pickedimage = File(pickedimg.path);
    });

    widget.onpickimg(_pickedimage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedimage != null ? FileImage(_pickedimage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickimg,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
