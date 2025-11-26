import 'package:json_annotation/json_annotation.dart';

part 'time_slot_model.g.dart';

@JsonSerializable()
class TimeSlotModel {
  final String start;
  final String end;
  final bool available;

  TimeSlotModel({
    required this.start,
    required this.end,
    required this.available,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);
}