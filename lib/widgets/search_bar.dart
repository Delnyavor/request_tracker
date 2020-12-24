import 'package:flutter/material.dart';
import 'package:request_tracker/controller/controller.dart';
import 'package:request_tracker/models/feedback_form.dart';

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

  List<FeedbackForm> feedbackItems = <FeedbackForm>[];

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
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
    return WillPopScope(
        onWillPop: () async {
          if (open) {
            setState(() {
              open = false;
            });
          } else
            open = true;
          return open;
        },
        child: SafeArea(child: frame(context)));
  }

  Widget frame(context) {
    return Stack(
      children: [
        resultFrame(),
        Align(alignment: Alignment.bottomCenter, child: enclosure()),
      ],
    );
  }

  Widget enclosure() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            Flexible(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  padding: open
                      ? const EdgeInsets.only(
                          left: 16.0,
                        )
                      : const EdgeInsets.all(0),
                  child: SizedBox(
                      width: open ? MediaQuery.of(context).size.width : 43,
                      child: searchField()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchField() {
    return Row(
      children: [
        Flexible(
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.search,
            controller: textController,
            onSubmitted: (string) {},
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 14, height: 1.34),
            ),
          ),
        ),
      ],
    );
  }

  Widget searchToggle(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      icon: Icon(Icons.search, color: Colors.greenAccent),
      onPressed: () {
        if (!open) {
          setState(() {
            open = true;
          });
        }
        search(FormController.FIND_ALL_BY_ID);
      },
    );
  }

  Widget resultBuilder() {
    return FutureBuilder(
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('Please check your internet connection'),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.done:
            print(snapshot.data.documents);
            return Center(
              child: Text(snapshot.data),
            );
            break;
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget resultFrame() {
    return ListView.builder(
      itemCount: feedbackItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.person),
              Expanded(
                child: Text(
                    "${feedbackItems[index].name} (${feedbackItems[index].email}), ${feedbackItems[index].mobileNo}"),
              )
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              Icon(Icons.message),
              Expanded(
                child: Text(feedbackItems[index].feedback),
              )
            ],
          ),
        );
      },
    );
  }

  void search(String searchType) {
    if (textController.text.isNotEmpty) {
      FormController()
          .getFeedbackList(
              GetterParams(id: textController.text, type: searchType))
          .then((feedbackItems) {
        setState(() {
          this.feedbackItems = feedbackItems;
        });
      });
    }
  }
}
