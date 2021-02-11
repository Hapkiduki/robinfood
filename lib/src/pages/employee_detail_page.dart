import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:robinfood/src/models/employee.dart';
import 'package:robinfood/src/providers/general_provider.dart';

import 'package:robinfood/src/utils/colors.dart';
import 'package:robinfood/src/utils/dimensions.dart';

class EmployeesDetailPage extends StatefulWidget {
  @override
  _EmployeesDetailPageState createState() => _EmployeesDetailPageState();
}

class _EmployeesDetailPageState extends State<EmployeesDetailPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation _animCircle;

  final Duration _animDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: _animDuration,
    );

    _animCircle =
        CurveTween(curve: Interval(.0, .5)).animate(animationController);

    super.initState();

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  String getInitials(String name) {
    var initials = name.toUpperCase().split(' ');

    return initials.first.substring(0, 1) +
        (initials.length > 1 ? initials[1].substring(0, 1) : '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Dimensions.top(context, .4),
      decoration: BoxDecoration(
        color: CustomColors.pink,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Consumer<GeneralProvider>(
            builder: (context, gp, child) => AnimatedPositioned(
              left: 0,
              right: 0,
              top: gp.dragState == DragState.employees
                  ? Dimensions.height(context) * .68
                  : 10,
              duration: _animDuration,
              child: _header(context, gp),
            ),
          ),
          Consumer<GeneralProvider>(
            builder: (context, gp, child) {
              var state = gp.dragState;
              var employee = gp.selectedEmployee;

              return AnimatedPositioned(
                left: 0,
                right: 0,
                top: state == DragState.employee_detail
                    ? Dimensions.height(context) * .25
                    : 0,
                duration: _animDuration,
                child: AnimatedSwitcher(
                  duration: _animDuration,
                  child: state == DragState.employees
                      ? SizedBox.shrink()
                      : SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            children: [
                              Padding(
                                padding: Dimensions.horizontal(context, .05),
                                child: Text(
                                  employee.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.height(context) * .01,
                              ),
                              Text(
                                employee.position,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.height(context) * .01,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Wage: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.simpleCurrency()
                                          .format(employee.wage),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.height(context) * .02,
                              ),
                              Text(
                                'Employees',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Container(
                                height: Dimensions.height(context) * .20,
                                margin: Dimensions.horizontal(context, .05),
                                child: employee.employees.length > 0
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: employee.employees.length,
                                        itemBuilder: (context, i) =>
                                            _employee(employee.employees[i]),
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .supervised_user_circle_outlined,
                                              color: CustomColors.blue,
                                              size: 90,
                                            ),
                                            Text(
                                              'No worker reports',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: Dimensions.height(context) * .02,
                              ),
                              _new(employee),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _new(Employee employee) {
    return GestureDetector(
      onTap: () {
        animationController.forward(from: 0);
        employee.isNew = !employee.isNew;
      },
      child: Column(
        children: [
          Text(
            'Check as new',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: Dimensions.height(context) * .01,
          ),
          AnimatedBuilder(
            builder: (context, snapshot) => CustomPaint(
              foregroundPainter: _CircleItemPainter(_animCircle.value),
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: CustomColors.blue,
                child: Icon(
                  Icons.done_outline_rounded,
                  color: employee.isNew ? CustomColors.yellow : Colors.white,
                ),
              ),
            ),
            animation: animationController,
          ),
        ],
      ),
    );
  }

  Widget _employee(Employee employee) {
    return Container(
      margin: Dimensions.symetric(context, .02, .04),
      width: Dimensions.width(context) * .3,
      decoration: BoxDecoration(
          color: CustomColors.blue,
          borderRadius: Dimensions.borderRadiusContainer(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ]),
      child: Padding(
        padding: Dimensions.all(context, .05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: CustomColors.yellow,
              child: Text(
                getInitials(employee.name),
                style: TextStyle(
                  color: CustomColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: Dimensions.width(context) * .03),
            Text(
              employee.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CustomColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, GeneralProvider gp) {
    return Padding(
      padding: Dimensions.horizontal(context, .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: gp.dragState == DragState.employees
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: _animDuration,
              child: gp.dragState == DragState.employees
                  ? TextFormField(
                      initialValue: gp.searchParam,
                      cursorColor: CustomColors.yellow,
                      style: TextStyle(
                        color: CustomColors.yellow,
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: CustomColors.yellow.withOpacity(.7),
                        ),
                        fillColor: CustomColors.blue.withOpacity(.7),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        gp.searchParam = value;
                      },
                    )
                  : _photo(context, gp.selectedEmployee),
            ),
          ),
          SizedBox(
            width: Dimensions.width(context) * .02,
          ),
          FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            heroTag: null,
            onPressed: () {
              if (gp.dragState == DragState.employee_detail) {
                context.read<GeneralProvider>().dragState = DragState.employees;
              } else {
                context.read<GeneralProvider>().sort = !gp.sort;
              }
            },
            backgroundColor: CustomColors.blue,
            child: AnimatedCrossFade(
              crossFadeState: gp.dragState == DragState.employees
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(seconds: 1),
              firstChild: Icon(
                Icons.sort_outlined,
                color: CustomColors.yellow,
              ),
              secondChild: Icon(
                Icons.upload_outlined,
                color: CustomColors.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(BuildContext context, Employee employee) {
    return Padding(
      padding: Dimensions.left(context, .1),
      child: CircleAvatar(
        radius: Dimensions.width(context) * .2,
        backgroundColor: CustomColors.yellow,
        child: Text(
          getInitials(employee.name),
          style: TextStyle(
            color: CustomColors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}

class _CircleItemPainter extends CustomPainter {
  final double progress;

  _CircleItemPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 30.0 * progress;
    final strokeWidth = 10.0;
    final currentStrokeWidth = strokeWidth * (1 - progress);

    final paint = Paint();
    paint.color = CustomColors.pink;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = currentStrokeWidth;

    if (progress < 1) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_CircleItemPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_CircleItemPainter oldDelegate) => false;
}
