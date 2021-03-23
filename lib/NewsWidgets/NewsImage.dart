import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:news_website/Utils/AppColor.dart';

class NewsImage extends StatelessWidget {
  String url;
  NewsImage(this.url);
  @override
  Widget build(BuildContext context) {

    // String style="border:0px #ffffff none;";
    // String scrolling="no";
    // String border="0";
    // String margin_width="";
    // String margin_height="";
    // String width="";
    // String height="";
    //
    // print("here is the url == $url");
    // print("here is the width == ${MediaQuery.of(context).size.width}");
    // print("here is the height == ${MediaQuery.of(context).size.height}");


    // IFrameElement iFrameElement=new IFrameElement();
    // iFrameElement.src=url;
    // iFrameElement.width="100%";
    // iFrameElement.height="100%";
    // //iFrameElement.height='${MediaQuery.of(context).size.height}';
    // iFrameElement.draggable=false;
    // iFrameElement.allowFullscreen=true;
    // // iFrameElement.style.resize="both";
    // iFrameElement.style.border = 'none';
    // // iFrameElement.style.width = '200';
    // // iFrameElement.style.height = '200';
    // iFrameElement.style.position="relative";
    // // iFrameElement.style.backgroundSize= "cover";
    // // iFrameElement.style.backgroundPosition= "center";
    // // iFrameElement.style.backgroundRepeat= "no-repeat";
    // iFrameElement.style.zoom="1";
    // iFrameElement.style.userZoom="zoom";
    // iFrameElement.translate=true;
    // //iFrameElement.style.transform="0.5";
    // // iFrameElement.style.size = '200';

    ImageElement imageElement = new ImageElement();
    imageElement.src=url;

    DivElement divElement=new DivElement();
    divElement.style.background = "url('$url')";
    divElement.style.backgroundPosition = "center";
    divElement.style.backgroundRepeat= "no-repeat";
    divElement.style.backgroundSize= "cover";



    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory( url,
           (int viewId) => divElement);



    // ui.platformViewRegistry.registerViewFactory(
    //     'hello-world-html',
    //         (int viewId) => IFrameElement()
    //       ..width = '640'
    //       ..height = '360'
    //       ..src = 'https://www.youtube.com/embed/IyFZznAk69U'
    //       ..style.border = 'none');

    return Container(
      // width: 200,
      //   height: 200,
        child: url.isNotEmpty? HtmlElementView(viewType: url): SizedBox(width: 1,));
  }
}
