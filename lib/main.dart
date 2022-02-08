import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/session_cubit.dart';
import 'amplifyconfiguration.dart';
import 'app_navigator.dart';
import 'auth/auth_repo.dart';
import 'loading_view.dart';


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp ({Key? key}) : super (key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();

    _configureAmplify();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',

      theme: ThemeData(
          sliderTheme: const SliderThemeData(
              thumbColor: Colors.green,
              activeTrackColor: Colors.green,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
              trackHeight: 20),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent)
      ),

      home: _isAmplifyConfigured
          ? RepositoryProvider(
        create: (context) => AuthRepo(),
           child: BlocProvider(
          create: (BuildContext context) =>
              SessionCubit(authRepo: context.read<AuthRepo>()),
                  child: const AppNavigator(),
        ),
      )
          : const LoadingView(),

    );
  }

  Future<void> _configureAmplify() async {
    try {
      AmplifyStorageS3 storage = AmplifyStorageS3();
      AmplifyAuthCognito auth = AmplifyAuthCognito();
      Amplify.addPlugins([auth, storage]);

      await Amplify.configure(amplifyconfig);

      setState(() => _isAmplifyConfigured = true);
    } catch (e) {
      print(e);
    }
  }
}