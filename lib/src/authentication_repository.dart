import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc_login/authentication_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithPhoneNumberFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Whether or not the current environment is web
  /// Should only be overriden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  StreamController<String> _verifcationController = StreamController<String>();
  StreamSink<String> get _inAddVerificationId => _verifcationController.sink;
  Stream<String> get verificationId => _verifcationController.stream;

  void dispose() {
    _verifcationController.close();
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      return user;
    });
  }

  /// Returns the current user.
  /// Defaults to [User.empty] if there is no user.
  User get currentUser {
    return _firebaseAuth.currentUser?.toUser ?? User.empty;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp(
      {required String phoneNumber, required String name}) async {
    try {
      await logInWithPhoneNumber(phoneNumber: phoneNumber);
      //final String userId = currentUser.id;
      //print(userId);
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } catch (_) {
      throw LogInWithGoogleFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithPhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('Incorrect phone number.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          _inAddVerificationId.add(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on Exception {
      throw LogInWithPhoneNumberFailure();
    }
  }

  Future<void> logInWithOtp(
      {required String verificationId, required String smsCode}) async {
    try {
      firebase_auth.PhoneAuthCredential credential =
          firebase_auth.PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithPhoneNumberFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
