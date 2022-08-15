import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_plus/data/layer.dart';

import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/modules/colors_picker.dart';

class TextEditorPro extends StatefulWidget {
  final Uint8List image;
  const TextEditorPro({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<TextEditorPro> createState() => _TextEditorProState();
}

class _TextEditorProState extends State<TextEditorPro> {
  TextEditingController name = TextEditingController();
  Uint8List get _image => widget.image;
  Color currentColor = Colors.white;
  TextAlign align = TextAlign.left;
  double slider = 32.0;

  @override
  void initState() {
    name.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: ImageEditor.theme,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.alignLeft,
                  color: align == TextAlign.left
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.left;
                });
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.alignCenter,
                  color: align == TextAlign.center
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.center;
                });
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.alignRight,
                  color: align == TextAlign.right
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.right;
                });
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            Image.memory(_image),
            SizedBox(
              height: size.height / 2.2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                ),
                child: TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Insert Your Message',
                    hintStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: const EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: 99999,
                  style: TextStyle(
                    fontSize: slider,
                    color: currentColor,
                  ),
                  autofocus: true,
                ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        child: Text("Adjust size"),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: slider,
                        min: 0.0,
                        max: 100.0,
                        onChangeEnd: (v) {
                          setState(() {
                            slider = v;
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            slider = v;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 5,
                        ),
                        child: BarColorPicker(
                          width: size.width * 0.87,
                          thumbColor: Colors.white,
                          cornerRadius: 10,
                          colorListener: (int value) {
                            setState(() {
                              currentColor = Color(value);
                            });
                          },
                        ),
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
                          onPressed: () {
                            Navigator.pop(
                              context,
                              TextLayerData(
                                background: Colors.transparent,
                                text: name.text,
                                color: currentColor,
                                size: slider.toDouble(),
                                align: align,
                              ),
                            );
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
