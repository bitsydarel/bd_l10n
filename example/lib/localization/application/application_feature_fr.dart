import 'application_feature.dart';

/// The translations for French (`fr`).
class ApplicationFeatureFr extends ApplicationFeature {
  ApplicationFeatureFr([String locale = 'fr']) : super(locale);

  @override
  String get applicationTitle => 'Flutter BD_L10n Demo App';

  @override
  String get homeDescription => 'Vous avez appuyé sur le bouton ce nombre de fois:';

  @override
  String get incrementButton => 'Incrémenter';

  @override
  String get unTranslatedMessage => 'Hey, i\'m here to showcase messages that are not translated';
}
