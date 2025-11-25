import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';

/// Use case for creating a new booking
class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Booking> call({
    required String customerId,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    required List<String> serviceIds,
    required DateTime startTime,
    String? notes,
    String? operatorId,
  }) async {
    // Validate that the start time is in the future
    if (startTime.isBefore(DateTime.now())) {
      throw ArgumentError('Start time must be in the future');
    }

    // Validate that at least one service is selected
    if (serviceIds.isEmpty) {
      throw ArgumentError('At least one service must be selected');
    }

    return await repository.createBooking(
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      serviceIds: serviceIds,
      startTime: startTime,
      notes: notes,
      operatorId: operatorId,
    );
  }
}
