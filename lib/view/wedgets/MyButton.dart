import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String? text;
final void Function()? onpressed;
const MyButton({super.key,this.text,this.onpressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      child: Text(text ?? ''),
    );
  }
}