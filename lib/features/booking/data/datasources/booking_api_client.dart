import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:cloudbarber/features/booking/data/models/booking_model.dart';
import 'package:cloudbarber/features/booking/data/models/service_model.dart';

part 'booking_api_client.g.dart';

@RestApi()
abstract class BookingApiClient {
  factory BookingApiClient(Dio dio, {String baseUrl}) = _BookingApiClient;

  @GET('/bookings')
  Future<List<BookingModel>> getCustomerBookings(
    @Query('customer_id') String customerId,
  );

  @GET('/bookings/{id}')
  Future<BookingModel> getBookingById(@Path('id') String bookingId);

  @POST('/bookings')
  Future<BookingModel> createBooking(@Body() Map<String, dynamic> body);

  @PUT('/bookings/{id}')
  Future<BookingModel> updateBooking(
    @Path('id') String bookingId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/bookings/{id}')
  Future<void> cancelBooking(@Path('id') String bookingId);

  @GET('/services')
  Future<List<ServiceModel>> getAvailableServices();

  @GET('/bookings/slots')
  Future<List<Map<String, dynamic>>> getAvailableSlots(
    @Query('date') String date,
    @Query('service_ids') String serviceIds,
    @Query('operator_id') String? operatorId,
  );

  @GET('/bookings/date-range')
  Future<List<BookingModel>> getBookingsByDateRange(
    @Query('start_date') String startDate,
    @Query('end_date') String endDate,
    @Query('operator_id') String? operatorId,
  );
}
