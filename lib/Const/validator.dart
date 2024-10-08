class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null;
  }

  static String? addressvalidator(String? address) {
    if (address == null || address.isEmpty) {
      return 'Address cannot be empty';
    }
    if (address.length < 10 || address.length > 200) {
      return 'Address must be between 10 and 200 characters';
    }
    return null;
  }

  static String? phoneNovalidator(String? phoneNo) {
    if (phoneNo == null || phoneNo.isEmpty) {
      return 'Contact number cannot be empty';
    }
    if (phoneNo.length > 10 || phoneNo.length < 10) {
      return 'Contact number must be between 10 and 200 characters';
    }
    return null;
  }

  static String? cityvalidator(String? address) {
    if (address == null || address.isEmpty) {
      return 'City cannot be empty';
    }
    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? nameValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}




