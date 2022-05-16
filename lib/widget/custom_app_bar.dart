import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key key, this.title, this.iconButton, this.isBack = false, this.height})
      : super(key: key);
  final String title;
  final IconButton iconButton;
  final bool isBack;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.1,
      color: Colors.blue[900],
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Row(
        children: [
          if (isBack)
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.keyboard_arrow_left_outlined,
                    color: Colors.blue)),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Center(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
