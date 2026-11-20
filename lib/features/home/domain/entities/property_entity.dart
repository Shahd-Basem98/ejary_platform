class PropertyEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final String locationAr;
  final String locationEn;
  final String category; // apartments, villas, offices
  final double monthlyPrice;
  final int rooms;
  final int baths;
  final double area;
  final String descriptionAr;
  final String descriptionEn;

  const PropertyEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.locationAr,
    required this.locationEn,
    required this.category,
    required this.monthlyPrice,
    required this.rooms,
    required this.baths,
    required this.area,
    required this.descriptionAr,
    required this.descriptionEn,
  });
}