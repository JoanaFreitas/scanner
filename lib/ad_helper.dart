

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{

static  String get bannerAdUnitId{
if(Platform.isAndroid){
  return 'ca-app-pub-1343889607110738/9461866908';//ca-app-pub-3940256099942544/6300978111
}else if(Platform.isIOS){
  return'ca-app-pub-3940256099942544/2934735716';
}else{
throw  UnsupportedError('Plataforma não suportada');
}
}

  final BannerAdListener adListener = BannerAdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (ad) => print('Ad loaded. ${ad.adUnitId}'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (ad) => print('Ad closed. ${ad.adUnitId}'),
 // Called when an ad request failed.
 onAdFailedToLoad: (ad,error) {
   // Dispose the ad here to free resources.
   ad.dispose();
   print('Ad failed to load:  ${ad.adUnitId} $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (ad) => print('Ad opened.  ${ad.adUnitId}'),
 // Called when an impression occurs on the ad.
 onAdImpression: (Ad ad) => print('Ad impression. ${ad.adUnitId}'),
);
}