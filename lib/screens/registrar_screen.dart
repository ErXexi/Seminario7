import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminariovalidacion/providers/provider.dart';
import 'package:seminariovalidacion/providers/register_form_provider.dart';
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
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'John',
                labelText: 'Nombre',
                prefixIcon: Icons.person,
              ),
              onChanged: (value) {
                registerForm.nombres = value;
              },
            ),
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Doe',
                labelText: 'Apellidos',
                prefixIcon: Icons.person,
              ),
              onChanged: (value) {
                registerForm.apellidos = value;
              },
            ),
            TextFormField(
                validator: (value) {
                  if (value == null || value.length < 9) {
                    return 'El numero debe contener 9 numeros';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Teléfono',
                  labelText: 'Teléfono',
                  prefixIcon: Icons.phone,
                ),
                onChanged: (value) {
                  registerForm.telefono = value;
                }),
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
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                'Fecha nacimiento',
                style: TextStyle(fontSize: 16),
              ),
              trailing: Text(
                registerForm.fechaNacimiento != null ? DateFormat('dd/MM/yyyy').format(registerForm.fechaNacimiento!) : '',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  registerForm.fechaNacimiento = pickedDate;
                }
              },
            ),
            DropdownButton<String>(
              value: registerForm.sexo,
              items: ['Masculino', 'Femenino', 'Otro', 'Helicóptero de combate apache', 'Selecciona sexo'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  registerForm.sexo = newValue;
                }
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
              if (!registerForm.isValidForm()) return;

              registerForm.isLoading = true;

              // Simulación de un registro exitoso con un retraso de 2 segundos
              await Future.delayed(Duration(seconds: 2));

              registerForm.isLoading = false;

              Navigator.pushReplacementNamed(context, 'home');
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
