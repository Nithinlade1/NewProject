class AppConstants {
  AppConstants._();

  static const String appName = 'EntryTUD';
  static const String appTagline = 'Your all-in-one app for services & connections';

  // OTP
  static const int otpLength = 4;
  static const int otpTimerSeconds = 30;

  // TUD Number
  static const int phoneDigits = 10;
  static const int tudNumberDigits = 11;
  static const int tudNumberTotalBoxes = 20;

  // Validation
  static const int minNameLength = 2;
  static const int maxImageSizeMB = 5;
  static const int minImageResolution = 80;

  // Token
  static const int kutTokenValidityDays = 90;

  // Limits
  static const int maxCommitteeThree = 3;
  static const int maxCommitteeFive = 5;
  static const int maxCommitteeSeven = 7;
}

class AppStrings {
  AppStrings._();

  // Language Selection
  static const String selectLanguage = 'Select Language';
  static const String choosePreferredLanguage = 'Choose your preferred language';

  // Welcome
  static const String welcomeTitle = 'Welcome to TUD';
  static const String welcomeMessage =
      'Welcome to TUD – Your all-in-one app for services and connections.';
  static const String getStarted = 'Get Started';

  // Login
  static const String loginTitle = 'Login with OTP';
  static const String enterMobile = 'Enter your mobile number to continue';
  static const String getOTP = 'Get OTP';
  static const String mobileEmptyError = 'Enter your mobile Number to Login/signup.';
  static const String mobileDigitsOnlyError = 'Mobile number should contain digits only.';
  static const String mobileInvalidError = 'Please enter a valid 10-digit mobile number.';

  // OTP
  static const String otpTitle = 'OTP Verification';
  static const String verifyOTP = 'Verify OTP';
  static const String resendOTP = 'Resend OTP';
  static const String otpEmptyError = 'Please enter the OTP.';
  static const String otpInvalidError = 'Please enter a valid 4-digit OTP.';
  static const String otpIncorrectError = 'Invalid OTP. Please try again.';
  static const String otpExpiredError = 'OTP has expired. Please request a new OTP.';
  static const String otpVerified = 'OTP Verified';
  static const String otpVerifiedMessage =
      'Your One-Time Password (OTP) has been successfully verified.';

  // Signup
  static const String signupTitle = 'Create Account';
  static const String photoRequired = 'Please upload your profile photo.';
  static const String photoInvalidFormat = 'Please upload a valid image (JPG or PNG).';
  static const String photoTooLarge = 'Image size should be less than 5MB.';
  static const String nameEmpty = 'Please enter your name.';
  static const String nameInvalid = 'Name should contain alphabets only.';
  static const String nameTooShort = 'Name must be at least 2 characters long.';
  static const String emailInvalid = 'Please enter a valid email address.';
  static const String termsRequired = 'Please accept the Terms & Conditions to continue.';

  // TUD Number
  static const String createTudNumber = 'Create TUD Number';
  static const String tudNumberInstruction =
      'Add any one digit before, after, or anywhere within your existing 10-digit phone number to create your customized 11-digit Tud Number';
  static const String tudNumberTaken =
      'Tud Number is already taken. Please try another combination';

  // Landing Page
  static const String noKutComsAvailable = 'No KutComs available';
  static const String noResultsFound = 'No results found';
  static const String createTudAccount = 'Create a TUD Account';
  static const String tudMessage =
      'If you are a TUD, create a TUD Account to start interacting with your Kut';
  static const String roleHolderMessage =
      'If you are a Role Holder, Wait for your Tud to assign you a Role';

  // Chat
  static const String typeMessage = 'Type a message...';

  // Notifications
  static const String noNotifications = 'No notifications available';

  // Schedule
  static const String noSchedules = 'No schedules created yet';

  // Filter
  static const String mySequence = 'My Sequence';
  static const String unreadMessages = 'Unread Messages';
  static const String latest = 'Latest';
  static const String activeInterests = 'Active Interests';

  // Common
  static const String continueText = 'Continue';
  static const String next = 'Next';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String search = 'Search';
  static const String apply = 'Apply';
  static const String back = 'Back';
}
