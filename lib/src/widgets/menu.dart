import 'package:flutter/material.dart';

import 'package:robinfood/src/utils/beat_animation.dart';
import 'package:robinfood/src/utils/colors.dart';
import 'package:robinfood/src/utils/dimensions.dart';

class MenuItem {
  IconData icon;
  String text;

  MenuItem({@required this.icon, @required this.text});
}

class Menu extends StatefulWidget {
  final List<MenuItem> items;
  final ValueChanged<int> onChange;
  final int selected;

  const Menu(
      {Key key,
      @required this.items,
      @required this.onChange,
      this.selected = 0})
      : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  int _currentIndex;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selected ?? 0;

    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    controller?.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.height(context) * .07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.items.length,
          (i) => GestureDetector(
            onTap: () {
              if (i != _currentIndex) {
                controller?.forward(from: 0);
                setState(() {
                  _currentIndex = i;
                });

                widget.onChange(_currentIndex);
              }
            },
            child: _currentIndex == i
                ? BeatAnimation(child: _item(i), controller: controller)
                : _item(i),
          ),
        ),
      ),
    );
  }

  Widget _item(int i) {
    return Container(
      margin: Dimensions.horizontal(context, .03),
      padding: Dimensions.horizontal(context, .02),
      decoration: BoxDecoration(
        color: _currentIndex == i ? CustomColors.blue : Colors.transparent,
        shape: BoxShape.rectangle,
        borderRadius: Dimensions.borderRadiusContainer(20),
        border: Border.all(
          color: CustomColors.yellow,
          width: 2.0,
        ),
        boxShadow: _currentIndex == i
            ? [
                BoxShadow(
                  color: CustomColors.blue,
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: Offset(1, 1),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.items[i].icon,
            color: CustomColors.light_yellow,
          ),
          Text(
            widget.items[i].text,
            style: TextStyle(
              color: CustomColors.light_yellow,
            ),
          ),
        ],
      ),
    );
  }
}
