import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/services/authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthenticationService();
  bool _isLogin = true;
  bool _viewPassword = false;
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'ACCEDI' : 'REGISTRATI',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: TextFormField(
                  controller: _email,
                  autofillHints: const [AutofillHints.email],
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      errorStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.redAccent)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Inserisci una email valida';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _password,
                  autofillHints: const [AutofillHints.password],
                  obscureText: !_viewPassword,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      contentPadding: const EdgeInsetsDirectional.only(end: 10),
                      suffixIconColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _viewPassword = !_viewPassword;
                          });
                        },
                        icon: Icon(!_viewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.redAccent)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                width: double.infinity,
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.secondary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_isLogin) {
                          _authService.loginAccount(
                              emailAddress: _email.text,
                              password: _password.text);
                        }
                      }
                      setState(() {});
                    },
                    child: Text('Conferma',
                        style: Theme.of(context).textTheme.bodyMedium)),
              ),
              Visibility(
                visible: _isLogin,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            builder: (context) => ForgotPassword(),
                          );
                        });
                      },
                      child: Text('Hai dimenticato la password? Recupera',
                          style: Theme.of(context).textTheme.labelSmall)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                        _isLogin
                            ? 'Non hai un account? Registrati'
                            : 'Hai già un account? Accedi',
                        style: Theme.of(context).textTheme.labelSmall)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthenticationService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recupera password',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: _email,
                  autofillHints: const [AutofillHints.email],
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      errorStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.redAccent)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Inserisci una email valida';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                width: double.infinity,
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _authService.sendEmailRestPassword(
                            emailAddress: _email.text);
                        setState(() {});
                      }
                    },
                    child: Text('Invia email di recupero',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
