import 'package:cloudbarber/features/booking/domain/entities/service.dart';
import 'package:cloudbarber/features/booking/domain/repositories/booking_repository.dart';

/// Use case for getting available services
class GetAvailableServicesUseCase {
  final BookingRepository repository;

  GetAvailableServicesUseCase(this.repository);

  Future<List<Service>> call() async {
    final services = await repository.getAvailableServices();
    
    // Filter only active services
    final activeServices = services.where((service) => service.isActive).toList();
    
    // Sort by name
    activeServices.sort((a, b) => a.name.compareTo(b.name));
    
    return activeServices;
  }
}
