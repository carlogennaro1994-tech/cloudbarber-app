# Features Documentation

This directory contains all the feature modules of the CloudBarber application, organized following Clean Architecture principles.

## Structure

Each feature is divided into three layers:

```
feature_name/
├── data/           # Data layer
│   ├── datasources/    # Remote and local data sources
│   ├── models/         # Data models with JSON serialization
│   └── repositories/   # Repository implementations
├── domain/         # Domain layer (Business logic)
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Use cases (business operations)
└── presentation/   # Presentation layer
    ├── pages/          # UI pages/screens
    ├── widgets/        # Reusable UI components
    └── providers/      # Riverpod state providers
```

## Implemented Features

### 1. Authentication (`auth/`)

Handles user authentication and authorization.

**Entities:**
- `User` - Represents a user in the system
- `AuthToken` - Represents authentication tokens

**Use Cases:**
- `LoginUseCase` - Login with email and password
- `RegisterUseCase` - Register a new user
- `LogoutUseCase` - Logout the current user
- `GetCurrentUserUseCase` - Get the authenticated user

**Pages:**
- `LoginPage` - User login screen
- `RegisterPage` - User registration screen

**Providers:**
- `authStateProvider` - Manages authentication state
- `currentUserProvider` - Provides current user information

### 2. Booking (`booking/`)

Manages booking operations, services, and time slots.

**Entities:**
- `Booking` - Represents a customer booking
- `Service` - Represents a service offered by the barber shop
- `TimeSlot` - Represents an available time slot

**Use Cases:**
- `CreateBookingUseCase` - Create a new booking
- `GetCustomerBookingsUseCase` - Get all bookings for a customer
- `CancelBookingUseCase` - Cancel an existing booking
- `GetAvailableServicesUseCase` - Get all available services
- `GetAvailableSlotsUseCase` - Get available time slots for booking

**Pages:**
- `BookingListPage` - List of customer bookings
- `BookingDetailPage` - Detailed view of a booking
- `NewBookingPage` - Create a new booking
- `ServicesPage` - Browse available services

**Providers:**
- `bookingStateProvider` - Manages booking operations state
- `bookingsProvider` - Provides list of bookings
- `availableServicesProvider` - Provides available services
- `availableSlotsProvider` - Provides available time slots

### 3. Profile (`profile/`)

Manages user profile information.

**Use Cases:**
- `GetProfileUseCase` - Get user profile
- `UpdateProfileUseCase` - Update user profile

**Pages:**
- `ProfilePage` - User profile screen with menu

## Key Features Implemented

### Multi-Service Booking ✅
Users can select multiple services when creating a booking. The system calculates the total duration and price automatically.

### Service Catalog ✅
A comprehensive service catalog showing:
- Service name and description
- Duration in minutes
- Price with currency
- Active/inactive status

### Time Slot Management ✅
Intelligent time slot calculation based on:
- Selected services duration
- Existing bookings
- Operating hours
- Operator availability

### Booking Status Management ✅
Bookings can have multiple statuses:
- `pending` - Booking created but not confirmed
- `confirmed` - Booking confirmed by operator
- `cancelled` - Booking cancelled
- `completed` - Service completed
- `noShow` - Customer didn't show up

### Validation Rules ✅

**Booking Creation:**
- Start time must be in the future
- At least one service must be selected
- Customer information required

**Booking Cancellation:**
- Only pending/confirmed bookings can be cancelled
- Must be cancelled at least 2 hours before start time

**Authentication:**
- Email format validation
- Password minimum 6 characters
- Name minimum 2 characters
- Phone number format validation

## State Management

All features use Riverpod for state management:

- **Providers** - For dependency injection and data access
- **StateNotifiers** - For managing mutable state
- **FutureProviders** - For asynchronous data loading
- **Family modifiers** - For parameterized providers

## API Integration

All features are ready for backend integration via Retrofit API clients:

- `AuthApiClient` - Authentication endpoints
- `BookingApiClient` - Booking and services endpoints

The API base URL is configured in `lib/core/injection_container.dart`.

## Localization

All features support internationalization (i18n) with:
- English (en)
- Italian (it)

Translations are defined in `lib/l10n/app_en.arb` and `lib/l10n/app_it.arb`.

## Next Steps

To complete the implementation:

1. **Run code generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Generate localization:**
   ```bash
   flutter gen-l10n
   ```

3. **Connect to backend API:**
   - Update API base URL in injection_container.dart
   - Implement proper error handling
   - Add token refresh logic

4. **Add notifications:**
   - Booking confirmation notifications
   - Cancellation notifications
   - Reminder notifications (e.g., 24 hours before)

5. **Add calendar view:**
   - Daily agenda view
   - Weekly agenda view
   - Monthly calendar view

6. **Add operator features:**
   - Manual appointment insertion
   - Manage operating hours
   - Manage closures/holidays

7. **Add tests:**
   - Unit tests for use cases
   - Widget tests for UI
   - Integration tests

## Dependencies

Key dependencies used:
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `get_it` - Dependency injection
- `dio` - HTTP client
- `retrofit` - REST API client
- `freezed` - Code generation for data classes
- `json_serializable` - JSON serialization
- `flutter_secure_storage` - Secure token storage
