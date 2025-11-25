import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// Represents the status of a booking
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  noShow,
}

/// Represents a booking made by a customer
@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String customerId,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    required List<Service> services,
    required DateTime startTime,
    required DateTime endTime,
    required BookingStatus status,
    required double totalPrice,
    required String currency,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? operatorId,
    String? operatorName,
  }) = _Booking;

  const Booking._();

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  /// Returns the total duration of the booking in minutes
  int get durationMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Returns whether the booking can be cancelled
  bool get canBeCancelled {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }

  /// Returns whether the booking can be modified
  bool get canBeModified {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }
}
