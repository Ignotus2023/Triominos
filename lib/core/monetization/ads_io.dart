// Implementacja reklam dla platform mobilnych (google_mobile_ads).
//
// Używa testowych jednostek reklamowych Google. Przed publikacją podmień je
// na własne ID z AdMob i ustaw APPLICATION_ID w AndroidManifest / Info.plist.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../shared/widgets/ad_banner.dart';

String _testBannerUnitId() => Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/6300978111'
    : 'ca-app-pub-3940256099942544/2934735716';

Future<void> initMobileAds() async {
  await MobileAds.instance.initialize();
}

Widget adBannerWidget({double height = 56}) => _RealAdBanner(height: height);

class _RealAdBanner extends StatefulWidget {
  const _RealAdBanner({required this.height});

  final double height;

  @override
  State<_RealAdBanner> createState() => _RealAdBannerState();
}

class _RealAdBannerState extends State<_RealAdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: _testBannerUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (_loaded && ad != null) {
      return SizedBox(
        height: ad.size.height.toDouble(),
        width: ad.size.width.toDouble(),
        child: AdWidget(ad: ad),
      );
    }
    return AdBanner(height: widget.height);
  }
}
