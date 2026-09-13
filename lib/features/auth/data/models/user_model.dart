import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.photoUrl,
    required super.isEmailVerified,
    required super.createdAt,
  });

  factory UserModel.fromFirebaseUser(firebase.User user, String fullName) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: fullName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
      createdAt: DateTime.now(),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'isEmailVerified': isEmailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
