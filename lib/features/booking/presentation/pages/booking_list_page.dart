import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloudbarber/app/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingListPage extends ConsumerWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookings),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go(AppRoutes.profile);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Placeholder count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              title: Text('Booking #${index + 1}'),
              subtitle: Text('Date: ${DateTime.now().add(Duration(days: index)).toString().substring(0, 10)}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.go(AppRoutes.bookingDetail.replaceAll(':id', '${index + 1}'));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to new booking page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.newBooking)),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newBooking),
      ),
    );
  }
}
