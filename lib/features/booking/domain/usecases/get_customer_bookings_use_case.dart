import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';

/// Use case for getting customer bookings
class GetCustomerBookingsUseCase {
  final BookingRepository repository;

  GetCustomerBookingsUseCase(this.repository);

  Future<List<Booking>> call(String customerId) async {
    if (customerId.isEmpty) {
      throw ArgumentError('Customer ID cannot be empty');
    }

    final bookings = await repository.getCustomerBookings(customerId);
    
    // Sort bookings by start time (most recent first)
    bookings.sort((a, b) => b.startTime.compareTo(a.startTime));
    
    return bookings;
  }
}
