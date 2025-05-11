import 'package:baakas_admin/utils/constants/enums.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../../features/media/models/image_model.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload any Image using File
  Future<ImageModel> uploadImageFileInStorage({
    required html.File file,
    required String path,
    required String imageName,
  }) async {
    try {
      // Validate file size
      if (file.size == 0) {
        throw 'File is empty';
      }

      // Get file extension and determine MIME type
      final extension = imageName.split('.').last.toLowerCase();
      String mimeType;

      // More robust MIME type detection for web
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'svg':
          mimeType = 'image/svg+xml';
          break;
        default:
          mimeType = file.type.isNotEmpty ? file.type.toLowerCase() : 'image/jpeg';
      }

      // Create a completer for handling the file reading
      final completer = Completer<Uint8List>();
      final reader = html.FileReader();

      // Set up error handling for the FileReader
      reader.onError.listen((error) {
        if (!completer.isCompleted) {
          completer.completeError('Failed to read file: ${error.toString()}');
        }
      });

      // Set up the load end handler
      reader.onLoadEnd.listen((event) {
        if (!completer.isCompleted) {
          try {
            final result = reader.result as Uint8List;
            if (result.isEmpty) {
              completer.completeError('File data is empty');
            } else {
              completer.complete(result);
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.completeError('Failed to process file: ${e.toString()}');
            }
          }
        }
      });

      // Start reading the file
      reader.readAsArrayBuffer(file);

      // Wait for the file to be read
      final Uint8List fileBytes = await completer.future;

      // Reference to the storage location
      final Reference ref = _storage.ref('$path/$imageName');

      // Set metadata with content type and additional metadata
      final uploadMetadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'originalName': imageName,
          'uploadedAt': DateTime.now().toIso8601String(),
          'fileExtension': extension,
          'fileSize': file.size.toString(),
          'browserType': 'web',
          'originalMimeType': file.type,
          'uploadPlatform': 'web',
          'fileFormat': extension,
        },
      );

      // Upload file with metadata
      final uploadTask = ref.putData(
        fileBytes,
        uploadMetadata,
      );

      // Wait for the upload to complete
      await uploadTask;

      // Verify the upload was successful
      final metadataAfterUpload = await ref.getMetadata();
      
      // For web, we'll be more lenient with MIME type verification
      if (metadataAfterUpload.contentType != mimeType) {
        Get.log('MIME type mismatch: Expected $mimeType, got ${metadataAfterUpload.contentType}');
      }

      // Get download URL
      final String downloadURL = await ref.getDownloadURL();

      // Fetch metadata
      final FullMetadata fullMetadata = await ref.getMetadata();

      return ImageModel.fromFirebaseMetadata(
        fullMetadata,
        path,
        imageName,
        downloadURL,
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection("Images")
          .add(image.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  // Fetch images from Firestore based on media category and load count
  Future<List<ImageModel>> fetchImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
  ) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection("Images")
              .where("mediaCategory", isEqualTo: mediaCategory.name.toString())
              .orderBy("createdAt", descending: true)
              .limit(loadCount)
              .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  // Load more images from Firestore based on media category, load count, and last fetched date
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedDate,
  ) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection("Images")
              .where("mediaCategory", isEqualTo: mediaCategory.name.toString())
              .orderBy("createdAt", descending: true)
              .startAfter([lastFetchedDate])
              .limit(loadCount)
              .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  // Fetch all images from Firebase Storage
  Future<List<ImageModel>> fetchAllImages() async {
    try {
      final ListResult result = await _storage.ref().listAll();
      final List<ImageModel> images = [];

      for (final Reference ref in result.items) {
        final String filename = ref.name;

        // Fetch download URL
        final String downloadURL = await ref.getDownloadURL();

        // Fetch metadata
        final FullMetadata metadata = await ref.getMetadata();

        images.add(
          ImageModel.fromFirebaseMetadata(metadata, '', filename, downloadURL),
        );
      }

      return images;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete file from Firebase Storage and corresponding document from Firestore
  Future<void> deleteFileFromStorage(ImageModel image) async {
    try {
      await FirebaseStorage.instance.ref(image.fullPath).delete();
      await FirebaseFirestore.instance
          .collection('Images')
          .doc(image.id)
          .delete();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something went wrong while deleting image.';
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
