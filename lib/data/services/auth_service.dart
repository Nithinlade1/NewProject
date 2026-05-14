import '../models/user_model.dart';

abstract class AuthService {
  Future<bool> sendOTP(String phoneNumber);
  Future<bool> verifyOTP(String phoneNumber, String otp);
  Future<UserModel> signUp({
    required String name,
    required String phone,
    String? email,
    String? profilePhoto,
  });
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

class MockAuthService implements AuthService {
  UserModel? _currentUser;

  @override
  Future<bool> sendOTP(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp.length == 4;
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String phone,
    String? email,
    String? profilePhoto,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email,
      profilePhoto: profilePhoto,
      isRegistered: true,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
