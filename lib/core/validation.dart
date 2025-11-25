/// Validation utilities for CloudBarber application.
/// 
/// This file provides centralized validation logic for all data inputs
/// across the application, ensuring consistency and maintainability.
/// 
/// See [SECURITY_RULES.md] for detailed validation specifications.

/// Result of a validation operation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.valid()
      : isValid = true,
        errorMessage = null;

  const ValidationResult.invalid(this.errorMessage) : isValid = false;
}

/// Validation utilities for user-related data
class UserValidation {
  UserValidation._();

  /// Minimum name length
  static const int minNameLength = 2;
  
  /// Maximum name length
  static const int maxNameLength = 100;
  
  /// Maximum email length
  static const int maxEmailLength = 255;
  
  /// Maximum phone length
  static const int maxPhoneLength = 20;
  
  /// Minimum password length
  static const int minPasswordLength = 8;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;

  /// Validates user name
  /// 
  /// Rules:
  /// - Required (not empty)
  /// - Min 2 characters
  /// - Max 100 characters
  /// - Only letters, spaces, hyphens, and apostrophes allowed
  static ValidationResult validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('Name is required');
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < minNameLength) {
      return ValidationResult.invalid(
        'Name must be at least $minNameLength characters',
      );
    }
    
    if (trimmed.length > maxNameLength) {
      return ValidationResult.invalid(
        'Name must be at most $maxNameLength characters',
      );
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    // Supports international characters (À-ÿ)
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$").hasMatch(trimmed)) {
      return const ValidationResult.invalid('Name contains invalid characters');
    }
    
    return const ValidationResult.valid();
  }

  /// Validates email address
  /// 
  /// Rules:
  /// - Required (not empty)
  /// - Max 255 characters
  /// - Valid email format
  static ValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('Email is required');
    }
    
    if (value.length > maxEmailLength) {
      return const ValidationResult.invalid('Email is too long');
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.toLowerCase())) {
      return const ValidationResult.invalid('Invalid email format');
    }
    
    return const ValidationResult.valid();
  }

  /// Validates phone number
  /// 
  /// Rules:
  /// - Optional (can be empty)
  /// - Max 20 characters if provided
  /// - Valid phone format (E.164 or common formats)
  static ValidationResult validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.valid(); // Phone is optional
    }
    
    if (value.length > maxPhoneLength) {
      return const ValidationResult.invalid('Phone number is too long');
    }
    
    // E.164 format or common phone formats
    final phoneRegex = RegExp(r'^\+?[0-9\s\-()]{7,20}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return const ValidationResult.invalid('Invalid phone format');
    }
    
    return const ValidationResult.valid();
  }

  /// Validates password strength
  /// 
  /// Rules:
  /// - Required (not empty)
  /// - Min 8 characters
  /// - Max 128 characters
  /// - At least 1 uppercase letter
  /// - At least 1 lowercase letter
  /// - At least 1 digit
  /// - At least 1 special character
  static ValidationResult validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.invalid('Password is required');
    }
    
    if (value.length < minPasswordLength) {
      return ValidationResult.invalid(
        'Password must be at least $minPasswordLength characters',
      );
    }
    
    if (value.length > maxPasswordLength) {
      return ValidationResult.invalid(
        'Password must be at most $maxPasswordLength characters',
      );
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return const ValidationResult.invalid(
        'Password must contain at least 1 lowercase letter',
      );
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return const ValidationResult.invalid(
        'Password must contain at least 1 uppercase letter',
      );
    }
    
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return const ValidationResult.invalid(
        'Password must contain at least 1 digit',
      );
    }
    
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return const ValidationResult.invalid(
        'Password must contain at least 1 special character',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Validates password with simpler rules (for login only)
  /// 
  /// **IMPORTANT**: This method provides minimal validation suitable only for
  /// login forms where we don't want to enforce strict rules on existing
  /// passwords. For registration, ALWAYS use [validatePassword] instead.
  /// 
  /// Rules:
  /// - Required (not empty)
  /// - Min 6 characters (legacy compatibility)
  /// 
  /// @deprecated Prefer [validatePassword] for new password creation.
  /// This method exists only for backward compatibility with existing accounts.
  static ValidationResult validatePasswordSimple(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.invalid('Password is required');
    }
    
    if (value.length < 6) {
      return const ValidationResult.invalid(
        'Password must be at least 6 characters',
      );
    }
    
    return const ValidationResult.valid();
  }
}

/// Validation utilities for booking-related data
class BookingValidation {
  BookingValidation._();

  /// Maximum notes length
  static const int maxNotesLength = 500;
  
  /// Minimum advance booking time in minutes
  static const int minAdvanceMinutes = 60;
  
  /// Maximum advance booking days
  static const int maxAdvanceDays = 30;
  
  /// Cancellation window in hours
  static const int cancellationWindowHours = 2;
  
  /// Opening hour (default)
  static const int defaultOpeningHour = 8;
  
  /// Closing hour (default)
  static const int defaultClosingHour = 20;

