# CloudBarber Database Schema

This document provides comprehensive documentation of the data models, relationships, and validation rules for the CloudBarber application. It serves as the single source of truth for database structure and API contracts.

## 📊 Entity Relationship Diagram

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│      User       │     │     Booking      │     │     Service     │
├─────────────────┤     ├──────────────────┤     ├─────────────────┤
│ id (PK)         │     │ id (PK)          │     │ id (PK)         │
│ email           │◄────│ customer_id (FK) │     │ name            │
│ name            │     │ customer_name    │     │ description     │
│ phone           │     │ customer_email   │     │ duration_minutes│
│ role            │     │ customer_phone   │     │ price           │
│ profile_image   │     │ start_time       │     │ currency        │
│ created_at      │     │ end_time         │     │ is_active       │
│ updated_at      │     │ status           │     └─────────────────┘
└─────────────────┘     │ total_price      │              │
        │               │ currency         │              │
        │               │ notes            │              │
        │               │ operator_id (FK) │──────────────┤
        │               │ operator_name    │              │
        │               │ created_at       │              │
        │               │ updated_at       │              │
        │               └──────────────────┘              │
        │                       │                         │
        │               ┌───────┴───────┐                 │
        │               │BookingService │                 │
        │               │ (Join Table)  │                 │
        │               ├───────────────┤                 │
        │               │ booking_id(FK)│─────────────────┤
        │               │ service_id(FK)│─────────────────┘
        │               └───────────────┘
        │
┌───────┴─────────┐
│    AuthToken    │
├─────────────────┤
│ access_token    │
│ refresh_token   │
│ expires_at      │
│ user_id (FK)    │
└─────────────────┘
```

---

## 📋 Data Models

### 1. User Entity

Represents a user in the system with role-based access control.

#### Schema

| Field            | Type      | Required | Default   | Description                              |
|------------------|-----------|----------|-----------|------------------------------------------|
| `id`             | String    | Yes      | UUID      | Unique identifier (UUID v4)              |
| `email`          | String    | Yes      | -         | User's email address (unique)            |
| `name`           | String    | Yes      | -         | User's full name                         |
| `phone`          | String    | No       | null      | Phone number (optional)                  |
| `role`           | UserRole  | Yes      | customer  | User role (customer, operator, admin)    |
| `profile_image_url` | String | No       | null      | URL to profile image                     |
| `created_at`     | DateTime  | Yes      | now()     | Account creation timestamp               |
| `updated_at`     | DateTime  | No       | null      | Last update timestamp                    |

#### UserRole Enum

```dart
enum UserRole {
  customer,   // Regular customer who books appointments
  operator,   // Barber/stylist who provides services
  admin,      // System administrator
}
```

#### Validation Rules

| Field    | Rule                                           |
|----------|------------------------------------------------|
| `email`  | Valid email format, max 255 chars, unique      |
| `name`   | Min 2 chars, max 100 chars, not empty          |
| `phone`  | Valid phone format (E.164 recommended)         |
| `role`   | Must be one of: customer, operator, admin      |

#### JSON Example

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "mario.rossi@email.com",
  "name": "Mario Rossi",
  "phone": "+39 333 1234567",
  "role": "customer",
  "profile_image_url": "https://storage.cloudbarber.com/users/550e8400.jpg",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-03-20T14:45:00Z"
}
```

---

### 2. AuthToken Entity

Represents authentication tokens for secure API access.

#### Schema

| Field           | Type     | Required | Description                              |
|-----------------|----------|----------|------------------------------------------|
| `access_token`  | String   | Yes      | JWT access token for API authentication  |
| `refresh_token` | String   | Yes      | Refresh token for obtaining new access   |
| `expires_at`    | DateTime | Yes      | Access token expiration timestamp        |

#### Token Configuration

| Setting                | Value         | Description                           |
|------------------------|---------------|---------------------------------------|
| Access Token Lifetime  | 15 minutes    | Short-lived for security              |
| Refresh Token Lifetime | 7 days        | Longer-lived for session persistence  |
| Token Algorithm        | HS256/RS256   | JWT signing algorithm                 |

#### Validation Rules

| Field          | Rule                                    |
|----------------|-----------------------------------------|
| `access_token` | Valid JWT format, not expired           |
| `refresh_token`| Valid format, not revoked               |
| `expires_at`   | Valid ISO 8601 datetime                 |

