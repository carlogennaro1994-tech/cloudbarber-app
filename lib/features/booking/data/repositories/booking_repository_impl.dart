import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/features/booking/domain/entities/time_slot.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';
import 'package:cloudbarber/features/booking/data/datasources/booking_api_client.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  final BookingApiClient apiClient;

  BookingRepositoryImpl(this.apiClient);

  @override
  Future<List<Booking>> getCustomerBookings(String customerId) async {
    try {
      final models = await apiClient.getCustomerBookings(customerId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get customer bookings: $e');
    }
  }

  @override
  Future<Booking> getBookingById(String bookingId) async {
    try {
      final model = await apiClient.getBookingById(bookingId);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  @override
  Future<Booking> createBooking({
    required String customerId,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    required List<String> serviceIds,
    required DateTime startTime,
    String? notes,
    String? operatorId,
  }) async {
    try {
      final body = {
        'customer_id': customerId,
        'customer_name': customerName,
        'customer_email': customerEmail,
        if (customerPhone != null) 'customer_phone': customerPhone,
        'service_ids': serviceIds,
        'start_time': startTime.toIso8601String(),
        if (notes != null) 'notes': notes,
        if (operatorId != null) 'operator_id': operatorId,
      };

      final model = await apiClient.createBooking(body);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<Booking> updateBooking({
    required String bookingId,
    required DateTime startTime,
    List<String>? serviceIds,
    String? notes,
  }) async {
    try {
      final body = {
        'start_time': startTime.toIso8601String(),
        if (serviceIds != null) 'service_ids': serviceIds,
        if (notes != null) 'notes': notes,
      };

      final model = await apiClient.updateBooking(bookingId, body);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await apiClient.cancelBooking(bookingId);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  @override
  Future<List<Service>> getAvailableServices() async {
    try {
      final models = await apiClient.getAvailableServices();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get available services: $e');
    }
  }

  @override
  Future<List<TimeSlot>> getAvailableSlots({
    required DateTime date,
    required List<String> serviceIds,
    String? operatorId,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final serviceIdsStr = serviceIds.join(',');

      final slots = await apiClient.getAvailableSlots(
        dateStr,
        serviceIdsStr,
        operatorId,
      );

      return slots.map((slot) {
        return TimeSlot(
          startTime: DateTime.parse(slot['start_time']),
          endTime: DateTime.parse(slot['end_time']),
          isAvailable: slot['is_available'] ?? true,
          operatorId: slot['operator_id'],
          operatorName: slot['operator_name'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get available slots: $e');
    }
  }

  @override
  Future<List<Booking>> getBookingsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? operatorId,
  }) async {
    try {
      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];

      final models = await apiClient.getBookingsByDateRange(
        startDateStr,
        endDateStr,
        operatorId,
      );

      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get bookings by date range: $e');
    }
  }
}
