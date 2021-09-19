import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';

void main() {
  runApp(MaterialApp(
    title: "App",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //imgly_sdk configurations
  Configuration createConfiguration() {
    /// You can add your own custom stickers.
    final flutterSticker = Sticker(
        "example_sticker_logos_flutter", "Flutter", "assets/Flutter-logo.png");

    /// A completely custom category.
    final logos = StickerCategory(
        "example_sticker_category_logos", "Logos", "assets/Flutter-logo.png",
        items: [flutterSticker]);

    /// A predefined category.
    final emoticons =
        StickerCategory.existing("imgly_sticker_category_emoticons");

    /// A customized predefined category.
    final shapes =
        StickerCategory.existing("imgly_sticker_category_shapes", items: [
      Sticker.existing("imgly_sticker_shapes_badge_01"),
      Sticker.existing("imgly_sticker_shapes_arrow_02")
    ]);
    final categories = <StickerCategory>[logos, emoticons, shapes];
    final configuration = Configuration(
        sticker:
            StickerOptions(personalStickers: true, categories: categories));
    return configuration;
  }

  imgFromGallery(bool openWithConfig) async {
    final _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        imglyEditor(_image.path, openWithConfig);
      });
    }
  }

  imglyEditor(image, config) async {
    if(config == true) {
      await PESDK.openEditor(image: image, configuration: createConfiguration());
    }else{
      await PESDK.openEditor(image: image);
    }
  }

   optionDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Info',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 6.0),
              Icon(
                CupertinoIcons.info,
                color: Colors.grey,
              )
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              'Do you want to open photo editor with configurations?',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: (){
                imgFromGallery(true);
                Navigator.pop(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.green.withAlpha(250)),
              ),
            ),
            CupertinoDialogAction(
              onPressed: (){
                imgFromGallery(false);
                Navigator.pop(context);
              } ,
              child: Text(
                'No',
                style: TextStyle(color: Colors.red.withAlpha(250)),
              ),
            ),
            CupertinoDialogAction(
              onPressed: (){
                Navigator.pop(context);
              } ,
              child: Text(
                'Close dialog',
                style: TextStyle(color: Colors.black.withAlpha(250)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoEditor SDK Example'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => optionDialog(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Click to open photo editor"),
              Icon(Icons.edit)],
          ),
        ),
      ),
    );
  }
}