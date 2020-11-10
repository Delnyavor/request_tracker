import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:request_tracker/models/request_model.dart';
import 'package:request_tracker/pages/new_requests.dart';

class HomePage extends StatefulWidget {
  final List<Request> requests;

  const HomePage({Key key, this.requests}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Widget> pages = <Widget>[];

  int currentPage = 0;
  double deviceWidth;

  Animation<Offset> animation;
  AnimationController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceWidth = MediaQuery.of(context).size.width;

    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(-deviceWidth, 0))
        .animate(controller);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    pages = [
      RequestsListPage(widget.requests),
      Transform.translate(offset: Offset(deviceWidth, 0), child: RequestsPage())
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff6898ff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: pages[currentPage],
      bottomNavigationBar: bottomAppBar(),
    );
  }

  Widget pageContainer() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Stack(
        children: [
          SlideTransition(
            position: animation,
            child: pages[0],
          ),
          SlideTransition(
            position: animation,
            child: pages[1],
          )
        ],
      ),
    );
  }

  Widget bottomAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: BottomNavigationBar(
        currentIndex: currentPage,
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        iconSize: 22,
        // selectedIconTheme: IconThemeData(size: 22),
        selectedItemColor: Color(0xff5888ef),
        unselectedItemColor: Colors.black45,
        // unselectedLabelStyle: TextStyle(
        //     fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        // selectedLabelStyle: TextStyle(
        //     fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_calls_outlined), label: 'Home'),
        ],
        onTap: (int index) {
          index == 1 ? controller.forward() : controller.reverse();
        },
      ),
    );
  }

  pagesHandler(int index) {
    //TODO: on call, run the animation
    //run the animation and swap pages halfway through
  }
}

class RequestsListPage extends StatefulWidget {
  final List<Request> requests;

  const RequestsListPage(this.requests);
  @override
  RequestsListPageState createState() => RequestsListPageState();
}

class RequestsListPageState extends State<RequestsListPage> {
  List<Request> requests = [];
  List<GroupedRequests> groups = <GroupedRequests>[];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createWidgets();
  }

  @override
  void initState() {
    super.initState();
    requests = widget.requests;
  }

  void createWidgets() {
    List<Request> miniList = <Request>[];
    int i = 0;
    print(DateTime.now().microsecond);
    while (i < requests.length) {
      int lastDatePosition = requests
          .lastIndexWhere((element) => element.takenOn == requests[i].takenOn);
      miniList = requests.getRange(i, lastDatePosition).toList();
      groups.add(GroupedRequests(
        requests: miniList,
      ));

      i = lastDatePosition + 1;
    }
    print(DateTime.now().microsecond);
  }

  @override
  Widget build(BuildContext context) {
    return requests.isEmpty
        ? Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ))
        : ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) => groups[index]);
  }

  Widget requestIndicator() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.green.withBlue(155).withOpacity(0.85),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
          ),
        ),
      ),
    );
  }
}

class GroupedRequests extends StatelessWidget {
  final List<Request> requests;

  const GroupedRequests({Key key, this.requests}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.grey[100]),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: requests.map((e) => Text(e.id)).toList(),
          ),
        ),
      ),
    );
  }
}

class DateFormatter {
  final String date;
  const DateFormatter(this.date);

  String truncate() {
    DateTime dateTime = DateTime.parse(date);

    return "${dateTime.day}-${dateTime.month}-${dateTime.year.toString().substring(2)}";
  }

  String hyphenate() {
    return date.replaceAll("/", "-");
  }
}
