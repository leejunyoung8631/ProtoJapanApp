import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class TipPage extends StatelessWidget {
  const TipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TipPageItem();
  }
}

class TipPageItem extends StatefulWidget {
  const TipPageItem({super.key});

  @override
  State<StatefulWidget> createState() => _TipPageItemState();
}

class _TipPageItemState extends State<TipPageItem> {
  Widget titleInfo = const Text(
    "These are general tips for travelers. Be carfull not to overtrust.",
  );

  // Top warning
  final Widget _titleInfo = Container(
    height: 150,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black12,
        width: 3.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.fromLTRB(10, 30, 10, 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning,
          size: 70,
          color: Colors.yellow,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("These are general tips for travelers."),
              Text("Be carfull not to overtrust."),
            ],
          ),
        ),
      ],
    ),
  );

// for GridView items
  var exItems = [
    ["assets/images/greeting.jpg", "Manner"],
    ["assets/images/building.jpg", "Accomodation"],
    ["assets/images/money.jpg", "Money"],
    ["assets/images/present.jpg", "present"],
    ["assets/images/vjw.jpg", "VJW"],
    ["assets/images/vjw.jpg", "Unnamed"],
  ];
//

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: _titleInfo,
        ),
        Expanded(
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / .8,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (BuildContext context, int index) {
              var a = exItems.elementAt(index).elementAt(0);
              var b = exItems.elementAt(index).elementAt(1);

              return GestureDetector(
                onTap: () {
                  debugPrint("container {$b} tap"); // for debug
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoPage(title: b)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      opacity: 0.6,
                      fit: BoxFit.fill,
                      image: AssetImage(
                        a,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      b,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// for pressed page
// question
// 1. return Widget function?
// -> this just return contatiner, which has design of nnothing

// Widget infoPage() {
//   return Container(
//     child: Text("dasd"),
//   );
// }

// 2. return class, which return widget

class InfoPage extends StatefulWidget {
  const InfoPage({super.key, required this.title});

  // 여기 타이틀은 위의 required에서 받은 title이 대입되어지는 것이고 아래 상태함수의 widget.title으로 쓸 수 있음.
  final String title;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List item = [];
  List<ExpansionPanel> e_body = [];
  List<bool> expand = [
    false,
    false,
    false,
    false,
    false,
    false
  ]; // trick for expandedTile

  Future<void> readJson(String S) async {
    S = S.toLowerCase();
    final String response = await rootBundle.loadString("assets/etc/$S.json");
    final data = await json.decode(response);

    setState(() {
      item = data[S];
    });

    if (data == null) {
      debugPrint("eeeeeeee");
    }
  }

  List<ExpansionPanel> getPanel() {
    var temp = List<ExpansionPanel>.generate(item.length, (index) {
      var ques = item.elementAt(index)["Q"];
      var ans = item.elementAt(index)["A"];
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(ques),
          );
        },
        body: ListTile(
          title: Text(ans),
        ),
        isExpanded: expand[index],
      );
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // parsing data
    readJson(widget.title);
    e_body = getPanel();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                expand[panelIndex] = !isExpanded;
              });
            },
            children: e_body,
          ),
        ));
  }
}
