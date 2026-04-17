class AppValidators {

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (!RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-z]{2,7}$',
    ).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    } else if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.trim().isEmpty) {
    return "Confirm password is required";
  }

  if (value.trim() != password.trim()) {
    return "Passwords do not match";
  }

  return null;
}


  // Phone Number Validator
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }
  


}