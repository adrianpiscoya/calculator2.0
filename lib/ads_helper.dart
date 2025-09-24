import 'dart:async';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdHelper real con Google AdMob para monetización
class AdHelper {
  // Control de desarrollo
  static bool disableAds =
      false; // CAMBIAR a true para deshabilitar en desarrollo
  static bool useTestIds =
      true; // TEMPORAL: true hasta que se activen los IDs reales

  // Test Ad Unit IDs (para desarrollo)
  static const String _testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  // PRODUCTION Ad Unit IDs - IDs REALES de AdMob Dashboard
  static const String _prodBannerAdUnitId =
      'ca-app-pub-3111282193909773/3072620271';
  static const String _prodInterstitialAdUnitId =
      'ca-app-pub-3111282193909773/3441189891'; // App Open Ad (funciona como Interstitial)
  static const String _prodRewardedAdUnitId =
      'ca-app-pub-3111282193909773/9853936452';

  // Getters para Ad Unit IDs
  static String get bannerAdUnitId {
    if (useTestIds) return _testBannerAdUnitId;
    return Platform.isAndroid ? _prodBannerAdUnitId : _prodBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (useTestIds) return _testInterstitialAdUnitId;
    return Platform.isAndroid
        ? _prodInterstitialAdUnitId
        : _prodInterstitialAdUnitId;
  }

  static String get rewardedAdUnitId {
    if (useTestIds) return _testRewardedAdUnitId;
    return Platform.isAndroid ? _prodRewardedAdUnitId : _prodRewardedAdUnitId;
  }

  // App Open Ad (legacy compatibility)
  static String get appOpenInterstitialAdUnitId => interstitialAdUnitId;

  // Variables para ads precargados
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  // Inicializar AdMob
  static Future<void> initialize() async {
    if (disableAds) {
      print('🚫 AdMob DESHABILITADO para desarrollo');
      return;
    }
    print('🔧 Inicializando AdMob con App ID: ca-app-pub-3111282193909773');
    print('🆔 Usando Test IDs: $useTestIds');
    await MobileAds.instance.initialize();
    print('✅ AdMob inicializado exitosamente');
  }

  // BANNER ADS - Manejados por BannerAdWidget

  // INTERSTITIAL ADS
  static Future<void> preloadInterstitial() async {
    if (disableAds) return;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  static Future<bool> showInterstitial() async {
    if (disableAds || _interstitialAd == null) return false;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial(); // Precargar el siguiente
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial(); // Precargar el siguiente
      },
    );

    await _interstitialAd!.show();
    return true;
  }

  // REWARDED ADS
  static Future<void> preloadRewarded() async {
    if (disableAds) return;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  static Future<bool> showRewardedAd() async {
    if (disableAds || _rewardedAd == null) return false;

    bool rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        preloadRewarded(); // Precargar el siguiente
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        preloadRewarded(); // Precargar el siguiente
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewardEarned = true;
        print('User earned reward: ${reward.amount} ${reward.type}');
      },
    );

    return rewardEarned;
  }

  // Limpiar recursos
  static void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
