import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/data/models/service_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Data model for Booking
@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_email') required String customerEmail,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    required List<ServiceModel> services,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    required BookingStatus status,
    @JsonKey(name: 'total_price') required double totalPrice,
    required String currency,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'operator_id') String? operatorId,
    @JsonKey(name: 'operator_name') String? operatorName,
  }) = _BookingModel;

  const BookingModel._();

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  /// Convert to domain entity
  Booking toEntity() {
    return Booking(
      id: id,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      services: services.map((s) => s.toEntity()).toList(),
      startTime: startTime,
      endTime: endTime,
      status: status,
      totalPrice: totalPrice,
      currency: currency,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      operatorId: operatorId,
      operatorName: operatorName,
    );
  }

  /// Create from domain entity
  factory BookingModel.fromEntity(Booking entity) {
    return BookingModel(
      id: entity.id,
      customerId: entity.customerId,
      customerName: entity.customerName,
      customerEmail: entity.customerEmail,
      customerPhone: entity.customerPhone,
      services: entity.services.map((s) => ServiceModel.fromEntity(s)).toList(),
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      totalPrice: entity.totalPrice,
      currency: entity.currency,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      operatorId: entity.operatorId,
      operatorName: entity.operatorName,
    );
  }
}