  /// Validates booking start time
  /// 
  /// Rules:
  /// - Required
  /// - Must be in the future
  /// - At least 1 hour in advance
  /// - No more than 30 days in advance
  /// - Must be during business hours
  static ValidationResult validateStartTime(DateTime? value, {
    int openingHour = defaultOpeningHour,
    int closingHour = defaultClosingHour,
  }) {
    if (value == null) {
      return const ValidationResult.invalid('Start time is required');
    }
    
    final now = DateTime.now();
    final minTime = now.add(Duration(minutes: minAdvanceMinutes));
    final maxTime = now.add(Duration(days: maxAdvanceDays));
    
    if (value.isBefore(minTime)) {
      return ValidationResult.invalid(
        'Booking must be at least $minAdvanceMinutes minutes in advance',
      );
    }
    
    if (value.isAfter(maxTime)) {
      return ValidationResult.invalid(
        'Booking cannot be more than $maxAdvanceDays days in advance',
      );
    }
    
    // Check business hours
    if (value.hour < openingHour || value.hour >= closingHour) {
      return ValidationResult.invalid(
        'Booking must be during business hours ($openingHour:00 - $closingHour:00)',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Validates booking notes
  /// 
  /// Rules:
  /// - Optional
  /// - Max 500 characters if provided
  static ValidationResult validateNotes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.valid(); // Notes are optional
    }
    
    if (value.length > maxNotesLength) {
      return ValidationResult.invalid(
        'Notes must be at most $maxNotesLength characters',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Validates service selection
  /// 
  /// Rules:
  /// - At least one service must be selected
  static ValidationResult validateServiceSelection(List<String>? serviceIds) {
    if (serviceIds == null || serviceIds.isEmpty) {
      return const ValidationResult.invalid(
        'At least one service must be selected',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Checks if a booking can be cancelled
  /// 
  /// Rules:
  /// - Booking must be in pending or confirmed status
  /// - Must be at least 2 hours before start time
  static bool canCancelBooking({
    required String status,
    required DateTime startTime,
  }) {
    // Check status
    if (status != 'pending' && status != 'confirmed') {
      return false;
    }
    
    // Check time
    final cancellationDeadline = startTime.subtract(
      const Duration(hours: cancellationWindowHours),
    );
    
    return DateTime.now().isBefore(cancellationDeadline);
  }
}

/// Validation utilities for service-related data
class ServiceValidation {
  ServiceValidation._();

  /// Minimum name length
  static const int minNameLength = 2;
  
  /// Maximum name length
  static const int maxNameLength = 100;
  
  /// Minimum description length
  static const int minDescriptionLength = 10;
  
  /// Maximum description length
  static const int maxDescriptionLength = 500;
  
  /// Minimum duration in minutes
  static const int minDuration = 15;
  
  /// Maximum duration in minutes
  static const int maxDuration = 480;
  
  /// Duration must be in these increments
  static const int durationIncrement = 15;

  /// Validates service name
  static ValidationResult validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('Service name is required');
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < minNameLength) {
      return ValidationResult.invalid(
        'Name must be at least $minNameLength characters',
      );
    }
    
    if (trimmed.length > maxNameLength) {
      return ValidationResult.invalid(
        'Name must be at most $maxNameLength characters',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Validates service description
  static ValidationResult validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('Description is required');
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < minDescriptionLength) {
      return ValidationResult.invalid(
        'Description must be at least $minDescriptionLength characters',
      );
    }
    
    if (trimmed.length > maxDescriptionLength) {
      return ValidationResult.invalid(
        'Description must be at most $maxDescriptionLength characters',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Validates service duration
  /// 
  /// Rules:
  /// - Required
  /// - Min 15 minutes
  /// - Max 480 minutes (8 hours)
  /// - Must be in 15-minute increments
  static ValidationResult validateDuration(int? value) {
    if (value == null) {
      return const ValidationResult.invalid('Duration is required');
    }
    
    if (value < minDuration) {
      return ValidationResult.invalid(
        'Duration must be at least $minDuration minutes',
      );
    }
    
    if (value > maxDuration) {
      return ValidationResult.invalid(
        'Duration must be at most $maxDuration minutes',
      );
    }
    
    if (value % durationIncrement != 0) {
      return ValidationResult.invalid(
        'Duration must be in $durationIncrement-minute increments',
      );
    }
    
    return const ValidationResult.valid();
  }

  /// Validates service price
  /// 
  /// Rules:
  /// - Required
  /// - Must be >= 0
  /// - Max 2 decimal places
  static ValidationResult validatePrice(double? value) {
    if (value == null) {
      return const ValidationResult.invalid('Price is required');
    }
    
    if (value < 0) {
      return const ValidationResult.invalid('Price cannot be negative');
    }
    
    // Check for max 2 decimal places using integer arithmetic
    // to avoid floating-point precision issues
    final cents = (value * 100).round();
    final reconstructed = cents / 100;
    if ((value - reconstructed).abs() > 0.001) {
      return const ValidationResult.invalid(
        'Price must have at most 2 decimal places',
      );
    }
    
    return const ValidationResult.valid();
  }
}

/// Common validation utilities
class CommonValidation {
  CommonValidation._();

  /// Validates UUID format
  static ValidationResult validateUuid(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('ID is required');
    }
    
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    
    if (!uuidRegex.hasMatch(value)) {
      return const ValidationResult.invalid('Invalid ID format');
    }
    
    return const ValidationResult.valid();
  }

  /// Validates currency code (ISO 4217)
  static ValidationResult validateCurrency(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('Currency is required');
    }
    
    const validCurrencies = ['EUR', 'USD', 'GBP', 'CHF'];
    
    if (!validCurrencies.contains(value.toUpperCase())) {
      return const ValidationResult.invalid('Invalid currency code');
    }
    
    return const ValidationResult.valid();
  }
}
