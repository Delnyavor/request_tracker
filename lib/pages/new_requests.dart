import 'dart:async';

import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with TickerProviderStateMixin {
  String errorText = '';
  List<String> items = [];
  TextEditingController controller = TextEditingController();
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Flexible(
              child: Stack(
                children: [
                  ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          listItem(items[index], index)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FadeTransition(
                      opacity: animation,
                      child: Text(
                        errorText,
                        style: TextStyle(
                            color: Colors.redAccent.shade400,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            inputField()
          ],
        ),
      ),
    );
  }

  Widget inputField() {
    return Card(
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              cursorHeight: 23,
              onEditingComplete: () {
                //Add
              },
              onSubmitted: (text) {
                validator(text);
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          suffixIcon()
        ],
      ),
    );
  }

  Widget suffixIcon() {
    return IconButton(
      icon: Icon(
        Icons.upload_file,
        color: Color(0xff5888ef),
        size: 25,
      ),
      onPressed: () {
        // validator(controller.text);
      },
    );
  }

  void validator(String text) {
    if (int.tryParse(text) is int && text.length == 5) {
      text = '100' + text.trim();
    }
    String error = findError(text);
    if (error.isNotEmpty) {
      setState(() {
        runAnimation(error);
      });
    } else
      setState(() {
        items.add(text);
        controller.clear();
      });
  }

  String findError(String text) {
    String message = '';
    if (text.length < 8) {
      return 'Insufficient character length';
    }
    if (text.contains(' ')) {
      return 'No spaces within indexes';
    } else
      return message;
  }

  void runAnimation(String text) {
    errorText = text;
    animationController.forward();
    Timer(Duration(milliseconds: 5000), () {
      animationController.reverse();
    });
  }

  Widget listItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black12),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 14, letterSpacing: 1),
              ),
              InkWell(
                child: Icon(
                  Icons.remove,
                  size: 18,
                  color: Colors.redAccent.shade200,
                ),
                onTap: () {
                  setState(() {
                    items.removeAt(index);
                    print('removed: $index');
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
