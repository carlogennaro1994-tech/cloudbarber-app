import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

/// Represents a service offered by the barber shop
@freezed
class Service with _$Service {
  const factory Service({
    required String id,
    required String name,
    required String description,
    required int durationMinutes,
    required double price,
    required String currency,
    @Default(true) bool isActive,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
}
