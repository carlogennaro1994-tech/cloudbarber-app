# CloudBarber Security Rules & Validation

This document provides comprehensive security rules, validation guidelines, and access control policies for the CloudBarber application. These rules ensure data integrity, protect user privacy, and maintain system stability.

---

## 🔐 Authentication Rules

### 1. Password Security

#### Requirements

| Rule                    | Specification                              |
|-------------------------|-------------------------------------------|
| Minimum Length          | 8 characters                              |
| Maximum Length          | 128 characters                            |
| Uppercase Required      | At least 1 uppercase letter               |
| Lowercase Required      | At least 1 lowercase letter               |
| Number Required         | At least 1 digit                          |
| Special Char Required   | At least 1 special character (!@#$%^&*(),.?":{}|<>)   |
| Common Password Check   | Must not be in common passwords list      |

#### Validation Regex

```dart
// Strong password validation
// Matches implementation in lib/core/validation.dart
final passwordRegex = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\d!@#$%^&*(),.?\":{}|<>]{8,128}$'
);

bool isValidPassword(String password) {
  return passwordRegex.hasMatch(password);
}
```

#### Password Storage

```
Algorithm: bcrypt
Cost Factor: 12 (minimum)
Salt: Auto-generated per password
```

### 2. Email Validation

```dart
// Email validation regex
final emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
);

bool isValidEmail(String email) {
  if (email.length > 255) return false;
  return emailRegex.hasMatch(email.toLowerCase());
}
```

### 3. Token Security

#### JWT Configuration

```json
{
  "algorithm": "RS256",
  "issuer": "cloudbarber-api",
  "audience": "cloudbarber-app",
  "access_token_expiry": "15m",
  "refresh_token_expiry": "7d"
}
```

#### Token Claims

```json
{
  "sub": "user_id",
  "email": "user@email.com",
  "role": "customer|operator|admin",
  "iat": 1711234567,
  "exp": 1711235467,
  "iss": "cloudbarber-api",
  "aud": "cloudbarber-app"
}
```

#### Token Storage Rules

| Token Type    | Storage Location          | Security Level |
|---------------|---------------------------|----------------|
| Access Token  | Memory / Secure Storage   | High           |
| Refresh Token | Secure Storage (encrypted)| Very High      |

#### Refresh Token Rotation

```
1. Client sends refresh token
2. Server validates refresh token
3. Server generates new access token AND new refresh token
4. Old refresh token is invalidated
5. New tokens returned to client
```

### 4. Session Security

| Setting              | Value           | Description                       |
|----------------------|-----------------|-----------------------------------|
| Max Sessions         | 5               | Maximum concurrent sessions       |
| Session Timeout      | 30 days         | Inactive session expiration       |
| Force Re-auth        | 90 days         | Force re-authentication           |
| Suspicious Activity  | Auto-logout     | Logout all sessions on detection  |

---

## 🛡️ Authorization Rules

### Role-Based Access Control (RBAC)

#### Role Hierarchy

```
Admin
  │
  └── Operator
        │
        └── Customer
```

#### Permission Matrix

| Resource        | Customer           | Operator           | Admin              |
|-----------------|--------------------|--------------------|---------------------|
| **Users**       |                    |                    |                     |
| Create          | ❌                 | ❌                 | ✅                  |
| Read (own)      | ✅                 | ✅                 | ✅                  |
| Read (all)      | ❌                 | ❌                 | ✅                  |
| Update (own)    | ✅                 | ✅                 | ✅                  |
| Update (all)    | ❌                 | ❌                 | ✅                  |
| Delete          | ❌                 | ❌                 | ✅                  |
| **Bookings**    |                    |                    |                     |
| Create (own)    | ✅                 | ✅                 | ✅                  |
| Create (others) | ❌                 | ✅                 | ✅                  |
| Read (own)      | ✅                 | ✅                 | ✅                  |
| Read (assigned) | ❌                 | ✅                 | ✅                  |
| Read (all)      | ❌                 | ❌                 | ✅                  |
| Update (own)    | ✅ (with limits)   | ✅                 | ✅                  |
| Update (all)    | ❌                 | ✅ (assigned)      | ✅                  |
| Cancel (own)    | ✅ (with limits)   | ✅                 | ✅                  |
| Cancel (all)    | ❌                 | ✅ (assigned)      | ✅                  |
| **Services**    |                    |                    |                     |
| Read            | ✅                 | ✅                 | ✅                  |
| Create          | ❌                 | ❌                 | ✅                  |
| Update          | ❌                 | ❌                 | ✅                  |
| Delete          | ❌                 | ❌                 | ✅                  |

### Resource Ownership Rules

```dart
// Pseudo-code for ownership validation
bool canAccessBooking(User user, Booking booking) {
  switch (user.role) {
    case UserRole.admin:
      return true; // Admin can access all
    case UserRole.operator:
      return booking.operatorId == user.id || booking.customerId == user.id;
    case UserRole.customer:
      return booking.customerId == user.id;
    default:
      return false;
  }
}
```

---

## ✅ Input Validation Rules

### 1. General Rules

| Rule                  | Implementation                              |
|-----------------------|---------------------------------------------|
| Trim whitespace       | All string inputs                           |
| Sanitize HTML         | Remove all HTML tags                        |
| SQL Injection         | Use parameterized queries                   |
| XSS Prevention        | Encode output, validate input               |
| Size Limits           | Enforce max length on all fields            |

### 2. Field-Specific Validation

#### User Fields

```dart
class UserValidation {
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 255;
  static const int maxPhoneLength = 20;
  
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.length < minNameLength) {
      return 'Name must be at least $minNameLength characters';
    }
    if (value.length > maxNameLength) {
      return 'Name must be at most $maxNameLength characters';
    }
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$").hasMatch(value)) {
      return 'Name contains invalid characters';
    }
    return null;
  }
  
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (value.length > maxEmailLength) {
      return 'Email is too long';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    if (value.length > maxPhoneLength) {
      return 'Phone number is too long';
    }
    // E.164 format or common phone formats
    final phoneRegex = RegExp(r'^\+?[0-9\s\-()]{7,20}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Invalid phone format';
    }
    return null;
  }
}
```

#### Booking Fields

```dart
class BookingValidation {
  static const int maxNotesLength = 500;
  static const int minAdvanceMinutes = 60; // 1 hour
  static const int maxAdvanceDays = 30;
  static const int cancellationWindowHours = 2;
  
  static String? validateStartTime(DateTime? value) {
    if (value == null) {
      return 'Start time is required';
    }
    
    final now = DateTime.now();
    final minTime = now.add(Duration(minutes: minAdvanceMinutes));
    final maxTime = now.add(Duration(days: maxAdvanceDays));
    
    if (value.isBefore(minTime)) {
      return 'Booking must be at least $minAdvanceMinutes minutes in advance';
    }
    if (value.isAfter(maxTime)) {
      return 'Booking cannot be more than $maxAdvanceDays days in advance';
    }
    
    // Check business hours (this would be configurable)
    if (value.hour < 8 || value.hour >= 20) {
      return 'Booking must be during business hours (8:00 - 20:00)';
    }
    
    return null;
  }
  
  static String? validateNotes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Notes are optional
    }
    if (value.length > maxNotesLength) {
      return 'Notes must be at most $maxNotesLength characters';
    }
    return null;
  }
  
  static bool canCancelBooking(Booking booking) {
    if (booking.status != BookingStatus.pending && 
        booking.status != BookingStatus.confirmed) {
      return false;
    }
    
    final cancellationDeadline = booking.startTime.subtract(
      Duration(hours: cancellationWindowHours)
    );
    
    return DateTime.now().isBefore(cancellationDeadline);
  }
}
```

#### Service Fields

```dart
class ServiceValidation {
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;
  static const int minDuration = 15;
  static const int maxDuration = 480;
  static const int durationIncrement = 15;
  
  static String? validateDuration(int? value) {
    if (value == null) {
      return 'Duration is required';
    }
    if (value < minDuration) {
      return 'Duration must be at least $minDuration minutes';
    }
    if (value > maxDuration) {
      return 'Duration must be at most $maxDuration minutes';
    }
    if (value % durationIncrement != 0) {
      return 'Duration must be in $durationIncrement-minute increments';
    }
    return null;
  }
  
  static String? validatePrice(double? value) {
    if (value == null) {
      return 'Price is required';
    }
    if (value < 0) {
      return 'Price cannot be negative';
    }
    // Check for max 2 decimal places
    final formatted = value.toStringAsFixed(2);
    if (double.parse(formatted) != value) {
      return 'Price must have at most 2 decimal places';
    }
    return null;
  }
}
```

---

## 🚫 Rate Limiting Rules

### API Rate Limits

| Endpoint Category     | Limit (per minute) | Burst Limit |
|-----------------------|--------------------|-------------|
| Authentication        | 10                 | 5           |
| Password Reset        | 3                  | 2           |
| Read Operations       | 100                | 50          |
| Write Operations      | 30                 | 10          |
| Search/Filter         | 50                 | 20          |

### Rate Limit Headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1711234567
```

### Rate Limit Response (429)

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again later.",
    "retry_after": 60
  }
}
```

---

## 🔒 Data Protection Rules

### Personal Data Classification

| Category        | Data Fields                          | Protection Level |
|-----------------|--------------------------------------|------------------|
| Identifying     | name, email, phone, profile_image    | High             |
| Authentication  | password_hash, tokens                | Critical         |
| Transactional   | bookings, services                   | Medium           |
| System          | created_at, updated_at               | Low              |

### Data Retention

| Data Type           | Retention Period | Action After      |
|---------------------|------------------|-------------------|
| Active User Data    | Indefinite       | -                 |
| Inactive User Data  | 3 years          | Anonymize         |
| Deleted User Data   | 30 days          | Permanent Delete  |
| Booking History     | 5 years          | Archive           |
| Audit Logs          | 7 years          | Archive           |
| Failed Login Logs   | 90 days          | Delete            |

### Data Export (GDPR Right to Access)

```json
{
  "user": {
    "id": "...",
    "email": "...",
    "name": "...",
    "phone": "...",
    "created_at": "...",
    "updated_at": "..."
  },
  "bookings": [...],
  "export_date": "2025-03-25T10:00:00Z"
}
```

### Data Deletion (GDPR Right to Erasure)

```
1. User requests account deletion
2. 14-day grace period (can undo)
3. After grace period:
   - Delete personal data
   - Anonymize booking records (for business analytics)
   - Delete authentication tokens
   - Log deletion event
```

---

## 🛑 Error Handling Rules

### Error Response Format

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": {
      "field": "Specific field error"
    },
    "timestamp": "2025-03-25T10:00:00Z",
    "trace_id": "abc123-def456"
  }
}
```

### Error Codes

| Code                    | HTTP Status | Description                              |
|-------------------------|-------------|------------------------------------------|
| `INVALID_INPUT`         | 400         | Request validation failed                |
| `UNAUTHORIZED`          | 401         | Authentication required or failed        |
| `FORBIDDEN`             | 403         | Insufficient permissions                 |
| `NOT_FOUND`             | 404         | Resource not found                       |
| `CONFLICT`              | 409         | Resource conflict (e.g., booking overlap)|
| `VALIDATION_ERROR`      | 422         | Business rule validation failed          |
| `RATE_LIMIT_EXCEEDED`   | 429         | Too many requests                        |
| `INTERNAL_ERROR`        | 500         | Server error                             |
| `SERVICE_UNAVAILABLE`   | 503         | Service temporarily unavailable          |

### Sensitive Error Handling

```dart
// DO NOT expose internal errors to clients
// BAD:
return Response.error('SQL Error: SELECT * FROM users WHERE...');

