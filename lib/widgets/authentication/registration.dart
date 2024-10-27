import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/authentication.dart';

class RegistrationWidget extends StatefulWidget {
  final Function(bool showLogin) onToggleLoginState;
  final Function onLoadingSubmit;
  RegistrationWidget({required this.onToggleLoginState, required this.onLoadingSubmit});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nickname = TextEditingController();

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
    _nickname.dispose();
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
              'REGISTRATI',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: TextFormField(
                controller: _nickname,
                autofillHints: const [AutofillHints.nickname],
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                    labelText: 'Nickname',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    errorStyle: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.redAccent)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci un nickname';}
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
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
              padding: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.secondary),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.onLoadingSubmit();
                      await _authService.createAccount(
                          emailAddress: _email.text, password: _password.text, nickname: _nickname.text);
                      await _authService.loginAccount(
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
                    widget.onToggleLoginState(true);
                  }
                },

                child: Text('Hai già un account? Accedi',
                    style: Theme.of(context).textTheme.labelSmall))
          ],
        ),
      ),
    );
  }
}
