import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudbarber/core/injection_container.dart';
import 'package:cloudbarber/features/booking/domain/entities/booking.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/features/booking/domain/entities/time_slot.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';
import 'package:cloudbarber/features/booking/domain/usecases/create_booking_use_case.dart';
import 'package:cloudbarber/features/booking/domain/usecases/get_customer_bookings_use_case.dart';
import 'package:cloudbarber/features/booking/domain/usecases/cancel_booking_use_case.dart';
import 'package:cloudbarber/features/booking/domain/usecases/get_available_services_use_case.dart';
import 'package:cloudbarber/features/booking/domain/usecases/get_available_slots_use_case.dart';

// Repository provider
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return getIt<BookingRepository>();
});

// Use case providers
final createBookingUseCaseProvider = Provider<CreateBookingUseCase>((ref) {
  return CreateBookingUseCase(ref.watch(bookingRepositoryProvider));
});

final getCustomerBookingsUseCaseProvider = Provider<GetCustomerBookingsUseCase>((ref) {
  return GetCustomerBookingsUseCase(ref.watch(bookingRepositoryProvider));
});

final cancelBookingUseCaseProvider = Provider<CancelBookingUseCase>((ref) {
  return CancelBookingUseCase(ref.watch(bookingRepositoryProvider));
});

final getAvailableServicesUseCaseProvider = Provider<GetAvailableServicesUseCase>((ref) {
  return GetAvailableServicesUseCase(ref.watch(bookingRepositoryProvider));
});

final getAvailableSlotsUseCaseProvider = Provider<GetAvailableSlotsUseCase>((ref) {
  return GetAvailableSlotsUseCase(ref.watch(bookingRepositoryProvider));
});

// Bookings list provider
final bookingsProvider = FutureProvider.family<List<Booking>, String>((ref, customerId) async {
  final useCase = ref.watch(getCustomerBookingsUseCaseProvider);
  return await useCase(customerId);
});

// Available services provider
final availableServicesProvider = FutureProvider<List<Service>>((ref) async {
  final useCase = ref.watch(getAvailableServicesUseCaseProvider);
  return await useCase();
});

// Available slots provider
final availableSlotsProvider = FutureProvider.family<List<TimeSlot>, SlotsParams>(
  (ref, params) async {
    final useCase = ref.watch(getAvailableSlotsUseCaseProvider);
    return await useCase(
      date: params.date,
      serviceIds: params.serviceIds,
      operatorId: params.operatorId,
    );
  },
);

/// Parameters for slots request
class SlotsParams {
  final DateTime date;
  final List<String> serviceIds;
  final String? operatorId;

  SlotsParams({
    required this.date,
    required this.serviceIds,
    this.operatorId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlotsParams &&
        other.date == date &&
        other.serviceIds.length == serviceIds.length &&
        other.serviceIds.every((id) => serviceIds.contains(id)) &&
        other.operatorId == operatorId;
  }

  @override
  int get hashCode => date.hashCode ^ serviceIds.hashCode ^ operatorId.hashCode;
}

// Booking state provider
final bookingStateProvider = StateNotifierProvider<BookingStateNotifier, BookingState>((ref) {
  return BookingStateNotifier(
    ref.watch(createBookingUseCaseProvider),
    ref.watch(cancelBookingUseCaseProvider),
  );
});

/// Booking state
class BookingState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Booking? createdBooking;

  BookingState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.createdBooking,
  });

  BookingState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    Booking? createdBooking,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      createdBooking: createdBooking ?? this.createdBooking,
    );
  }
}

/// Booking state notifier
class BookingStateNotifier extends StateNotifier<BookingState> {
  final CreateBookingUseCase _createBookingUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;

  BookingStateNotifier(
    this._createBookingUseCase,
    this._cancelBookingUseCase,
  ) : super(BookingState());

  Future<void> createBooking({
    required String customerId,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    required List<String> serviceIds,
    required DateTime startTime,
    String? notes,
    String? operatorId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final booking = await _createBookingUseCase(
        customerId: customerId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        serviceIds: serviceIds,
        startTime: startTime,
        notes: notes,
        operatorId: operatorId,
      );
      state = state.copyWith(
        isLoading: false,
        createdBooking: booking,
        successMessage: 'Booking created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await _cancelBookingUseCase(bookingId);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Booking cancelled successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
