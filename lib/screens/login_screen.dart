import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/services/auth_service.dart';
import 'package:seminariovalidacion/services/services.dart';
import 'package:seminariovalidacion/widgets/widgets.dart';
import 'package:seminariovalidacion/ui/input_decorations.dart';
import 'package:seminariovalidacion/providers/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: _LoginForm(),
                  ),
                  SizedBox(height: 30),
                  CreateCuenta()
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '') ? null : 'Introduce un email valido';
                },
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(hintText: 'john.doe@gmail.com', labelText: 'Email', prefixIcon: Icons.alternate_email_sharp),
                onChanged: (value) => loginForm.email = value,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'La contraseña debe contener al menos 6 caracteres';
                  }
                  return null;
                },
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecorations.authInputDecoration(hintText: 'password', labelText: 'Password', prefixIcon: Icons.lock),
                onChanged: (value) => loginForm.password = value,
              ),
              SizedBox(height: 30),
              LoginBtn()
            ],
          )),
    );
  }
}

class LoginBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.deepPurple,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text(
            loginForm.isLoading ? 'Espere' : 'Acceder',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: loginForm.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);
                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;
                final String? errorMessage = await authService.login(loginForm.email, loginForm.password);

                if (errorMessage == null) {
                  print('done');
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  NotificationService.showSnackbar(errorMessage);
                  loginForm.isLoading = false;
                }
              });
  }
}

class CreateCuenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'registrar');
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey[300]),
      ),
      child: Text(
        'Crear una nueva cuenta',
        style: TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }
}
