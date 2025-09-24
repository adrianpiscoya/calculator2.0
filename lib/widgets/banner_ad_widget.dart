import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ads_helper.dart';

/// Widget de banner ads funcional con Google AdMob
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (AdHelper.disableAds) return;

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {
          print('Banner ad clicked');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const height = 50.0;

    // Si los ads están deshabilitados o no se ha cargado, mostrar placeholder
    if (AdHelper.disableAds || !_isLoaded || _bannerAd == null) {
      return SizedBox(
        width: width,
        height: height,
        child: Container(
          color: Colors.grey[100],
          child: Center(
            child: AdHelper.disableAds
                ? Text('Ads deshabilitados',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12))
                : CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // Mostrar el banner ad real
    return SizedBox(
      width: width,
      height: height,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
