import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';

/// Use case for cancelling a booking
class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> call(String bookingId) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty');
    }

    // Get the booking to validate it can be cancelled
    final booking = await repository.getBookingById(bookingId);
    
    if (!booking.canBeCancelled) {
      throw StateError('Booking cannot be cancelled in its current status: ${booking.status}');
    }

    // Check if booking is not too close to start time (e.g., at least 2 hours before)
    final hoursUntilStart = booking.startTime.difference(DateTime.now()).inHours;
    if (hoursUntilStart < 2) {
      throw StateError('Booking cannot be cancelled less than 2 hours before start time');
    }

    await repository.cancelBooking(bookingId);
  }
}
