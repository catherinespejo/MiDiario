import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_login/animated_login.dart';
import '../models/models.dart';
import '../vm/usuario_vm.dart';
import 'home_page.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);

    return AnimatedLogin(
      // Login
      onLogin: (LoginData data) async {
        bool isSuccess = await usuarioVM.login(data.email, data.password);
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error de inicio de sesión', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      // Sign up
      onSignup: (SignUpData data) async {
        try {
          await usuarioVM.addUsuario(Usuario(
            nombre: data.name,
            email: data.email,
            password: data.password,
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario registrado con éxito', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al registrar usuario', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      loginMobileTheme: LoginViewTheme(
        backgroundColor: Colors.blue,
        hintTextStyle: const TextStyle(color: Colors.black),
        formTitleStyle: const TextStyle(color: Colors.black),
        welcomeTitleStyle: const TextStyle(color: Colors.white),
        welcomeDescriptionStyle: const TextStyle(color: Colors.white),
        changeActionTextStyle: const TextStyle(color: Colors.black),
        useEmailStyle: const TextStyle(color: Colors.black),
        forgotPasswordStyle: const TextStyle(color: Colors.white),
        errorTextStyle: const TextStyle(color: Colors.black),
        textFormStyle: const TextStyle(color: Colors.black),
        textFormFieldDeco: const InputDecoration(
          fillColor: Colors.white,
          filled: true,

        ),
      ),
      loginTexts: LoginTexts(
        welcome: "Bienvenido a Mi Diario",
        welcomeDescription: "El mejor lugar para guardar tus pensamientos",
        signUp: 'Registrarse',
        signUpFormTitle: 'Crea tu cuenta',
        signUpUseEmail: 'Usa tu email para registrarte',
        welcomeBack: "Bienvenido de nuevo",
        welcomeBackDescription: "Nos alegra verte de nuevo",
        login: 'Iniciar Sesión',
        loginFormTitle: 'Inicia sesión en tu cuenta',
        loginUseEmail: 'Usa tu email para iniciar sesión',
        forgotPassword: '¿Olvidaste tu contraseña?',
        notHaveAnAccount: "¿No tienes una cuenta?",
        alreadyHaveAnAccount: "¿Ya tienes una cuenta?",
        agreementText: "Al registrarte, aceptas nuestros Términos y Condiciones",
        privacyPolicyText: "Política de Privacidad",
        termsConditionsText: "Términos y Condiciones",
        nameHint: 'Ingresa tu nombre',
        signupEmailHint: 'Ingresa tu email para registrarte',
        signupPasswordHint: 'Crea una contraseña',
        loginEmailHint: 'Ingresa tu email',
        loginPasswordHint: 'Ingresa tu contraseña',
        confirmPasswordHint: 'Confirma tu contraseña',
        passwordMatchingError: 'Las contraseñas no coinciden',
        checkboxError: 'Debes aceptar los términos y condiciones',
      )

    );
  }
}
