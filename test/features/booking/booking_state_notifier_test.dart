import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/features/booking/domain/usecases/cancel_booking_use_case.dart';
import 'package:cloudbarber/features/booking/domain/usecases/create_booking_use_case.dart';
import 'package:cloudbarber/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

class _MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

void main() {
  late _MockCreateBookingUseCase create;
  late _MockCancelBookingUseCase cancel;
  late BookingStateNotifier notifier;

  setUp(() {
    create = _MockCreateBookingUseCase();
    cancel = _MockCancelBookingUseCase();
    notifier = BookingStateNotifier(create, cancel);
  });

  test('createBooking success sets successMessage and booking', () async {
    final now = DateTime.now().add(const Duration(hours: 3));
    final booking = Booking(
      id: 'b1',
      customerId: 'c1',
      customerName: 'John Doe',
      customerEmail: 'john@doe.com',
      services: const [
        Service(
          id: 's1',
          name: 'Cut',
          description: 'Hair cut',
          durationMinutes: 30,
          price: 20.0,
          currency: 'EUR',
        ),
      ],
      startTime: now,
      endTime: now.add(const Duration(minutes: 30)),
      status: BookingStatus.confirmed,
      totalPrice: 20.0,
      currency: 'EUR',
      createdAt: DateTime.now(),
    );

    when(() => create(
          customerId: any(named: 'customerId'),
          customerName: any(named: 'customerName'),
          customerEmail: any(named: 'customerEmail'),
          customerPhone: any(named: 'customerPhone'),
          serviceIds: any(named: 'serviceIds'),
          startTime: any(named: 'startTime'),
          notes: any(named: 'notes'),
          operatorId: any(named: 'operatorId'),
        )).thenAnswer((_) async => booking);

    await notifier.createBooking(
      customerId: 'c1',
      customerName: 'John Doe',
      customerEmail: 'john@doe.com',
      serviceIds: const ['s1'],
      startTime: now,
    );

    expect(notifier.state.isLoading, false);
    expect(notifier.state.createdBooking, isNotNull);
    expect(notifier.state.successMessage, isNotNull);
    expect(notifier.state.errorMessage, isNull);
  });

  test('cancelBooking failure sets error', () async {
    when(() => cancel(any())).thenThrow(StateError('Cannot cancel'));

    await notifier.cancelBooking('b1');

    expect(notifier.state.isLoading, false);
    expect(notifier.state.errorMessage, contains('Cannot cancel'));
  });
}