#### JSON Example

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4...",
  "expires_at": "2025-03-20T15:00:00Z"
}
```

---

### 3. Booking Entity

Represents an appointment booking made by a customer.

#### Schema

| Field            | Type          | Required | Default   | Description                              |
|------------------|---------------|----------|-----------|------------------------------------------|
| `id`             | String        | Yes      | UUID      | Unique identifier (UUID v4)              |
| `customer_id`    | String        | Yes      | -         | Reference to User (FK)                   |
| `customer_name`  | String        | Yes      | -         | Customer's name (denormalized)           |
| `customer_email` | String        | Yes      | -         | Customer's email (denormalized)          |
| `customer_phone` | String        | No       | null      | Customer's phone (denormalized)          |
| `services`       | List<Service> | Yes      | -         | List of booked services                  |
| `start_time`     | DateTime      | Yes      | -         | Appointment start time                   |
| `end_time`       | DateTime      | Yes      | -         | Appointment end time (calculated)        |
| `status`         | BookingStatus | Yes      | pending   | Current booking status                   |
| `total_price`    | Double        | Yes      | -         | Sum of all service prices                |
| `currency`       | String        | Yes      | EUR       | Currency code (ISO 4217)                 |
| `notes`          | String        | No       | null      | Additional notes from customer           |
| `operator_id`    | String        | No       | null      | Assigned operator (FK)                   |
| `operator_name`  | String        | No       | null      | Operator's name (denormalized)           |
| `created_at`     | DateTime      | Yes      | now()     | Booking creation timestamp               |
| `updated_at`     | DateTime      | No       | null      | Last update timestamp                    |

#### BookingStatus Enum

```dart
enum BookingStatus {
  pending,    // Booking created, awaiting confirmation
  confirmed,  // Booking confirmed by operator/system
  cancelled,  // Booking cancelled by customer or operator
  completed,  // Service has been provided
  noShow,     // Customer didn't show up
}
```

#### Status Transitions

```
                    ┌───────────┐
                    │  pending  │
                    └─────┬─────┘
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
        ┌──────────┐ ┌──────────┐ ┌───────────┐
        │confirmed │ │cancelled │ │  noShow   │
        └────┬─────┘ └──────────┘ └───────────┘
             │
     ┌───────┼───────┐
     ▼       ▼       ▼
┌──────────┐ │ ┌───────────┐
│completed │ │ │  noShow   │
└──────────┘ │ └───────────┘
             ▼
       ┌──────────┐
       │cancelled │
       └──────────┘
```

#### Validation Rules

| Field          | Rule                                                  |
|----------------|-------------------------------------------------------|
| `customer_id`  | Valid UUID, must exist in users table                 |
| `services`     | At least 1 service, all must be active                |
| `start_time`   | Must be in the future, during business hours          |
| `end_time`     | Calculated from start_time + total service duration   |
| `total_price`  | Calculated sum of all service prices, >= 0            |
| `currency`     | Valid ISO 4217 code (EUR, USD, GBP, etc.)             |
| `notes`        | Max 500 characters                                    |

#### Business Rules

1. **Minimum Notice**: Booking must be at least 1 hour in advance
2. **Cancellation Policy**: Free cancellation up to 2 hours before appointment
3. **No Overlap**: Bookings cannot overlap for the same operator
4. **Business Hours**: Bookings only during configured operating hours
5. **Service Availability**: Only active services can be booked

#### JSON Example

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "customer_id": "550e8400-e29b-41d4-a716-446655440000",
  "customer_name": "Mario Rossi",
  "customer_email": "mario.rossi@email.com",
  "customer_phone": "+39 333 1234567",
  "services": [
    {
      "id": "770e8400-e29b-41d4-a716-446655440001",
      "name": "Taglio Classico",
      "description": "Taglio di capelli classico con shampoo",
      "duration_minutes": 30,
      "price": 20.00,
      "currency": "EUR",
      "is_active": true
    }
  ],
  "start_time": "2025-03-25T10:00:00Z",
  "end_time": "2025-03-25T10:30:00Z",
  "status": "confirmed",
  "total_price": 20.00,
  "currency": "EUR",
  "notes": "Preferisco una rasatura corta sui lati",
  "operator_id": "880e8400-e29b-41d4-a716-446655440001",
  "operator_name": "Giuseppe Verdi",
  "created_at": "2025-03-20T14:30:00Z",
  "updated_at": "2025-03-20T15:00:00Z"
}
```

---

### 4. Service Entity

Represents a service offered by the barber shop.

#### Schema

