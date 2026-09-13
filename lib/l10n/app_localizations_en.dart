// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gettingStarted => 'Getting Started';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeTitle => 'Welcome to IELTS for all learners';

  @override
  String get welcomeSubtitle =>
      'Your personalized companion for mastering Listening, Reading, Writing, and Speaking with AI-driven band diagnostics.';

  @override
  String get continueButton => 'Continue';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get settingsNote =>
      'You can change these options anytime later in Settings.';
}
