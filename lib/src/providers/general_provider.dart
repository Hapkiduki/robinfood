import 'package:flutter/widgets.dart';
import 'package:robinfood/src/models/employee.dart';

enum DragState {
  employee_detail,
  employees,
}

class GeneralProvider with ChangeNotifier {

  DragState _dragState = DragState.employees;
  
  Employee _selectedEmployee;
  int _menuItem = 0;
  String _searchParam = '';
  bool _sort = false;


  bool get sort => _sort;

  set sort(bool sort) {
    this._sort = sort;
    notifyListeners();
  }

  DragState get dragState => _dragState;

  set dragState(DragState state) {
    this._dragState = state;
    notifyListeners();
  }

  Employee get selectedEmployee => _selectedEmployee;

  set selectedEmployee(Employee employee) {
    this._selectedEmployee = employee;
    notifyListeners();
  }

  int get menuItem => _menuItem;

  set menuItem(int item) {
    this._menuItem = item;
    notifyListeners();
  }

  String get searchParam => _searchParam;

  set searchParam(String value) {
    this._searchParam = value;
    notifyListeners();
  }
  
}