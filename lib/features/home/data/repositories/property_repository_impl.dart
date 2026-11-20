import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../models/property_model.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final StorageService _storage = Get.find<StorageService>();

  final List<PropertyModel> _mockData = const [
    PropertyModel(
      id: 'prop_1',
      titleAr: 'شقة مودرن فاخرة بإطلالة بانورامية',
      titleEn: 'Luxury Modern Panoramic Apartment',
      locationAr: 'صنعاء - حي حدة',
      locationEn: 'Sanaa - Hadda District',
      category: 'apartments',
      monthlyPrice: 350,
      rooms: 3,
      baths: 2,
      area: 165,
      descriptionAr: 'شقة حديثة التشطيب قريبة من كافة الخدمات، تضم صالة واسعة ومطبخ مجهز وموقف سيارات خاص.',
      descriptionEn: 'Newly finished apartment close to all services, featuring a spacious living room, equipped kitchen, and private parking.',
    ),
    PropertyModel(
      id: 'prop_2',
      titleAr: 'فيلا مستقلة مع حديقة خاصة',
      titleEn: 'Detached Villa with Private Garden',
      locationAr: 'صنعاء - فج عطان',
      locationEn: 'Sanaa - Faj Attan',
      category: 'villas',
      monthlyPrice: 950,
      rooms: 6,
      baths: 4,
      area: 420,
      descriptionAr: 'فيلا راقية من طابقين مع حديقة أمامية، مجلس مستقل، ونظام طاقة شمسية متكامل.',
      descriptionEn: 'Two-story upscale villa with front garden, separate reception hall, and full solar power system.',
    ),
    PropertyModel(
      id: 'prop_3',
      titleAr: 'مكتب إداري جاهز للشركات الناشئة',
      titleEn: 'Ready Executive Office for Startups',
      locationAr: 'صنعاء - شارع الخمسين',
      locationEn: 'Sanaa - Al-Khamseen Street',
      category: 'offices',
      monthlyPrice: 500,
      rooms: 4,
      baths: 2,
      area: 210,
      descriptionAr: 'مساحة مكتبية مكيفة ومقسمة باحترافية مع قاعة اجتماعات وإنترنت فائق السرعة.',
      descriptionEn: 'Air-conditioned professionally partitioned office space with a meeting room and high-speed internet.',
    ),
    PropertyModel(
      id: 'prop_4',
      titleAr: 'شقة عائلية هادئة قرب الجامعة',
      titleEn: 'Quiet Family Apartment Near University',
      locationAr: 'صنعاء - الدائري الغربي',
      locationEn: 'Sanaa - Western Ring Road',
      category: 'apartments',
      monthlyPrice: 240,
      rooms: 3,
      baths: 2,
      area: 140,
      descriptionAr: 'شقة مشمسة في مبنى عائلي هادئ، مناسبة للعائلات والطلاب مع خزان مياه مستقل.',
      descriptionEn: 'Sunny apartment in a quiet family building, suitable for families and students with an independent water tank.',
    ),
  ];

  @override
  Future<List<PropertyEntity>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _mockData;
  }

  @override
  List<String> getBookedPropertyIds() => _storage.bookedIds;

  @override
  Future<void> togglePropertyBooking(String propertyId) async {
    await _storage.toggleBooking(propertyId);
  }
}