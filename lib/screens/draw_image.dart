import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hand_signature/signature.dart';
import 'package:image_editor_plus/data/image_item.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class DrawImageEditor extends StatefulWidget {
  final Uint8List image;
  const DrawImageEditor({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<DrawImageEditor> createState() => _DrawImageEditorState();
}

class _DrawImageEditorState extends State<DrawImageEditor> {
  Uint8List get _image => widget.image;
  ImageItem image = ImageItem();

  Color pickerColor = Colors.white;
  Color currentColor = Colors.white;

  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  List<CubicPath> undoList = [];
  bool skipNextEvent = false;

  List<Color> colorList = [
    Colors.black,
    Colors.white,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.purple,
    Colors.brown,
    Colors.indigo,
    Colors.indigo,
  ];

  void changeColor(Color color) {
    currentColor = color;
    setState(() {});
  }

  @override
  void initState() {
    image.load(widget.image);
    control.addListener(() {
      if (control.hasActivePath) return;

      if (skipNextEvent) {
        skipNextEvent = false;
        return;
      }

      undoList = [];
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: ImageEditor.theme,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            Image.memory(_image),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: currentColor == Colors.black ? Colors.white.withAlpha(80) : Colors.black.withAlpha(80),
              child: HandSignature(
                control: control,
                color: currentColor,
                width: 1.0,
                maxWidth: 10.0,
                type: SignatureDrawType.shape,
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: kBottomNavigationBarHeight * 3,
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ColorButton(
                        color: Colors.yellow,
                        onTap: (color) {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return Container(
                                color: Colors.black87,
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: HueRingPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      for (int i = 0; i < colorList.length; i++)
                        ColorButton(
                          color: colorList[i],
                          onTap: (color) => changeColor(color),
                          isSelected: colorList[i] == currentColor,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFF0F0F0),
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Color(0xFFF0F0F0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox.shrink(),
                              const Text(
                                "TEXT",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE9E8ED),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(7),
                                child: const Icon(
                                  Icons.text_fields_outlined,
                                  color: Colors.black87,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 0,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff34C781),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.done,
                              size: 20,
                              color: Color(0xFFF0F0F0),
                            ),
                          ),
                          onPressed: () async {
                            if (control.paths.isEmpty) {
                              Navigator.pop(context);
                            } else {
                              var data = await control.toImage(
                                color: currentColor,
                              );
                              Uint8List result = data!.buffer.asUint8List();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(
                                context,
                                result,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