| Field            | Type    | Required | Default | Description                           |
|------------------|---------|----------|---------|---------------------------------------|
| `id`             | String  | Yes      | UUID    | Unique identifier (UUID v4)           |
| `name`           | String  | Yes      | -       | Service name                          |
| `description`    | String  | Yes      | -       | Detailed description                  |
| `duration_minutes` | Int   | Yes      | -       | Service duration in minutes           |
| `price`          | Double  | Yes      | -       | Service price                         |
| `currency`       | String  | Yes      | EUR     | Currency code (ISO 4217)              |
| `is_active`      | Boolean | Yes      | true    | Whether service is available          |

#### Validation Rules

| Field             | Rule                                    |
|-------------------|-----------------------------------------|
| `name`            | Min 2 chars, max 100 chars, unique      |
| `description`     | Min 10 chars, max 500 chars             |
| `duration_minutes`| Min 15, max 480 (8 hours), multiple of 15|
| `price`           | >= 0, max 2 decimal places              |
| `currency`        | Valid ISO 4217 code                     |

#### JSON Example

```json
{
  "id": "770e8400-e29b-41d4-a716-446655440001",
  "name": "Taglio Classico",
  "description": "Taglio di capelli classico con shampoo e styling finale. Include consulenza personalizzata per la scelta del taglio più adatto.",
  "duration_minutes": 30,
  "price": 20.00,
  "currency": "EUR",
  "is_active": true
}
```

---

### 5. TimeSlot Entity

Represents an available time slot for booking appointments.

#### Schema

| Field          | Type     | Required | Description                           |
|----------------|----------|----------|---------------------------------------|
| `start_time`   | DateTime | Yes      | Slot start time                       |
| `end_time`     | DateTime | Yes      | Slot end time                         |
| `is_available` | Boolean  | Yes      | Whether slot is available             |
| `operator_id`  | String   | No       | Specific operator (if assigned)       |
| `operator_name`| String   | No       | Operator's name                       |

#### Validation Rules

| Field        | Rule                                      |
|--------------|-------------------------------------------|
| `start_time` | Valid datetime, within business hours     |
| `end_time`   | Must be after start_time                  |
| `operator_id`| Valid UUID if provided                    |

#### JSON Example

```json
{
  "start_time": "2025-03-25T10:00:00Z",
  "end_time": "2025-03-25T10:30:00Z",
  "is_available": true,
  "operator_id": "880e8400-e29b-41d4-a716-446655440001",
  "operator_name": "Giuseppe Verdi"
}
```

---

## 🔗 API Endpoints & Contracts

### Authentication Endpoints

| Method | Endpoint                    | Description                    | Auth Required |
|--------|----------------------------|--------------------------------|---------------|
| POST   | `/auth/login`              | User login                     | No            |
| POST   | `/auth/register`           | User registration              | No            |
| POST   | `/auth/logout`             | User logout                    | Yes           |
| GET    | `/auth/me`                 | Get current user               | Yes           |
| POST   | `/auth/refresh`            | Refresh access token           | No            |
| POST   | `/auth/password/reset/request` | Request password reset     | No            |
| POST   | `/auth/password/reset`     | Reset password with token      | No            |

### Booking Endpoints

| Method | Endpoint                   | Description                    | Auth Required |
|--------|---------------------------|--------------------------------|---------------|
| GET    | `/bookings`               | Get customer bookings          | Yes           |
| GET    | `/bookings/{id}`          | Get booking by ID              | Yes           |
| POST   | `/bookings`               | Create new booking             | Yes           |
| PUT    | `/bookings/{id}`          | Update booking                 | Yes           |
| DELETE | `/bookings/{id}`          | Cancel booking                 | Yes           |
| GET    | `/bookings/slots`         | Get available time slots       | Yes           |
| GET    | `/bookings/date-range`    | Get bookings in date range     | Yes           |

### Service Endpoints

| Method | Endpoint                   | Description                    | Auth Required |
|--------|---------------------------|--------------------------------|---------------|
| GET    | `/services`               | Get all available services     | Yes           |

---

## 🛡️ Data Integrity Rules

### Foreign Key Constraints

| Table        | Column        | References        | On Delete   |
|--------------|---------------|-------------------|-------------|
| booking      | customer_id   | user.id           | RESTRICT    |
| booking      | operator_id   | user.id           | SET NULL    |
| booking_service | booking_id | booking.id        | CASCADE     |
| booking_service | service_id | service.id        | RESTRICT    |

