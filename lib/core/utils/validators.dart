class Validators {
  Validators._();

  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your mobile Number to Login/signup.';
    }
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      return 'Mobile number should contain digits only.';
    }
    if (value.length != 10) {
      return 'Please enter a valid 10-digit mobile number.';
    }
    return null;
  }

  static String? validateOTP(String? value, {bool isExpired = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the OTP.';
    }
    if (value.length != 4) {
      return 'Please enter a valid 4-digit OTP.';
    }
    if (isExpired) {
      return 'OTP has expired. Please request a new OTP.';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
      return 'Name should contain alphabets only.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validateProfilePhoto(bool hasPhoto) {
    if (!hasPhoto) {
      return 'Please upload your profile photo.';
    }
    return null;
  }

  static String? validateTerms(bool accepted) {
    if (!accepted) {
      return 'Please accept the Terms & Conditions to continue.';
    }
    return null;
  }
}
