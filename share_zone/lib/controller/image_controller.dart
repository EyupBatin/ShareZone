import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

class ImageController extends GetxController {
  File? selectedImage; // Fotoğraf seçimi için değişken
  RxnString imageUrl = RxnString(); // Private imageUrl değişkeni

  // Getter: imageUrl değerini almak için
  String? getImageUrl() {
    return imageUrl?.value;
  }

  // Setter: imageUrl değerini ayarlamak için
  void setImageUrl(String? value) {
    imageUrl?.value = value;
  }



  // Setter: isImageIsBeen değerini ayarlamak için

  // Getter: selectedImage değerini almak için
  File? getSelectedImage() {
    return selectedImage;
  }

  // Setter: selectedImage değerini ayarlamak için
  void setSelectedImage(File? value) {
    selectedImage = value;
    update(); // Değişiklik yapıldığında UI'yi günceller
  }
}
