import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String _nombres = '';
  String _apellidos = '';
  String _email = '';
  String _password = '';
  String _telefono = '';
  DateTime? _fechaNacimiento;
  String _sexo = 'Selecciona sexo';

  bool _isLoading = false;

  String get nombres => _nombres;
  String get apellidos => _apellidos;
  String get email => _email;
  String get password => _password;
  String get telefono => telefono;
  DateTime? get fechaNacimiento => _fechaNacimiento;
  String get sexo => _sexo;

  bool get isLoading => _isLoading;

  set nombres(String value) {
    _nombres = value;
    notifyListeners();
  }

  set apellidos(String value) {
    _apellidos = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set telefono(String value) {
    _telefono = value;
    notifyListeners();
  }

  set fechaNacimiento(DateTime? value) {
    _fechaNacimiento = value;
    notifyListeners();
  }

  set sexo(String value) {
    _sexo = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
