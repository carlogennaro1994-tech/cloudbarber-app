import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloudbarber/features/booking/presentation/providers/booking_provider.dart';
import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/l10n/app_localizations.dart';

class NewBookingPage extends ConsumerStatefulWidget {
  const NewBookingPage({super.key});

  @override
  ConsumerState<NewBookingPage> createState() => _NewBookingPageState();
}

class _NewBookingPageState extends ConsumerState<NewBookingPage> {
  final List<String> _selectedServiceIds = [];
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleCreateBooking() {
    if (_selectedServiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service')),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time')),
      );
      return;
    }

    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // TODO: Get actual customer info from auth state
    ref.read(bookingStateProvider.notifier).createBooking(
          customerId: 'customer_123',
          customerName: 'John Doe',
          customerEmail: 'john.doe@example.com',
          serviceIds: _selectedServiceIds,
          startTime: startTime,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final servicesAsync = ref.watch(availableServicesProvider);
    final bookingState = ref.watch(bookingStateProvider);

    // Listen to booking state changes
    ref.listen<BookingState>(bookingStateProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        context.pop();
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newBooking),
      ),
      body: servicesAsync.when(
        data: (services) => _buildForm(context, services, theme, l10n, bookingState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading services: $error'),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<Service> services,
    ThemeData theme,
    AppLocalizations l10n,
    BookingState bookingState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Services section
          Text(
            'Select Services',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...services.map((service) => _buildServiceCard(service, theme)),
          const SizedBox(height: 24),

          // Date section
          Text(
            'Select Date & Time',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_selectedDate.toString().substring(0, 10)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectDate,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(_selectedTime?.format(context) ?? 'Select time'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectTime,
            ),
          ),
          const SizedBox(height: 24),

          // Notes section
          Text(
            'Additional Notes',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter any additional notes or requirements',
            ),
          ),
          const SizedBox(height: 24),

          // Create button
          ElevatedButton(
            onPressed: bookingState.isLoading ? null : _handleCreateBooking,
            child: bookingState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service, ThemeData theme) {
    final isSelected = _selectedServiceIds.contains(service.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                _selectedServiceIds.add(service.id);
              } else {
                _selectedServiceIds.remove(service.id);
              }
            });
          },
        ),
        title: Text(service.name),
        subtitle: Text(
          '${service.durationMinutes} min - ${service.currency} ${service.price.toStringAsFixed(2)}',
        ),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedServiceIds.remove(service.id);
            } else {
              _selectedServiceIds.add(service.id);
            }
          });
        },
      ),
    );
  }
}
