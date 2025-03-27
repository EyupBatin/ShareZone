import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GallerySliderScreen extends StatefulWidget {
  final Function(File) onImageSelected; // Callback function

  const GallerySliderScreen({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  _GallerySliderScreenState createState() => _GallerySliderScreenState();
}

class _GallerySliderScreenState extends State<GallerySliderScreen> {
  List<AssetEntity> _galleryImages = [];
  int _currentPage = 0;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  /// 📌 Galeri erişim izni al ve fotoğrafları yükle
  Future<void> _loadGalleryImages() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final albums =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isNotEmpty) {
        final recentAlbum = albums.first;
        final images =
            await recentAlbum.getAssetListPaged(page: _currentPage, size:12 );
        setState(() {
          _galleryImages.addAll(images);
        });
      }
    } else {
      // Kullanıcı izin vermezse ayarlara yönlendir
      PhotoManager.openSetting();
    }
  }

  /// 📌 Yeni fotoğrafları kaydırdıkça yükle
  Future<void> _loadMoreImages() async {
    if (_currentPage >= _lastPage) return;
    _currentPage++;
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isNotEmpty) {
      final recentAlbum = albums.first;
      final images =
          await recentAlbum.getAssetListPaged(page: _currentPage, size: 12);
      setState(() {
        _galleryImages.addAll(images);
      });
    }
  }

  Future<void> _selectImage(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null) {
      widget.onImageSelected(file); // Pass the selected image to PostScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return _galleryImages.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              CarouselSlider.builder(
                itemCount: (_galleryImages.length / 4).ceil(),
                options: CarouselOptions(
                  height: 220,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    if (index == (_galleryImages.length / 4).ceil() - 1) {
                      _loadMoreImages(); // 📌 Son slayta gelince yeni fotoğrafları yükle
                    }
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  int startIndex = index * 4;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (i) {
                        int imageIndex = startIndex + i;
                        if (imageIndex < _galleryImages.length) {
                          return Flexible(
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () =>
                                  _selectImage(_galleryImages[imageIndex]),
                              child: FutureBuilder<Uint8List?>(
                                future: _galleryImages[imageIndex]
                                    .thumbnailDataWithSize(
                                  const ThumbnailSize(
                                      300, 300), // 📌 Thumbnail boyutu
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.memory(
                                        fit: BoxFit.cover,
                                        // 📌 Fotoğrafları eşit boyutta göster
                                        alignment: Alignment.center,
                                        snapshot.data!,
                                        width: 200,
                                        height: 200,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.grey[300],
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          return const Spacer();
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          );
  }
}
