import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

/// Data model for Service
@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    required double price,
    required String currency,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ServiceModel;

  const ServiceModel._();

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);

  /// Convert to domain entity
  Service toEntity() {
    return Service(
      id: id,
      name: name,
      description: description,
      durationMinutes: durationMinutes,
      price: price,
      currency: currency,
      isActive: isActive,
    );
  }

  /// Create from domain entity
  factory ServiceModel.fromEntity(Service entity) {
    return ServiceModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      durationMinutes: entity.durationMinutes,
      price: entity.price,
      currency: entity.currency,
      isActive: entity.isActive,
    );
  }
}
