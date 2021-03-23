import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news_website/Bloc/CountryBloc.dart';
import 'package:news_website/Helper/ApiResponse.dart';
import 'package:news_website/Models/CountryModel.dart';
import 'package:news_website/NewsWidgets/ShowProgress.dart';
import 'package:news_website/Provider/CountryProvider.dart';
import 'package:news_website/Utils/AppColor.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../Utils/Dimen.dart';

class NavBarHeader extends StatelessWidget{
  CountryBloc _countryBloc;
  @override
  Widget build(BuildContext context) {
    _countryBloc=new CountryBloc();

    return LayoutBuilder(
      builder: (context,constraints)
      {
         bool mobile=constraints.maxWidth<600 ? true : false;
         bool mid_mobile=constraints.maxWidth<800 ? true : false;
         bool small_mobile=constraints.maxWidth<400 ? true : false;

        double _logoSize= mobile 
                            ? Dimen.logoSizeMob : Dimen.logoSizeTab; 
        double _appNameSize= mobile 
                            ? Dimen.textHeadMobile : Dimen.textHeadTab;
        double _greetingSize= mobile 
                            ? Dimen.textSubheadMobile : Dimen.textSubheadTab;
        double _timeSize= mobile 
                            ? Dimen.textsmallMobile : Dimen.textsmallTab;                                        

        return Container(
          height: _logoSize+32,
          color: AppColor.appColor,
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: _logoSize,
                      height: _logoSize,
                      alignment: Alignment.center,
                      child: Image.asset("images/fire_logo.jpg",fit: BoxFit.contain,),
                      margin: EdgeInsets.only(right: 8),
                    ),
                    SizedBox(height: 8,),
                    Flexible(
                      child: Text(
                        "TheDigitalFire",
                        style: TextStyle(
                          fontSize: _appNameSize,
                          color: AppColor.white,
                          fontWeight: FontWeight.w800,
                        ),
                        ),
                    ),
                  ],
                ),
              ),
              !small_mobile ? Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 12,left: 12,),
                      child: Icon(
                        greeting_icon(),
                        color: AppColor.white,
                        size: _appNameSize,
                        ),
                    ),
                    Flexible(
                      child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisSize: MainAxisSize.min,
                       children: [
                        Flexible(
                          child: Text(
                          greeting(),
                          style: TextStyle(
                            fontSize: _greetingSize,
                            color: AppColor.white,
                            fontWeight: FontWeight.w800,
                          ),
                          ),
                        ),
                        SizedBox(height: 2,),
                        Flexible(
                          child: Text(
                            Jiffy().yMMMMEEEEdjm .toString(),
                          style: TextStyle(
                            fontSize: _timeSize,
                            color: AppColor.backGrey,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                        ),
                       ],
                      ),
                    ),
                  ],
                ),
                ) : SizedBox(width:1,),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<ApiResponse<List<CountryModel>>>(
                      stream: _countryBloc.countryListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return Container(
                                height: 20,
                                width: 20,
                                child: ShowProgress(),
                              );
                              break;
                            case Status.COMPLETED:
                              return Consumer<CountryProvider>(
                                builder: (context, countyprovider,child) {
                                  return DropdownButton(
                                    value: countyprovider.countryModel.id,
                                    underline: null,
                                    style: TextStyle(color: AppColor.white),
                                    iconDisabledColor: AppColor.white,
                                    iconEnabledColor: AppColor.white,
                                    dropdownColor: AppColor.textBlack,
                                    items: get_drop_down_list(mid_mobile, snapshot.data.data),
                                    onChanged: (value)
                                    {
                                      countyprovider.set_country(snapshot.data.data.singleWhere((element) => element.id==value));
                                    },
                                  );
                                }
                              );
                              break;
                            case Status.ERROR:
                              return Container(
                                height: 20,
                                width: 20,
                                child: ShowProgress(),
                              );
                              break;
                          }
                        }
                        return Container();
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      );
  }

  List<DropdownMenuItem> get_drop_down_list(bool mobile,List<CountryModel> country_list)
  {
    List<DropdownMenuItem> _drop_down_list=[];
    country_list.forEach((element) {
      _drop_down_list.add(
        new DropdownMenuItem(
        child: Text(mobile?element.shortName:element.fullName),
          value: element.id,
        ),
      );
    });
    return _drop_down_list;
  }

  String greeting() {
  var hour = DateTime.now().toLocal().hour;
  if (4 < hour && hour < 12) {
    return 'Good morning,';
  }
  if (12 <= hour && hour < 17) {
    return 'Good afternoon,';
  }
  return 'Good evening,';
}

  IconData greeting_icon() {
  var hour = DateTime.now().toLocal().hour;
  if (4 < hour && hour < 12) {
    return Icons.wb_sunny_outlined;
  }
  if (12 <= hour && hour < 1) {
   return Icons.wb_sunny_rounded;
  }
  return Icons.nightlight_round;
}

}