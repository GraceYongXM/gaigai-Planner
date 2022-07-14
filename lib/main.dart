import 'package:flutter/material.dart';

import 'pages/signin_signup/login_page.dart';
import 'pages/signin_signup/signup_page.dart';
import 'webscrape.dart';
import 'services/services.dart';
//import 'location_webscrape.rmd';

Future<void> main() async {
  runApp(GaigaiPlanner());
}

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Color(0xffBB86FC),
  secondary: Color(0xff03DAC6),
  surface: Colors.white,
  background: Colors.white,
  error: Color(0xffCF6679),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.blue,
  onBackground: Colors.blue,
  onError: Color(0xff000000),
  brightness: Brightness.light,
);

class GaigaiPlanner extends StatelessWidget {
  GaigaiPlanner({Key? key}) : super(key: key);

  //model.User user;

  /*void recoverUser(context) async {
    user = await Services.of(context).authService.recoverUser() as model.User;
    setState(() {
      activityList = _activityList;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    extractData();
    //getTravelTime();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Services(
        child: MaterialApp(
          title: 'gaigaiPlanner',
          initialRoute: 'login',
          routes: {
            'login': (_) => const LoginPage(title: 'Login UI'),
            '/signup': (_) => const RegisterPage(title: 'Register UI'),
          },
          theme: ThemeData(
            colorScheme: defaultColorScheme,
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage(
            title: 'Login UI',
          ),
        ),
      ),
    );
    /*Builder(
          builder: (context) {
            return FutureBuilder<bool>(
                future: Services.of(context).authService.recoverSession(),
                builder: (context, snapshot) {
                  final sessionRecovered = snapshot.data ?? false;
                  
                  return sessionRecovered
                      ? HomePage(user: user)
                      : LoginPage(title: 'Login UI');
                });
          },*/

    //home: ActivityListPage(),
    //debugShowCheckedModeBanner: false,
  }
}
