import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/authentication.dart';
import 'forgot_password.dart';

class LoginWidget extends StatefulWidget {
  final Function(bool showLogin) onToggleLoginState;
  final Function onLoadingSubmit;
  LoginWidget({required this.onToggleLoginState, required this.onLoadingSubmit});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthenticationService();
  bool _viewPassword = false;
  bool _isEnabled = false;

  Future<void> enableChangeWidget() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isEnabled = true;
  }

  @override
  void initState() {
    super.initState();
    enableChangeWidget();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ACCEDI',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: TextFormField(
                controller: _email,
                autofillHints: const [AutofillHints.email, AutofillHints.username],
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
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        isScrollControlled: true,
                        builder: (context) => ForgotPassword(),
                      );
                    });
                  },
                  child: Text('Hai dimenticato la password?',
                      style: Theme.of(context).textTheme.labelSmall)),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.secondary),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.onLoadingSubmit();
                      await  _authService.loginAccount(
                          emailAddress: _email.text, password: _password.text);
                      widget.onLoadingSubmit();
                    }
                    setState(() {});
                  },
                  child: Text('Conferma',
                      style: Theme.of(context).textTheme.bodyMedium)),
            ),
            TextButton(
                onPressed: () async {
                  if(_isEnabled) {
                    widget.onToggleLoginState(false);
                  }
                },
                child: Text('Non hai un account? Registrati',
                    style: Theme.of(context).textTheme.labelSmall))
          ],
        ),
      ),
    );
  }
}