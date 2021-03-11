import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:news_website/NewsWidgets/WebWidget.dart';
import 'package:news_website/Utils/Dimen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/NewsDataModel.dart';
import '../Utils/AppColor.dart';

class NewsWidgetElementColumn extends StatelessWidget{
  
  NewsDataModel _newsDataModel;
  List<CategoryModel> category_list;

  NewsWidgetElementColumn(this._newsDataModel,this.category_list);

  // var corsHeaders = {
  //   "Access-Control-Allow-Origin": "*",
  //   "Access-Control-Allow-Methods": "GET,HEAD,POST,OPTIONS",
  //   "Access-Control-Max-Age": "86400",
  // };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints)
      {
        // double _screenWidth=constraints.maxWidth;
        // double _screenHeight=constraints.heightConstraints().maxHeight;

        bool mobile=constraints.maxWidth<300 ? true : false;
        //bool small_mobile=constraints.maxWidth<400 ? true : false;

        double _borderRadius= mobile ? Dimen.cardBorderMob: Dimen.cardBorderTab;

        // double _boxHeight= mobile
        //                     ? _screenHeight/3 : _screenHeight/4;
        // double _boxWidth= mobile
        //                     ? _screenWidth/2 : _screenWidth/5;

        double _tagSize = mobile ? Dimen.textsmallMobile : Dimen.textSubheadTab;
        double _headlineSize = mobile ? Dimen.textSubheadMobile : Dimen.textSubheadTab;
        double _descSize = mobile ? Dimen.textBodyMobile : Dimen.textBodyTab;

        print("--- $mobile");

         return GestureDetector(
           onTap: (){
             on_pressed(_newsDataModel,context);
           },
           child: Container(
            //  width: _boxWidth,
             height: 300,
             margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                boxShadow: [BoxShadow(
                color: AppColor.textGrey,
                blurRadius: 5.0,
              ),],
              color: AppColor.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: mobile ? 2 : 1,
                    child: Container(
                    //height: _boxWidth/2-8,
                    //width: _boxWidth/2-8,
                    padding: EdgeInsets.only(left: 8,right: 8,top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      color: AppColor.backGrey,
                      image: DecorationImage(
                        image: _newsDataModel.urltoimage.isNotEmpty
                        ? CachedNetworkImageProvider(
                            _newsDataModel.urltoimage,
                          imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
                        )
                        : AssetImage("images/fire_logo.png",),
                        fit: BoxFit.fill
                        ),
                    ),
                ),
                  ),
                  Expanded(
                    flex: mobile ? 3 : 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           SizedBox(height: 8,),
                          _newsDataModel.category.toString().isNotEmpty
                          ?  Text(
                            category_list.length>0 ? category_list[_newsDataModel.category.toInt()].fullName.toString() : "",
                      style: TextStyle(
                        color: AppColor.textGrey,
                        fontSize: _tagSize,
                        fontWeight: FontWeight.w200,
                      ),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    )
                          : SizedBox(height: 1,),
                            SizedBox(height: mobile?4:12,),
                          _newsDataModel.title.isNotEmpty
                           ? Text(
                            _newsDataModel.title,
                            style: TextStyle(
                              color: AppColor.textBlack,
                              fontSize: _headlineSize,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ) : SizedBox(height: 1,),
                            SizedBox(height: mobile?4:12,),
                          _newsDataModel.description.isNotEmpty
                           ? Expanded(
                             child: Text(
                              "${get_description(_newsDataModel.description)}...",
                              style: TextStyle(
                                color: AppColor.textBlack,
                                fontSize: _descSize,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              ),
                           )
                           : SizedBox(height: 1,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
           ),
         );                   
      },
    );
  }

  on_pressed(NewsDataModel _datamodel, BuildContext context)
  async {

    if(Platform.isAndroid || Platform.isIOS)
    {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WebWidget(_datamodel)));
      // WebView(
      //   initialUrl: url,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   navigationDelegate: (NavigationRequest request) {
      //     if (_firstnavigate) {
      //       _firstnavigate = false;
      //       return NavigationDecision.navigate;
      //     } else {
      //       launch(request.url);
      //       return NavigationDecision.prevent;
      //     }
      //   },
      // );
    }
    else
      {
        await canLaunch(_datamodel.url) ? await launch(_datamodel.url) : throw 'Could not launch ${_datamodel.url}';
      }
    // Platform.isAndroid || Platform.isIOS
    //     ?  : ElevatedButton(
    //   onPressed: () => launchURL(url),
    //   child: Text('Go to Website'),
    // )
    // return
  }

  String get_description(String description)
  {
    if(description.length>200)
    {
      return description.substring(0,195);
    }
    else if(description.length>170)
    {
      return description.substring(0,165);
    }
    else if(description.length>140)
    {
      return description.substring(0,135);
    }
    else if(description.length>110)
    {
      return description.substring(0,105);
    }
    else if(description.length>80)
    {
      return description.substring(0,75);
    }
    else if(description.length>60)
    {
      return description.substring(0,55);
    }
    else if(description.length>30)
    {
      return description.substring(0,25);
    }
    else if(description.length>10)
    {
      return description.substring(0,5);
    }
  }

}