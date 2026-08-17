import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Uses Google's official TEST ad unit IDs — swap these for your real
/// AdMob ad unit IDs before publishing (see AdMob console > Ad units).
const _androidTestAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
const _iosTestAdUnitId = 'ca-app-pub-3940256099942544/2934735716';

/// A banner ad that loads itself and collapses to nothing while loading or
/// if the ad request fails, so it never leaves a broken-looking gap.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  static String get _adUnitId =>
      Platform.isAndroid ? _androidTestAdUnitId : _iosTestAdUnitId;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    BannerAd(
      size: AdSize.banner,
      adUnitId: _adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
