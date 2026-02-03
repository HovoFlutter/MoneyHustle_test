import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _boardingKey = 'show-boarding-key';

class MHOnBoardingHelper {
  bool started = false;
  late SharedPreferences prefs;

  /// if onboarding showed - false
  /// else - true
  late bool boardingFlag;

  /// if review requested - false
  /// else - true
  late bool reviewFlag;

  static bool get showOnBoarding => _instance.boardingFlag;

  static bool get needToRequestReview => _instance.reviewFlag;

  static final MHOnBoardingHelper _instance = MHOnBoardingHelper._();

  MHOnBoardingHelper._();

  Future<bool> _needToShowOnBoadring() async {
    if (!_instance.started) return false;
    return _instance.prefs.getBool(_boardingKey) ?? true;
  }

  static Future<bool> init() async {
    _instance.prefs = await SharedPreferences.getInstance();
    _instance.started = true;
    _instance.boardingFlag = await _instance._needToShowOnBoadring();

    _instance.reviewFlag = true;

    return _instance.started;
  }

  static Future<void> markOnBoardingAsWatched() async {
    if (!_instance.started) return;
    if (MHOnBoardingHelper.needToRequestReview) {
      MHOnBoardingHelper.tryRequestReview();
    }
    await _instance.prefs
        .setBool(_boardingKey, false)
        .then((v) => _instance.boardingFlag = v);
  }

  static Future<void> tryRequestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable() && _instance.reviewFlag) {
      await inAppReview.requestReview();
      _instance.reviewFlag = false;
    }
  }

  static Future<void> rawRequestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }
}
