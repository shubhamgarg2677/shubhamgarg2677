import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:news_website/NewsWidgets/NewsImage.dart';
import 'package:news_website/NewsWidgets/WebWidget.dart';
import 'package:news_website/Utils/AppColor.dart';
import 'package:news_website/Utils/Dimen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/NewsDataModel.dart';

class NewsWidgetElementHorizontal extends StatelessWidget{

  NewsDataModel _newsDataModel;
  List<CategoryModel> category_list;

  NewsWidgetElementHorizontal(this._newsDataModel,this.category_list);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints)
      {
        // double _screenWidth=constraints.maxWidth;
        // double _screenHeight=constraints.heightConstraints().maxHeight;

        bool mobile=constraints.maxWidth<600 ? true : false;
        //bool small_mobile=constraints.maxWidth<400 ? true : false;

        double _borderRadius= mobile
                          ? Dimen.cardBorderMob: Dimen.cardBorderTab;
        // double _boxHeight= mobile
        //                     ? 150 : 200;
        // double _boxWidth= mobile
        //                     ? _screenWidth*2/3 : _screenWidth/4;
        double _tagSize= mobile 
                            ? Dimen.textsmallMobile : Dimen.textSubheadTab;
        double _headlineSize= mobile 
                            ? Dimen.textSubheadMobile : Dimen.textSubheadTab;
         double _descSize= mobile 
                            ? Dimen.textBodyMobile : Dimen.textBodyTab;                                                                
        return GestureDetector(
          onTap: (){
            on_pressed(_newsDataModel,context);
          },
          child: Container(
            //height: _boxHeight,
            //width: _boxWidth,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              boxShadow: [BoxShadow(
                color: AppColor.textGrey,
                blurRadius: 5.0,
              ),],
              color: AppColor.white,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                      //width: _boxWidth/2-8,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_borderRadius),
                            color: AppColor.appColor,
                            image: DecorationImage(image: AssetImage("images/fire_logo.jpg",),)
                        ),
                        margin: EdgeInsets.only(left: 8,top: 8,bottom: 8,right: 8),
                        clipBehavior: Clip.hardEdge,
                        // child: _newsDataModel.urltoimage.isNotEmpty
                        //     ? Image.network(_newsDataModel.urltoimage,
                        //   headers:  {"Access-Control-Allow-Origin": "*"},
                        //   fit: BoxFit.cover,
                        // ) : Image.asset("images/fire_logo.png",)
                         child: get_news_image(_newsDataModel.urltoimage,_borderRadius),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(_borderRadius),
                      //   color: AppColor.backGrey,
                      //   image: DecorationImage(
                      //     image: _newsDataModel.urltoimage.isNotEmpty
                      //     ? CachedNetworkImageProvider(
                      //         _newsDataModel.urltoimage,
                      //       headers: {"Access-Control-Allow-Origin": "*"},
                      //       imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
                      //     )
                      //     : AssetImage("images/fire_logo.png",),
                      //     fit: BoxFit.cover,
                      //     ),
                      // ),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                      //width: _boxWidth/2-8,
                      padding: EdgeInsets.all(8),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        //physics: NeverScrollableScrollPhysics(),
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(height: mobile?4:12,),
                          _newsDataModel.category.toString().isNotEmpty
                          ? Text(
                            category_list.length>0 ? category_list[_newsDataModel.category.toInt()].fullName.toString() : "",
                            style: TextStyle(
                              color: AppColor.textGrey,
                              fontSize: _tagSize,
                              fontWeight: FontWeight.w200,
                            ),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            ) : SizedBox(height: 1,),
                            SizedBox(height: mobile?4:12,),
                          _newsDataModel.title.isNotEmpty
                              ? Text(
                                _newsDataModel.title,
                                style: TextStyle(
                                  color: AppColor.textBlack,
                                  fontSize: _headlineSize,
                                  fontWeight: mobile ? FontWeight.w600 : FontWeight.bold,
                                ),
                              ) : SizedBox(height: 1,),
                          SizedBox(height: mobile?4:12,),
                          _newsDataModel.description.isNotEmpty
                              ? Text(
                                "${get_description(_newsDataModel.description)}...",
                                style: TextStyle(
                                  color: AppColor.textBlack,
                                  fontSize: _descSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ) : SizedBox(height: 1,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get_news_image(String url,double _borderRadius)
  {
    try{
      if(Platform.isIOS||Platform.isAndroid)
      {
        return ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          clipBehavior: Clip.hardEdge,
          child: url.isNotEmpty
              ? Image.network(url,
            headers:  {"Access-Control-Allow-Origin": "*"},
            fit: BoxFit.cover,
          ) : Image.asset("images/fire_logo.jpg",),
        );
      }
      else
      {
        return new  NewsImage(url);
      }
    }
    catch(e)
    {
      return new NewsImage(url);
    }

  }

  on_pressed(NewsDataModel _datamodel,BuildContext context)
  async {
    try{
      if(Platform.isAndroid || Platform.isIOS)
      {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WebWidget(_datamodel)));
      }
      else
      {
        await canLaunch(_datamodel.url) ? await launch(_datamodel.url) : throw 'Could not launch ${_datamodel.url}';
      }
    } catch(e){
      await canLaunch(_datamodel.url) ? await launch(_datamodel.url) : throw 'Could not launch ${_datamodel.url}';
    }
  }

  // Widget get_image(String url, bool mobile)
  // {
  //   // return CachedNetworkImageProvider(
  //   //   url,
  //   //   headers: {"Access-Control-Allow-Origin": "*"},
  //   //   imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
  //   // );
  // }

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