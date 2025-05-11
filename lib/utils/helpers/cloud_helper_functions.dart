import 'dart:async';

import 'package:universal_html/html.dart' as html;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Helper functions for cloud-related operations.
class BaakasCloudHelperFunctions {
  /// Helper function to check the state of a single database record.
  ///
  /// Returns a Widget based on the state of the snapshot.
  /// If data is still loading, it returns a CircularProgressIndicator.
  /// If no data is found, it returns a generic "No Data Found" message.
  /// If an error occurs, it returns a generic error message.
  /// Otherwise, it returns null.
  static Widget? checkSingleRecordState<Baakas>(
      AsyncSnapshot<Baakas> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(child: Text('No Data Found!'));
    }

    if (snapshot.hasError) {
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }

  /// Helper function to check the state of multiple (list) database records.
  ///
  /// Returns a Widget based on the state of the snapshot.
  /// If data is still loading, it returns a CircularProgressIndicator.
  /// If no data is found, it returns a generic "No Data Found" message or a custom nothingFoundWidget if provided.
  /// If an error occurs, it returns a generic error message.
  /// Otherwise, it returns null.
  static Widget? checkMultiRecordState<Baakas>(
      {required AsyncSnapshot<List<Baakas>> snapshot,
      Widget? loader,
      Widget? error,
      Widget? nothingFound}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      if (loader != null) return loader;
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      if (nothingFound != null) return nothingFound;
      return const Center(child: Text('No Data Found!'));
    }

    if (snapshot.hasError) {
      if (error != null) return error;
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }

  /// Create a reference with an initial file path and name and retrieve the download URL.
  static Future<String> getURLFromFilePathAndName(String path) async {
    try {
      if (path.isEmpty) return '';
      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  /// Retrieve the download URL from a given storage URI.
  static Future<String> getURLFromURI(String url) async {
    try {
      if (url.isEmpty) return '';
      final ref = FirebaseStorage.instance.refFromURL(url);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  /// Upload any Image using File
  static Future<String> uploadImageFile({
    required html.File file,
    required String path,
    required String imageName,
  }) async {
    try {
      // Validate file size
      if (file.size == 0) {
        throw 'File is empty';
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

      // Get file extension and determine MIME type
      final extension = imageName.split('.').last.toLowerCase();
      String mimeType;

      // Explicitly set MIME type based on file extension
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
          // If we can't determine the type, try to use the file's type
          mimeType = file.type.isNotEmpty ? file.type.toLowerCase() : 'image/jpeg';
      }

      // Create storage reference
      final ref = FirebaseStorage.instance.ref(path).child(imageName);

      // Set metadata with content type and additional metadata
      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'originalName': imageName,
          'uploadedAt': DateTime.now().toIso8601String(),
          'fileExtension': extension,
          'fileSize': file.size.toString(),
        },
      );

      // Upload the file with explicit content type
      final uploadTask = ref.putData(
        fileBytes,
        metadata,
      );

      // Wait for the upload to complete
      await uploadTask;

      // Verify the upload was successful
      final metadataAfterUpload = await ref.getMetadata();
      if (metadataAfterUpload.contentType != mimeType) {
        throw 'MIME type mismatch after upload';
      }

      // Return the download URL
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw 'Firebase Storage Error: ${e.message}';
    } on PlatformException catch (e) {
      throw 'Platform Error: ${e.message}';
    } catch (e) {
      throw 'Failed to upload image: ${e.toString()}';
    }
  }

  static Future<void> deleteFileFromStorage(String downloadUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();

      Get.log('File deleted successfully.');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        Get.log('The file does not exist in Firebase Storage.');
      } else {
        throw e.message!;
      }
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
