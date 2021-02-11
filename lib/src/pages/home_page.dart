import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:robinfood/src/providers/general_provider.dart';

import 'package:robinfood/src/utils/beat_animation.dart';
import 'package:robinfood/src/utils/colors.dart';
import 'package:robinfood/src/utils/dimensions.dart';

import 'package:robinfood/src/widgets/menu.dart';

import 'employees_page.dart';
import 'employee_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double maxHeight;
  double minHeight;
  AnimationController _controller;

  final List<MenuItem> _menuItems = [
    MenuItem(icon: Icons.list_alt, text: 'Employees'),
    MenuItem(icon: Icons.attribution_outlined, text: 'New employees'),
  ];
  Widget _currentPage = EmployeesPage();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _controller?.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onVerticalDrag(DragUpdateDetails details) {
    if (details.primaryDelta > 7) {
      context.read<GeneralProvider>().dragState = DragState.employee_detail;
    } else if (details.primaryDelta < -4) {
      context.read<GeneralProvider>().dragState = DragState.employees;
    }
  }

  double _getTopDetail() {
    var state = context.select((GeneralProvider gp) => gp.dragState);
    if (state == DragState.employees) {
      return -maxHeight;
    } else {
      return -minHeight;
    }
  }

  double _getTopEmployees() {
    var state = context.select((GeneralProvider gp) => gp.dragState);
    if (state == DragState.employees) {
      return minHeight;
    } else {
      return maxHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    maxHeight = Dimensions.height(context) * .85;
    minHeight = Dimensions.height(context) * .15;

    return Scaffold(
      backgroundColor: CustomColors.blue,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              top: _getTopDetail(),
              left: 0,
              right: 0,
              height: Dimensions.height(context),
              child: GestureDetector(
                onVerticalDragUpdate: _onVerticalDrag,
                child: EmployeesDetailPage(),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              top: _getTopEmployees(),
              left: 0,
              right: 0,
              height: Dimensions.height(context),
              child: BeatAnimation(
                controller: _controller,
                child: _currentPage,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              child: Selector<GeneralProvider, DragState>(
                selector: (_, gp) => gp.dragState,
                builder: (context, state, child) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: state == DragState.employees
                        ? Menu(
                            items: _menuItems,
                            onChange: (selected) {
                              _controller.forward(from: 0);
                            },
                          )
                        : SizedBox.shrink(),
                  );
                },
              ),
              top: minHeight * .75,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
