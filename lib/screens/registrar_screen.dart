import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/providers/provider.dart';
import 'package:seminariovalidacion/providers/register_form_provider.dart';
import 'package:seminariovalidacion/services/auth_service.dart';
import 'package:seminariovalidacion/services/services.dart';
import 'package:seminariovalidacion/ui/input_decorations.dart';
import 'package:seminariovalidacion/widgets/widgets.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Registro',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: RegisterForm(),
                    ),
                    SizedBox(height: 30),
                    IniciarCuenta(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Introduce un email válido';
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Correo electrónico',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.email,
              ),
              onChanged: (value) {
                registerForm.email = value;
              },
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'La contraseña debe tener al menos 6 carácteres';
                }
                return null;
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Contraseña',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock,
              ),
              onChanged: (value) {
                registerForm.password = value;
              },
            ),
            SizedBox(height: 30),
            RegisterBtn(),
          ],
        ),
      ),
    );
  }
}

class RegisterBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          registerForm.isLoading ? 'Espere' : 'Registrarse',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: registerForm.isLoading
          ? null
          : () async {
              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthService>(context, listen: false);
              if (!registerForm.isValidForm()) return;
              final String? errorMessage = await authService.createUser(registerForm.email, registerForm.password);

              if (errorMessage == null) {
                print('done');
                Navigator.restorablePushReplacementNamed(context, 'home');
              } else {
                NotificationService.showSnackbar(errorMessage);
                registerForm.isLoading = false;
              }
            },
    );
  }
}

class IniciarCuenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.deepPurple,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    );
  }
}
