import 'package:http/http.dart' as http;

import 'package:robinfood/src/models/employee.dart';
import 'package:robinfood/src/models/response.dart';

class EmployeeService {
  final String _url =
      'https://raw.githubusercontent.com/sapardo10/content/master/RH.json';

  Future<Response> getEmployees() async {
    Response _response;
    var result = await http.get(_url);

    switch (result.statusCode) {
      case 400:
        _response = Response(
          success: false,
          message:
              'No se encontraron datos de los empleados, por favor intente mas tarde.',
        );
        break;
      case 500:
        _response = Response(
          success: false,
          message:
              'ocurrió un error al tratar de cargar los datos, por favor intente mas tarde.',
        );
        break;
      case 200:
        final employee = employeeFromJson(result.body);
        _response = Response(
          success: true,
          body: employee,
        );
        break;
      default:
        _response = Response(
          success: false,
          message:
              'Ha ocurrido un error inesperado, por favor intente mas tarde.',
        );
    }

    return _response;
  }
}
