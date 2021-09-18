import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';

void main() {
  runApp(MyApp());
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

  void imglyEditor(image) async {
    await PESDK.openEditor(image: image);
  }

  imgFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imglyEditor(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PhotoEditor SDK Example'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () => imgFromGallery(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Click to open photo editor"), Icon(Icons.edit)],
            ),
          ),
        ),
      ),
    );
  }
}