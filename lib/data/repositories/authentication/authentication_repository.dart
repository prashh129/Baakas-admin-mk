import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final _auth = FirebaseAuth.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Get IsAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  // Called from main.dart on app launch
  @override
  void onReady() {
    if (kIsWeb) {
      _auth.setPersistence(Persistence.LOCAL);
      // Redirect to the appropriate screen
      // screenRedirect();
    }
  }
  //  @override
  // void onReady() {
  //     _auth.setPersistence(Persistence.LOCAL); ///this was earlier
  //     // Redirect to the appropriate screen
  //     // screenRedirect();
  //   }

  // Function to determine the relevant screen and redirect accordingly.
  void screenRedirect() async {
    final user = _auth.currentUser;

    // If the user is logged in
    if (user != null) {
      // Navigate to the Home
      Get.offAllNamed(BaakasRoutes.dashboard);
    } else {
      Get.offAllNamed(BaakasRoutes.login);
    }
  }

  // Email & Password sign-in

  // LOGIN
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // REGISTER USER BY ADMIN
  Future<UserCredential> registerUserByAdmin(
    String email,
    String password,
  ) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
        name: 'RegisterUser',
        options: Firebase.app().options,
      );
      UserCredential userCredential = await FirebaseAuth.instanceFor(
        app: app,
      ).createUserWithEmailAndPassword(email: email, password: password);

      await app.delete();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // RE AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Create a credential
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Logout User
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(BaakasRoutes.login);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print(e);
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      if (kDebugMode) print(e);
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      if (kDebugMode) print('Format Exception Caught');
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      if (kDebugMode) print(e);
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print(e);
      throw 'Something went wrong. Please try again';
    }
  }

  // DELETE USER - Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      // await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw BaakasFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
