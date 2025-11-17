import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloudbarber/features/auth/presentation/pages/login_page.dart';
import 'package:cloudbarber/features/auth/presentation/pages/register_page.dart';
import 'package:cloudbarber/features/booking/presentation/pages/booking_list_page.dart';
import 'package:cloudbarber/features/booking/presentation/pages/booking_detail_page.dart';
import 'package:cloudbarber/features/booking/presentation/pages/new_booking_page.dart';
import 'package:cloudbarber/features/profile/presentation/pages/profile_page.dart';

// Routes
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String bookingList = '/bookings';
  static const String bookingDetail = '/bookings/:id';
  static const String newBooking = '/bookings/new';
  static const String profile = '/profile';
}

// Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Booking Routes
      GoRoute(
        path: AppRoutes.bookingList,
        name: 'bookingList',
        builder: (context, state) => const BookingListPage(),
      ),
      GoRoute(
        path: AppRoutes.newBooking,
        name: 'newBooking',
        builder: (context, state) => const NewBookingPage(),
      ),
      GoRoute(
        path: AppRoutes.bookingDetail,
        name: 'bookingDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return BookingDetailPage(bookingId: id);
        },
      ),
      
      // Profile Routes
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
});
