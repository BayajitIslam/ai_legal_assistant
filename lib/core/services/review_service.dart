import 'dart:async';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;
  Timer? _reviewTimer;

  static const String _hasShownReviewKey = 'has_shown_review';

  void startReviewTimer() {
    _reviewTimer = Timer(const Duration(minutes: 2), () async {
      await _requestReviewIfNeeded();
    });
  }

  Future<void> _requestReviewIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownReview = prefs.getBool(_hasShownReviewKey) ?? false;

    if (!hasShownReview) {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
        await prefs.setBool(_hasShownReviewKey, true);
      }
    }
  }

  void cancelTimer() {
    _reviewTimer?.cancel();
    _reviewTimer = null;
  }
}