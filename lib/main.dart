import 'package:flutter/material.dart';
import 'HomePage/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}



// Platform.isAndroid || Platform.isIOS
// ? WebView(
// initialUrl: url,
// javascriptMode: JavascriptMode.unrestricted,
// navigationDelegate: (NavigationRequest request) {
// if (_firstnavigate) {
// _firstnavigate = false;
// return NavigationDecision.navigate;
// } else {
// launch(request.url);
// return NavigationDecision.prevent;
// }
// },
// ) : ElevatedButton(
// onPressed: () => launchURL(url),
// child: Text('Go to Website'),
// )
