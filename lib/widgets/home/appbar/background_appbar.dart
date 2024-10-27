import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/models/utente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/authentication.dart';
import 'button_account.dart';

class BackgroundHomeAppbar extends StatelessWidget {

  Future<String?> nicknameUtente() async {
    final prefs = await SharedPreferences.getInstance();
    String? nickname = prefs.getString("nickname") ?? "";
    return nickname;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: nicknameUtente(),
                      builder: (context, snapshot) => Text(
                            'Ciao ${snapshot.data},',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Colors.white.withOpacity(0.5)),
                            textAlign: TextAlign.left,
                          )),
                  Text(
                    'Bentornato ✨',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsetsDirectional.only(top: 5),
                  alignment: AlignmentDirectional.topEnd,
                  transformAlignment: AlignmentDirectional.topEnd,
                  child: const ButtonAccount())
            ],
          ),
        ],
      ),
    );
  }
}
