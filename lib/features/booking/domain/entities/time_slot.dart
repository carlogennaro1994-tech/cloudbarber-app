import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';
part 'time_slot.g.dart';

/// Represents an available time slot for booking
@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required DateTime startTime,
    required DateTime endTime,
    required bool isAvailable,
    String? operatorId,
    String? operatorName,
  }) = _TimeSlot;

  const TimeSlot._();

  factory TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);

  /// Returns the duration of the slot in minutes
  int get durationMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Checks if this slot overlaps with another time period
  bool overlaps(DateTime start, DateTime end) {
    return startTime.isBefore(end) && endTime.isAfter(start);
  }
}
