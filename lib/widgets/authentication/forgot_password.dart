import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/authentication.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthenticationService();
  bool _disableSubmit = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220 + MediaQuery.of(context).viewInsets.bottom,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(_disableSubmit ? 0.5 : 1)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          !_disableSubmit) {
                        setState(() {
                          _disableSubmit = true;
                        });

                        await _authService.sendEmailRestPassword(
                            emailAddress: _email.text);
                        Navigator.pop(context);
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