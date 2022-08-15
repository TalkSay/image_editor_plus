import 'dart:typed_data';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:colorfilter_generator/presets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:screenshot/screenshot.dart';

/// Return filter applied Uint8List image
class ImageFilters extends StatefulWidget {
  final Uint8List image;

  /// apply each filter to given image in background and cache it to improve UX
  final bool useCache;

  const ImageFilters({
    Key? key,
    required this.image,
    this.useCache = true,
  }) : super(key: key);

  @override
  _ImageFiltersState createState() => _ImageFiltersState();
}

class _ImageFiltersState extends State<ImageFilters> {
  late img.Image decodedImage;
  ColorFilterGenerator selectedFilter = PresetFilters.none;
  Uint8List resizedImage = Uint8List.fromList([]);
  double filterOpacity = 1;
  Uint8List filterAppliedImage = Uint8List.fromList([]);
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // decodedImage = img.decodeImage(widget.image)!;
    // resizedImage = img.copyResize(decodedImage, height: 64).getBytes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ImageEditor.theme,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Center(
          child: Screenshot(
            controller: screenshotController,
            child: Stack(
              children: [
                Image.memory(
                  widget.image,
                  fit: BoxFit.cover,
                ),
                FilterAppliedImage(
                  image: widget.image,
                  filter: selectedFilter,
                  fit: BoxFit.cover,
                  opacity: filterOpacity,
                  onProcess: (img) {
                    // print('processing done');
                    filterAppliedImage = img;
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: kBottomNavigationBarHeight * 2.5,
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (int i = 0; i < presetFiltersList.length; i++)
                        filterPreviewButton(
                          filter: presetFiltersList[i],
                          name: presetFiltersList[i].name,
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
                                "FILTERS",
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
                                  Icons.palette,
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
                            Navigator.pop(context, filterAppliedImage);
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

  Widget filterPreviewButton({required filter, required String name}) {
    return Column(
      children: [
        Container(
          height: 57,
          width: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: FilterAppliedImage(
            image: widget.image,
            filter: filter,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          i18n(name),
          style: const TextStyle(fontSize: 10),
        ),
      ],
    ).onTap(() {
      selectedFilter = filter;
      setState(() {});
    });
  }
}