// GOOD:
logger.error('Database error', error, stackTrace);
return Response.error('An internal error occurred. Please try again later.');
```

---

## 📝 Audit Logging Rules

### Events to Log

| Event Type          | Log Level | Data to Include                         |
|---------------------|-----------|----------------------------------------|
| Login Success       | INFO      | user_id, timestamp, ip, user_agent     |
| Login Failure       | WARN      | email_attempted, timestamp, ip, reason |
| Password Change     | INFO      | user_id, timestamp                     |
| Booking Created     | INFO      | user_id, booking_id, timestamp         |
| Booking Cancelled   | INFO      | user_id, booking_id, reason, timestamp |
| Admin Action        | INFO      | admin_id, action, target, timestamp    |
| Permission Denied   | WARN      | user_id, resource, action, timestamp   |
| Rate Limit Hit      | WARN      | user_id/ip, endpoint, timestamp        |

### Log Format

```json
{
  "timestamp": "2025-03-25T10:00:00Z",
  "level": "INFO",
  "event": "BOOKING_CREATED",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "resource_id": "660e8400-e29b-41d4-a716-446655440001",
  "ip_address": "192.168.1.1",
  "user_agent": "CloudBarber/1.0.0 (Android)",
  "details": {
    "services": ["taglio", "barba"],
    "start_time": "2025-03-25T10:00:00Z"
  }
}
```

---

## 🔐 API Security Headers

### Required Headers

```http
# HTTPS Only
Strict-Transport-Security: max-age=31536000; includeSubDomains

