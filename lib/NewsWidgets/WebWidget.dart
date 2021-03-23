import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:news_website/Models/NewsDataModel.dart';
import 'package:news_website/NewsWidgets/ShowProgress.dart';
import 'package:news_website/Utils/AppColor.dart';

class WebWidget extends StatefulWidget {
  NewsDataModel _newsDataModel;

  WebWidget(this._newsDataModel);

  @override
  _WebWidgetState createState() => _WebWidgetState();
}

class _WebWidgetState extends State<WebWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget._newsDataModel.url);
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: AppColor.appColor,
    //     title: Text(
    //       widget._newsDataModel.title,
    //       maxLines: 1,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //   ),
    //     body: Container(
    //       child: Column(
    //         children: [
    //           Expanded(
    //             child: WebView(
    //               initialUrl: widget._newsDataModel.url,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               onProgress: (value){
    //                 value_progess=value;
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    // );
    return WebviewScaffold(
      url: widget._newsDataModel.url,
      withZoom: false,
     withLocalStorage: true,
      withJavascript: true,
      appCacheEnabled: true,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          widget._newsDataModel.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
