import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
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
    DateTime now=DateTime.now().toLocal();
    DateFormat _format=new DateFormat("hh 'o''clock' a ,E ,zzzz");
    //String time_string =_format.locale.format(now);

    return LayoutBuilder(
      builder: (context,constraints)
      {
        bool mobile=constraints.maxWidth<600 ? true : false;
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
          color: AppColor.backGrey,
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _logoSize,
                    height: _logoSize,
                    alignment: Alignment.center,
                    child: Image.asset("images/fire_logo.png",fit: BoxFit.contain,),
                    margin: EdgeInsets.only(right: 8),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    "TheDigitalFire",
                    style: TextStyle(
                      fontSize: _appNameSize,
                      color: AppColor.textGrey,
                      fontWeight: FontWeight.w800,
                    ),
                    ),
                ],
              ),
              !small_mobile ? Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12,left: 12,),
                        child: Icon(
                          greeting_icon(),
                          color: AppColor.textGrey,
                          size: _appNameSize,
                          ),
                      ),
                      Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Text(
                        greeting(),
                        style: TextStyle(
                          fontSize: _greetingSize,
                          color: AppColor.textBlack,
                          fontWeight: FontWeight.w800,
                        ),
                        ),
                        SizedBox(height: 2,),
                        Container(
                          height: _timeSize,
                          child: Text(
                            now.timeZoneName,
                          style: TextStyle(
                            fontSize: _timeSize,
                            color: AppColor.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                        ),
                       ],
                      ),
                    ],
                  ),
                ),
                ) : SizedBox(width:1,),
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
                              items: get_drop_down_list(mobile, snapshot.data.data),
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
  if (hour < 12) {
    return 'Good morning,';
  }
  if (hour < 17) {
    return 'Good afternoon,';
  }
  return 'Good evening,';
}

  IconData greeting_icon() {
  var hour = DateTime.now().toLocal().hour;
  if (hour < 12) {
    return Icons.wb_sunny_outlined;
  }
  if (hour < 17) {
   return Icons.wb_sunny_rounded;
  }
  return Icons.nightlight_round;
}

}