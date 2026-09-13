import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> sendOTP({required String email});

  Future<String> verifyOTP({
    required String email,
    required String code,
    String? userId,
  });

  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
    required String resetToken,
  });

  Future<UserModel> signInWithGoogle({bool rememberMe = true});

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<bool> checkEmailExists(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;
    final userModel = UserModel.fromFirebaseUser(user, name);

    await firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toFirestore());

    return userModel;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;
    final doc = await firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    } else {
      return UserModel.fromFirebaseUser(user, user.displayName ?? 'No Name');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendOTP({required String email}) async {
    final response = await http.post(
      Uri.parse(
        'https://us-central1-ielts-project-2f836.cloudfunctions.net/sendPasswordResetOTP',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      String errorMessage = 'Failed to send OTP';
      try {
        final body = jsonDecode(response.body);
        errorMessage = body['error'] ?? errorMessage;
      } catch (_) {}
      throw FirebaseAuthException(
        code: 'otp-send-failed',
        message: errorMessage,
      );
    }
  }

  @override
  Future<String> verifyOTP({
    required String email,
    required String code,
    String? userId,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://us-central1-ielts-project-2f836.cloudfunctions.net/verifyOTP',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['resetToken'];
    } else {
      String errorMessage = 'Invalid or expired OTP';
      try {
        final body = jsonDecode(response.body);
        errorMessage = body['error'] ?? errorMessage;
      } catch (_) {}
      throw FirebaseAuthException(
        code: 'otp-verification-failed',
        message: errorMessage,
      );
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
    required String resetToken,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://us-central1-ielts-project-2f836.cloudfunctions.net/resetPassword',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
        'resetToken': resetToken,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      String errorMessage = 'Failed to reset password';
      try {
        final body = jsonDecode(response.body);
        errorMessage = body['error'] ?? errorMessage;
      } catch (_) {}
      throw FirebaseAuthException(
        code: 'password-reset-failed',
        message: errorMessage,
      );
    }
  }

  @override
  Future<UserModel> signInWithGoogle({bool rememberMe = true}) async {
    if (!rememberMe) {
      await googleSignIn.signOut();
    }

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null)
      throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user!;

    final doc = await firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    } else {
      final userModel = UserModel.fromFirebaseUser(
        user,
        user.displayName ?? 'Google User',
      );
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore());
      return userModel;
    }
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    // Check in Firestore
    final doc = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (doc.docs.isNotEmpty) return true;

    // Fallback: fetchSignInMethodsForEmail (Note: requires enabling "Email Enumeration Protection" appropriately in Firebase)
    try {
      final methods = await firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
