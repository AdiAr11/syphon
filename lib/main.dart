import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';

// Library Implimentations
import 'package:Tether/global/libs/hive.dart';

// Redux - State Managment - "store" - IMPORT ONLY ONCE
import 'package:Tether/domain/index.dart';

// Intro
import 'package:Tether/views/login.dart';
import 'package:Tether/views/signup/index.dart';
import 'package:Tether/views/homesearch.dart';
import 'package:Tether/views/intro/index.dart';
import 'package:Tether/views/loading.dart';

// Home
import 'package:Tether/views/home/index.dart';
import 'package:Tether/views/home/settings.dart';

// Chat
import 'package:Tether/views/chats/index.dart';

// Styling
import 'package:Tether/global/themes.dart';
import 'package:redux/redux.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  await DotEnv().load(kReleaseMode ? '.env' : '.env.debug');
  _enablePlatformOverrideForDesktop();
  final store = await initStore();
  runApp(Tether(store: store));
}

class Tether extends StatefulWidget {
  final Store<AppState> store;
  const Tether({Key key, this.store}) : super(key: key);

  @override
  TetherState createState() => TetherState(store: store);
}

class TetherState extends State<Tether> with WidgetsBindingObserver {
  final Store<AppState> store;

  TetherState({this.store});

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // TODO: REMOVE WHEN DEPLOYED
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  @override
  void deactivate() {
    closeStorage();
    WidgetsBinding.instance.removeObserver(this);
    super.deactivate();
  }

  // Store should not need to be passed to a widget to affect
  // lifecycle widget functions
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: StoreConnector<AppState, dynamic>(
            converter: (store) => store.state.settingsStore.theme,
            builder: (context, theme) {
              return MaterialApp(
                title: 'Tether',
                theme: Themes.getThemeFromKey(theme),
                initialRoute: '/intro',
                routes: <String, WidgetBuilder>{
                  '/intro': (BuildContext context) =>
                      IntroScreen(title: 'Intro'),
                  '/login': (BuildContext context) => Login(title: 'Login'),
                  '/search_home': (BuildContext context) =>
                      HomeSearch(title: 'Find Your Homeserver', store: store),
                  '/signup': (BuildContext context) =>
                      Signup(title: 'Signup', store: store),
                  '/home': (BuildContext context) => Home(
                        title: 'Tether',
                      ),
                  '/chats': (BuildContext context) => Chats(),
                  '/settings': (BuildContext context) =>
                      SettingsScreen(title: 'Settings'),
                  '/loading': (BuildContext context) =>
                      Loading(title: 'Loading'),
                },
              );
            }));
  }
}
