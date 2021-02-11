import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:robinfood/src/models/employee.dart';
import 'package:robinfood/src/models/response.dart';
import 'package:robinfood/src/providers/general_provider.dart';
import 'package:robinfood/src/services/employee_service.dart';

import 'package:robinfood/src/utils/colors.dart';
import 'package:robinfood/src/utils/dimensions.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> _employees = [];
  List<Employee> _filterEmployees = [];
  List<Employee> _tempEmployees = [];

  @override
  void initState() { 
    super.initState();
    print('******** Entra en el init ******');
  }

  sort(BuildContext context, List<Employee> tEmployees) {
    var gp = context.watch<GeneralProvider>();
    if (gp.sort) {
      if (tEmployees.isNotEmpty) {
        quickSort2(tEmployees);
      }
    } else {
      _tempEmployees = [..._employees];
    }
  }

  quickSort2(List<Employee> employees, [int left = 0, int right]) {
    right ??= employees.length - 1;
    if (left < right) {
      int index = partition(employees, left, right);

      quickSort2(employees, left, index - 1);
      quickSort2(employees, index + 1, right);
    }

    return employees;
  }

  int partition(List<Employee> employees, int left, int right) {
    if (employees.isEmpty) {
      return 0;
    }

    Employee pivot = employees[right];
    int position = left - 1;

    for (var i = left; i < right; i++) {
      if (employees[i].wage < pivot.wage) {
        position++;
        swap(employees, position, i);
      }
    }

    swap(employees, position + 1, right);
    return position + 1;
  }

  swap(List<Employee> array, int a, int b) {
    Employee temp = array[b];
    array[b] = array[a];
    array[a] = temp;
  }

  /*  quickSort(List<int> array) {
    // 12345689

    /**
    * In this algorithm the array based on the first position
    * is compared and divided into three parts that are
    * concatenate and return the ordered array
    */

    if (array.isEmpty) {
      return [];
    }

    int pivot = array.first;

    /// Elements smaller than the pivot
    List<int> left = [];

    /// Elements greater than the pivot
    List<int> right = [];

    for (var i = 1; i < array.length; i++) {
      if (array[i] < pivot) {
        left.add(array[i]);
      } else {
        right.add(array[i]);
      }
    }

    return [
      ...quickSort(left),
      pivot,
      ...quickSort(right),
    ];
  } */

  filter() {
    var gp = context.watch<GeneralProvider>();
    var query = gp.searchParam;

    if (_tempEmployees.isNotEmpty) {
      if (gp.menuItem == 1) {
        _tempEmployees = _tempEmployees.where((e) => e.isNew).toList();
        _filterEmployees = _tempEmployees.where((e) => e.isNew).toList();
      }
      if (query.isEmpty) {
        _filterEmployees.clear();
      } else {
        _filterEmployees = _tempEmployees
            .where((e) =>
                (e.name.toString().toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(quickSort([4, 6, 2, 9, 8, 5, 1, 3]));

    filter();
    return MultiProvider(
      providers: [
        FutureProvider<Response>(
          updateShouldNotify: (previous, current) => previous != current,
          create: (_) async => EmployeeService().getEmployees(),
        ),
      ],
      child: Container(
        color: CustomColors.blue,
        padding: Dimensions.vertical(context, .09),
        child: Column(
          children: [
            Selector<GeneralProvider, int>(
              selector: (_, gp) => gp.menuItem,
              builder: (context, item, child) => Text(
                item == 0 ? 'Employees' : 'New employees',
                style: TextStyle(
                  color: CustomColors.yellow,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height(context) * .02,
            ),
            Expanded(
              child: Selector<GeneralProvider, DragState>(
                selector: (_, gp) => gp.dragState,
                builder: (context, state, child) => AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: state == DragState.employees
                      ? Consumer<Response>(builder: (context, snapshot, child) {
                          GeneralProvider _gp = context.read<GeneralProvider>();

                          if (snapshot != null) {
                            if (!snapshot.success) {
                              return Padding(
                                padding: Dimensions.fromLTRB(
                                    context, .05, 0, .05, .8),
                                child: Text(
                                  snapshot.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                              );
                            }

                            _employees = snapshot.body;
                            _tempEmployees = [..._employees];

                            var data = _filterEmployees.isEmpty
                                ? _tempEmployees
                                : _filterEmployees;

                            sort(context, data);

                            if (_gp.selectedEmployee == null) {
                              Future.microtask(
                                  () => _gp.selectedEmployee = data.first);
                            }

                            return ListView.builder(
                              itemBuilder: (context, index) => Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: CustomColors.yellow,
                                  onTap: () {
                                    _gp.selectedEmployee = data[index];
                                    _gp.dragState = DragState.employee_detail;
                                  },
                                  child: _userItem(data[index], context),
                                ),
                              ),
                              itemCount: data.length,
                              physics: BouncingScrollPhysics(),
                            );
                          }

                          return Padding(
                            padding: Dimensions.bottom(context, .8),
                            child: CircularProgressIndicator(
                              backgroundColor: CustomColors.pink,
                              strokeWidth: 5,
                            ),
                          );
                        })
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userItem(Employee employee, BuildContext context) {
    var currency = NumberFormat.simpleCurrency().format(employee.wage);

    return Padding(
      padding: Dimensions.symetric(context, .05, .02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _photo(employee.name, context),
          Container(
            width: Dimensions.width(context) * .5,
            padding: Dimensions.left(context, .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          Container(
            width: Dimensions.width(context) * .2,
            margin: Dimensions.horizontal(context, .05),
            padding: Dimensions.symetric(context, .02, .01),
            decoration: BoxDecoration(
              color: CustomColors.yellow,
              borderRadius: Dimensions.borderRadiusContainer(10),
            ),
            child: Text(
              employee.position,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.blue,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(String name, BuildContext context) {
    var initials = name.split(' ');
    String nn = '';

    nn = initials.first.substring(0, 1) +
        (initials.length > 1 ? initials[1].substring(0, 1) : '');

    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: CustomColors.yellow,
          child: Text(
            nn.toUpperCase(),
            style: TextStyle(
              color: CustomColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