### Unique Constraints

| Table   | Columns                           |
|---------|-----------------------------------|
| user    | email                             |
| service | name                              |

### Index Recommendations

| Table   | Columns                           | Type       |
|---------|-----------------------------------|------------|
| user    | email                             | UNIQUE     |
| booking | customer_id                       | INDEX      |
| booking | operator_id                       | INDEX      |
| booking | start_time, end_time              | INDEX      |
| booking | status                            | INDEX      |
| service | is_active                         | INDEX      |

---

## 📏 Business Rules Summary

### Booking Rules

1. **Minimum Advance Booking**: 1 hour before appointment
2. **Maximum Advance Booking**: 30 days in advance
3. **Cancellation Policy**: 
   - Free cancellation: Up to 2 hours before appointment
   - Late cancellation: May incur penalties
4. **Modification Policy**: Same rules as cancellation
5. **No-Show Policy**: Marked as `noShow` status after grace period (15 min)

### Service Rules

1. **Duration Increments**: 15-minute increments only
2. **Price Format**: Always 2 decimal places
3. **Active Services Only**: Only active services can be booked
4. **Multiple Services**: Allowed, durations are cumulative

### Operating Hours (Configurable)

| Day       | Open   | Close  | Notes           |
|-----------|--------|--------|-----------------|
| Monday    | CLOSED | CLOSED | Rest day        |
| Tuesday   | 09:00  | 19:00  |                 |
| Wednesday | 09:00  | 19:00  |                 |
| Thursday  | 09:00  | 19:00  |                 |
| Friday    | 09:00  | 20:00  | Extended hours  |
| Saturday  | 08:00  | 18:00  |                 |
| Sunday    | CLOSED | CLOSED | Rest day        |

---

## 🔐 Security Considerations

### Data Encryption

| Data Type          | At Rest     | In Transit |
|--------------------|-------------|------------|
| Passwords          | bcrypt hash | TLS 1.3    |
| Tokens             | Encrypted   | TLS 1.3    |
| Personal Data (PII)| Encrypted   | TLS 1.3    |
| API Communications | -           | TLS 1.3    |

### Access Control

| Role     | Users | Own Bookings | All Bookings | Services | System |
|----------|-------|--------------|--------------|----------|--------|
| Customer | Read  | CRUD         | -            | Read     | -      |
| Operator | Read  | CRUD         | Read/Update  | Read     | -      |
| Admin    | CRUD  | CRUD         | CRUD         | CRUD     | CRUD   |

### GDPR Compliance

1. **Data Minimization**: Only collect necessary data
2. **Purpose Limitation**: Data used only for booking services
3. **Storage Limitation**: Data retained for legal requirements
4. **Right to Access**: Users can export their data
5. **Right to Erasure**: Users can request account deletion

---

## 📝 Notes for Backend Implementation

### Database Technology Recommendations

| Option          | Pros                               | Cons                        |
|-----------------|------------------------------------|-----------------------------|
| PostgreSQL      | ACID, robust, JSON support         | Self-hosted complexity      |
| Firebase Firestore | Real-time, serverless           | NoSQL limitations           |
| Supabase        | PostgreSQL + real-time + auth      | Newer platform              |

### Cache Strategy

| Data Type    | Cache TTL | Invalidation             |
|--------------|-----------|--------------------------|
| Services     | 1 hour    | On service update        |
| User Profile | 5 minutes | On profile update        |
| Time Slots   | 1 minute  | On booking create/update |

### Error Codes

| Code | Status | Description                    |
|------|--------|--------------------------------|
| 400  | Bad Request | Invalid input data        |
| 401  | Unauthorized | Authentication required  |
| 403  | Forbidden | Insufficient permissions    |
| 404  | Not Found | Resource not found          |
| 409  | Conflict | Booking time conflict        |
| 422  | Unprocessable | Validation failed        |
| 500  | Server Error | Internal server error    |

---

## 🔄 Version History

| Version | Date       | Changes                                    |
|---------|------------|--------------------------------------------|
| 1.0.0   | 2025-11-25 | Initial database schema documentation      |

---

## 📚 Related Documentation

- [ARCHITECTURE.md](./ARCHITECTURE.md) - Application architecture
- [SECURITY_RULES.md](./SECURITY_RULES.md) - Security rules and validation
- [IMPLEMENTATION.md](./IMPLEMENTATION.md) - Implementation details
- [DEVELOPMENT.md](./DEVELOPMENT.md) - Development guide
