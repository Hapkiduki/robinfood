import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:robinfood/src/utils/colors.dart';
import 'package:robinfood/src/utils/dimensions.dart';

import 'home_page.dart';

class EmployeesPage extends StatelessWidget {
  final DragState dragState;

  const EmployeesPage({Key key, this.dragState: DragState.employees})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.blue,
      padding: Dimensions.vertical(context, .09),
      child: Column(
        children: [
          Text(
            'Employees',
            style: TextStyle(
              color: CustomColors.yellow,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: dragState == DragState.employees
                  ? ListView.builder(
                      itemBuilder: (context, index) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: CustomColors.yellow,
                          onTap: () {},
                          child: _userItem(index, context),
                        ),
                      ),
                      itemCount: 20,
                      //shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userItem(int index, BuildContext context) {
    var currency = NumberFormat.simpleCurrency().format(4500000000);

    return Padding(
      padding: Dimensions.symetric(context, .05, .02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _photo(index, context),
          Container(
            width: Dimensions.width(context) * .7,
            padding: Dimensions.left(context, .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bodyUser(),
                Text(
                  currency,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(int index, BuildContext context) => Hero(
        tag: 'user_123-$index',
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: CustomColors.yellow,
              child: Text(
                'EE',
                style: TextStyle(
                  color: CustomColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  _bodyUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Ester Esposito',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          'CEO',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
