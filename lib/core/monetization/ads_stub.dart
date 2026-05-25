// Domyślna (web) implementacja reklam — bez natywnego SDK.
import 'package:flutter/widgets.dart';

import '../../shared/widgets/ad_banner.dart';

/// Na web/desktopie reklamy mobilne nie są dostępne — no-op.
Future<void> initMobileAds() async {}

/// Placeholder banera (web). Realny baner pojawia się tylko na mobile.
Widget adBannerWidget({double height = 56}) => AdBanner(height: height);
