import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/features/booking/domain/entities/time_slot.dart';

/// Repository interface for booking operations
abstract class BookingRepository {
  /// Get all bookings for a customer
  Future<List<Booking>> getCustomerBookings(String customerId);

  /// Get a specific booking by ID
  Future<Booking> getBookingById(String bookingId);

  /// Create a new booking
  Future<Booking> createBooking({
    required String customerId,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    required List<String> serviceIds,
    required DateTime startTime,
    String? notes,
    String? operatorId,
  });

  /// Update an existing booking
  Future<Booking> updateBooking({
    required String bookingId,
    required DateTime startTime,
    List<String>? serviceIds,
    String? notes,
  });

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId);

  /// Get all available services
  Future<List<Service>> getAvailableServices();

  /// Get available time slots for booking
  Future<List<TimeSlot>> getAvailableSlots({
    required DateTime date,
    required List<String> serviceIds,
    String? operatorId,
  });

  /// Get bookings for a specific date range
  Future<List<Booking>> getBookingsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? operatorId,
  });
}
