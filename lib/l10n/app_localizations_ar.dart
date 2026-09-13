// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get gettingStarted => 'البداية';

  @override
  String get welcome => 'ترحيب';

  @override
  String get welcomeTitle => 'مرحباً بك في IELTS لكل المتعلمين';

  @override
  String get welcomeSubtitle =>
      'رفيقك الشخصي لإتقان الاستماع والقراءة والكتابة والمحادثة مع تشخيصات الدرجات الذكية.';

  @override
  String get continueButton => 'متابعة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get systemDefault => 'حسب النظام';

  @override
  String get settingsNote =>
      'يمكنك تغيير هذه الخيارات في أي وقت لاحقاً من الإعدادات.';
}
