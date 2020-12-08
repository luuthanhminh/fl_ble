
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n7bluetooth/services/dynamic_size.dart';
import 'package:n7bluetooth/utils/app_asset.dart';
import 'package:n7bluetooth/utils/app_color.dart';
import 'package:n7bluetooth/utils/app_constant.dart';
import 'package:n7bluetooth/utils/app_extension.dart';
import 'package:n7bluetooth/utils/app_style.dart';


class SelectDevicesPage extends StatefulWidget {
  @override
  _SelectDevicesPageState createState() => _SelectDevicesPageState();
}

class _SelectDevicesPageState extends State<SelectDevicesPage> with DynamicSize {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Init screen dynamic size
    initDynamicSize(context);

    return Material(
      child: Container(
        color: AppColors.mainBackgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 61.H,),
            Center(
              child: Text('Devices', style: normalTextStyle(50.SP, color: Colors.white),),
            ),
            SizedBox(height: 10.H,),
            Center(
              child: Text('Choose your Connected Devices', style: normalTextStyle(14.SP, color: const Color(0xFF6E737E)),),
            ),
            SizedBox(height: 40.H,),
            Container(
              margin: EdgeInsets.only(left: 30.W, right: 30.W),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 150.W,
                      height: 150.W,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4B4E51),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 15.H),
                          Container(
                            width: 90.W,
                            height: 90.W,
                            child: Image.asset(AppImages.icElectricScale),
                          ),
                          SizedBox(height: 5.H),
                          Text('Smart Scale', style: normalTextStyle(14.SP, color: Colors.white),)
                        ],
                      ),
                    ),
                      onTap: () {

                        Navigator.pushNamed(context, AppConstant.scanningDevicesPageRoute);
                      }
                  ),
                  Container(
                    width: 150.W,
                    height: 150.W,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4B4E51),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 15.H),
                          Container(
                            width: 90.W,
                            height: 90.W,
                            child: Image.asset(AppImages.icWatch),
                          ),
                          SizedBox(height: 5.H),
                          Text('Smart Watch', style: normalTextStyle(14.SP, color: Colors.white),)
                        ],
                      )
                  )
                ],
              ),
            ),
            SizedBox(height: 20.H,),
            Container(
              margin: EdgeInsets.only(left: 30.W, right: 30.W),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 150.W,
                    height: 150.W,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4B4E51),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15.H),
                        Container(
                          width: 90.W,
                          height: 90.W,
                          child: Image.asset(AppImages.icIpad),
                        ),
                        SizedBox(height: 5.H),
                        Text('IPad', style: normalTextStyle(14.SP, color: Colors.white),)
                      ],
                    ),
                  ),
                  Container(
                      width: 150.W,
                      height: 150.W,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4B4E51),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 15.H),
                          Container(
                            width: 90.W,
                            height: 90.W,
                            child: Image.asset(AppImages.icIphone),
                          ),
                          SizedBox(height: 5.H),
                          Text('IPhone', style: normalTextStyle(14.SP, color: Colors.white),)
                        ],
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
