import '../entities/property_entity.dart';

abstract class PropertyRepository {
  Future<List<PropertyEntity>> getProperties();
  List<String> getBookedPropertyIds();
  Future<void> togglePropertyBooking(String propertyId);
}