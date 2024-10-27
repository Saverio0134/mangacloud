import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangacloud/services/authentication.dart';

import '../widgets/authentication/login.dart';
import '../widgets/authentication/registration.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> toggleLoginState(bool showLogin) async {
    if(showLogin != _isLogin){
    setState(() {
      _isLogin = !_isLogin;
    });
    }
  }
  void loadingSubmit() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ) : Padding(
        padding: const EdgeInsets.only(left:20, right: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 300), // Durata dell'animazione

              child: _isLogin
                  ? LoginWidget(onToggleLoginState: toggleLoginState, onLoadingSubmit: loadingSubmit,)
                  : RegistrationWidget(
                      onToggleLoginState:
                          toggleLoginState, onLoadingSubmit: loadingSubmit), // Widget da mostrare in base a _isLogin
            ),
          ],
        ),
      ),
    );
  }
}
