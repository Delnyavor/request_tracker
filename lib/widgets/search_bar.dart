import 'package:flutter/material.dart';
import 'package:request_tracker/utils/screen_adapter.dart';

class SearchWidget extends StatefulWidget {
  final Widget newRoute;

  SearchWidget({Key key, this.newRoute}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();
  bool open = false;
  bool completed = true;

  Animation widgetTransition;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 340));
    widgetTransition = Tween<double>(begin: 1, end: 0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return enclosure(context);
  }

  Widget enclosure(context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 330),
      curve: Curves.linearToEaseOut,
      padding: open
          ? const EdgeInsets.only(top: 15)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: <Widget>[
          Flexible(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 350),
              curve: Curves.linearToEaseOut,
              height: open ? 1000 : 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(open ? 15 : 30),
                border: Border.all(color: Colors.transparent, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 2),
                    spreadRadius: -0.5,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      open = !open;
                      completed = false;
                    });
                  },
                  child: contents(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contents() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 150),
      opacity: completed ? 1 : 0,
      onEnd: () {
        Future.delayed(Duration(milliseconds: 40), () {
          setState(() {
            completed = true;
          });
        });
      },
      child: SizedBox.fromSize(
        size: Size.fromHeight(42),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(
                left: ResponsiveSize.flexWidth(
                    20, MediaQuery.of(context).size.width),
              ),
              child: Text('Search')),
        ),
      ),
    );
  }

  TextField searchField() {
    return TextField(
      decoration: InputDecoration(border: InputBorder.none),
    );
  }

  Widget searchToggle(BuildContext context) {
    return FloatingActionButton(
      elevation: 4,
      backgroundColor: Colors.greenAccent,
      mini: true,
      child: Icon(Icons.search, color: Colors.white),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget.newRoute));
      },
    );
  }
}
