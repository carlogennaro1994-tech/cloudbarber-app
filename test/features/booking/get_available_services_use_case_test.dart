import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';
import 'package:cloudbarber/features/booking/domain/usecases/get_available_services_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  test('GetAvailableServicesUseCase filters inactive and sorts by name', () async {
    final repo = _MockBookingRepository();
    final useCase = GetAvailableServicesUseCase(repo);

    when(repo.getAvailableServices).thenAnswer((_) async => const [
          Service(
            id: '2',
            name: 'Beard',
            description: 'Beard trim',
            durationMinutes: 15,
            price: 10.0,
            currency: 'EUR',
            isActive: false,
          ),
          Service(
            id: '1',
            name: 'Cut',
            description: 'Hair cut',
            durationMinutes: 30,
            price: 20.0,
            currency: 'EUR',
          ),
          Service(
            id: '3',
            name: 'Color',
            description: 'Hair color',
            durationMinutes: 60,
            price: 40.0,
            currency: 'EUR',
          ),
        ],);

    final result = await useCase();

    expect(result.length, 2);
    expect(result.first.name, 'Color');
    expect(result.last.name, 'Cut');
  });
}

