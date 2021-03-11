import 'package:flutter/material.dart';
import 'package:news_website/Models/CategoryModel.dart';
import 'package:news_website/Provider/CategoryProvider.dart';
import 'package:news_website/Utils/AppColor.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../Utils/Dimen.dart';

class NavBarItem extends StatelessWidget{
  List<CategoryModel> _categoryModelList;
  IconData _image=Icons.science;
  int Index;
  bool _selected=false;
  NavBarItem(this._image,this._categoryModelList,this.Index);
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context,sizingInformation)
      {
        double _tagSize= sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                            ? Dimen.textSubheadMobile : Dimen.textSubheadTab; 
        double _borderRadius= sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                            ? Dimen.cardBorderMob/2 : Dimen.cardBorderTab/2;
        double _dotSize= sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                            ? Dimen.textBodyMobile/2 : Dimen.textBodyTab/2;                    
        return Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            _selected=categoryProvider.categoryModel.id==Index;
            return ListTile(
              onTap: (){
                categoryProvider.set_country(_categoryModelList[Index]);
               // onTabBarSelected(Index);
              },
              leading: Container(
                width: _borderRadius*4,
                height: _borderRadius*4,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  color: _selected ? AppColor.appColor : AppColor.backGrey,
                ),
                child: Icon(
                  _image,
                  color: _selected ? AppColor.backGrey : AppColor.textGrey,

                  ),
              ),
              title: Text(
                _categoryModelList[Index].fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: _tagSize,
                  color: _selected ? AppColor.textBlack : AppColor.textGrey,
                  fontWeight: _selected ? FontWeight.w700 : FontWeight.w600,
                ),
                ),
                trailing: Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selected ? AppColor.appColor : AppColor.backGrey,
                  ),
                ),
            );
          }
        );
      }
    );
  }

}