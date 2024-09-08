import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Services/Asset_Manager.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';

import '../Widgets/Title_Text.dart';

class MyAppFunction
{
  static Future<void> showErrororWarnig({required BuildContext context,required String subTitel,bool isError = true,required Function fct}) async
  {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isError?Image.asset('${AssetManager.imgPath}/O1.png',height: 60,width: 60,):Image.asset('${AssetManager.imgPath}/O1.png',height: 60,width: 60,),
            SizedBox(height: 16,),
            SubtitleTextWidget(label: subTitel,fontWeight: FontWeight.w600,),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !isError,
                  child: TextButton(
                      onPressed: (){Navigator.pop(context);},
                      child: SubtitleTextWidget(
                          label: "Cancel",
                          color: Colors.white
                      )
                  ),
                ),
                TextButton(
                    onPressed: (){
                      fct();
                      Navigator.pop(context);
                      },
                    child: SubtitleTextWidget(
                        label: "Ok",
                        color: Colors.deepOrange
                    )
                ),
              ],
            )
          ],
        ),
      );
    });
  }
  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitleTextWidget(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      cameraFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      galleryFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.browse_gallery,
                    ),
                    label: const Text("Gallery"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      removeFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                    label: const Text("Remove"),
                  ),
                ],
              ),
            ),
          );
        });
  }


}