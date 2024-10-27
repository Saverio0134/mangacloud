import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangacloud/services/authentication.dart';
import 'package:mangacloud/services/notifiche.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _checkNotificaNewManga = false;
  bool _checkNotificaNewCapitolo = false;
  final NotificheService _notificheService = NotificheService();
  @override
  void initState() {
    super.initState();
    checkTopic();

  }

  checkTopic()async{
    _checkNotificaNewManga = await _notificheService.isSubscribedToTopic('manga');
    _checkNotificaNewCapitolo = await _notificheService.isSubscribedToTopic('capitolo');
    setState(() {
    });
  }

  editPreference(bool? value, String topic)async{
    if(value == null) {
      return;
    } else if(value){
      await _notificheService.subscribeToTopic(topic);
    }
    else {
      await _notificheService.unSubscribeFromTopic(topic);
    }
    await checkTopic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 40, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text('Gestisci le notifiche'),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                      value: _checkNotificaNewManga,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Nuovo manga', style: Theme.of(context).textTheme.labelLarge,),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.white,
                      onChanged: (bool? value) async {
                        editPreference(value, 'manga');
                      }),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                      value: _checkNotificaNewCapitolo,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Nuovo capitolo',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: Text('(i tuoi preferiti)', style: Theme.of(context).textTheme.labelSmall),
                      activeColor: Colors.white,
                      onChanged: (bool? value) async {
                        editPreference(value, 'capitolo');
                      }),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.tertiary,
              thickness: 2,
              indent: 5,
              endIndent: 5
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                AuthenticationService().logoutAccount();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.error,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Esci', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
