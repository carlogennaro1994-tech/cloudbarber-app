import 'package:cloudbarber/features/booking/domain/entities/time_slot.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';

/// Use case for getting available time slots
class GetAvailableSlotsUseCase {
  final BookingRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<List<TimeSlot>> call({
    required DateTime date,
    required List<String> serviceIds,
    String? operatorId,
  }) async {
    if (serviceIds.isEmpty) {
      throw ArgumentError('At least one service must be selected');
    }

    // Validate that the date is not in the past
    final today = DateTime.now();
    final requestedDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    if (requestedDate.isBefore(todayDate)) {
      throw ArgumentError('Cannot get slots for past dates');
    }

    final slots = await repository.getAvailableSlots(
      date: date,
      serviceIds: serviceIds,
      operatorId: operatorId,
    );

    // Filter only available slots
    final availableSlots = slots.where((slot) => slot.isAvailable).toList();
    
    // If it's today, filter out slots that have already passed
    if (requestedDate.isAtSameMomentAs(todayDate)) {
      final now = DateTime.now();
      return availableSlots.where((slot) => slot.startTime.isAfter(now)).toList();
    }
    
    return availableSlots;
  }
}
