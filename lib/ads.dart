import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class Ads extends StatelessWidget {
  const Ads({
    required this.size,// サイズは利用時に指定
  });
  final AdSize size;
  @override
  Widget build(BuildContext context) {
    // AndroidかiOSを前提とする
    final banner = BannerAd(
      // サイズ
        size: size,
        // 広告ユニットID
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-4448383625931422/2849168159'
            : 'ca-app-pub-4448383625931422/4938438583',
        // イベントのコールバック
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => print('Ad loaded.'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) => print('Ad closed.'),
        ),
        // リクエストはデフォルトを使う
        request: const AdRequest())
    // 表示を行うloadをつける
      ..load();
    // 戻り値はSizedBoxで包んで返す
    return SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner));
  }
}