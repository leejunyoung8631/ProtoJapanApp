import 'dart:io';

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

  ///dasdadas dasdas
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
              return Container(
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
              );
            },
          ),
        ),
      ],
    );
  }
}