# Prevent clickjacking
X-Frame-Options: DENY

# XSS Protection
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block

# Content Security Policy
Content-Security-Policy: default-src 'self'

# CORS
Access-Control-Allow-Origin: https://app.cloudbarber.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
```

---

## 📱 Mobile Security Rules

### Secure Storage

```dart
// Flutter Secure Storage configuration
const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);
```

### Certificate Pinning (Recommended)

```dart
// SSL Pinning configuration
dio.httpClientAdapter = IOHttpClientAdapter()
  ..onHttpClientCreate = (client) {
    client.badCertificateCallback = (cert, host, port) {
      // Verify certificate fingerprint
      final fingerprint = sha256.convert(cert.der).toString();
      return trustedFingerprints.contains(fingerprint);
    };
    return client;
  };
```

### Root/Jailbreak Detection

```dart
// Detect compromised devices
Future<bool> isDeviceSecure() async {
  final isRooted = await FlutterJailbreakDetection.jailbroken;
  final isDeveloperMode = await FlutterJailbreakDetection.developerMode;
  
  return !isRooted && !isDeveloperMode;
}
```

---

## 🧪 Security Testing Checklist

### Authentication

- [ ] Password strength enforcement
- [ ] Brute force protection
- [ ] Session timeout
- [ ] Token refresh flow
- [ ] Logout invalidates tokens

### Authorization

- [ ] Role-based access control
- [ ] Resource ownership validation
- [ ] API endpoint protection
- [ ] Admin functions protected

### Input Validation

- [ ] All inputs validated
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] File upload validation

### Data Protection

- [ ] HTTPS everywhere
- [ ] Sensitive data encrypted
- [ ] PII handling compliant
- [ ] Data export functionality
- [ ] Data deletion functionality

### Monitoring

- [ ] Audit logging enabled
- [ ] Failed login alerts
- [ ] Rate limiting active
- [ ] Error tracking configured

---

## 🔄 Version History

| Version | Date       | Changes                                    |
|---------|------------|--------------------------------------------|
| 1.0.0   | 2025-11-25 | Initial security rules documentation       |

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) - Database schema
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Application architecture
- [IMPLEMENTATION.md](./IMPLEMENTATION.md) - Implementation details
- [DEVELOPMENT.md](./DEVELOPMENT.md) - Development guide
