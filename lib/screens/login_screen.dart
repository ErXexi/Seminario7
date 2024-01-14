import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(hintText: 'password', labelText: 'Password', prefixIcon: Icons.lock),
                onChanged: (value) => loginForm.email = value,
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
                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                await Future.delayed(Duration(seconds: 2));

                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, 'home');
              });
  }
}

class CreateCuenta extends StatelessWidget {
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
            'Registrar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'registrar');
        });
  }
}
