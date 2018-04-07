
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <HeyzapAds/HeyzapAds.h>

@interface RNHzAds : RCTEventEmitter <RCTBridgeModule,HZIncentivizedAdDelegate,HZAdsDelegate>

@end

@implementation RNHzAds
{
  bool _hasListeners;
}
RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

- (void)startObserving {
  _hasListeners = true;
}

- (void)stopObserving {
  _hasListeners = false;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"HzEvent"];
}

- (void)sendEvent:(NSString *)name body:(NSDictionary *)body {
  if (_hasListeners && super.bridge != nil) {
    [self sendEventWithName:@"HzEvent" body:@{@"name": name, @"body": body}];
  }
}

- (NSDictionary *)getStatus {
  return @{
    @"isHeyzapInitialized": @([HeyzapAds isNetworkInitialized:HZNetworkHeyzap]),
    @"isCrossPromoInitialized": @([HeyzapAds isNetworkInitialized:HZNetworkCrossPromo]),
    @"isFacebookInitilized": @([HeyzapAds isNetworkInitialized:HZNetworkFacebook]),
    @"isUnityAdsInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkUnityAds]),
    @"isAppLovinInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkAppLovin]),
    @"isVungleInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkVungle]),
    @"isChartboostInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkChartboost]),
    @"isAdColonyInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkAdColony]),
    @"isAdMobInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkAdMob]),
    @"isHyprMXInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkHyprMX]),
    @"isHeyzapExchangeInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkHeyzapExchange]),
    @"isLeadboltInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkLeadbolt]),
    @"isInMobiInitiailized": @([HeyzapAds isNetworkInitialized:HZNetworkInMobi]),
  };
}

RCT_EXPORT_METHOD(initWithPublisherID:(NSString *)publisherId
  callback:(RCTResponseSenderBlock)callback) {

  [HeyzapAds startWithPublisherID:publisherId];
  if ([HeyzapAds isStarted]) {
    [HZInterstitialAd setDelegate:self];
    [HZVideoAd setDelegate:self];
    [HZIncentivizedAd setDelegate:self];
    callback(@[[NSNull null],[self getStatus]]);
  } else {
    callback(@[@"start_failed"]);
  }
}

RCT_EXPORT_METHOD(getStatus:(RCTResponseSenderBlock)callback) {
  callback(@[[NSNull null],[self getStatus]]);
}

RCT_EXPORT_METHOD(showDebugPanel) {
  [HeyzapAds presentMediationDebugViewController];
}

RCT_EXPORT_METHOD(isInterstitialAvailable:(RCTResponseSenderBlock)callback) {
  callback(@[[NSNull null],@([HZInterstitialAd isAvailable])]);
}

RCT_EXPORT_METHOD(showInterstitial:(RCTResponseSenderBlock)callback) {
  if ([HZInterstitialAd isAvailable]) {
    [HZInterstitialAd showForTag:@"default" completion:^(BOOL result,NSError *error) {
      if (result) {
        callback(@[[NSNull null]]);
      } else if (error != nil) {
        callback(@[error]);
      } else {
        callback(@[@"completion_failure"]);
      }
    }];
  } else {
    callback(@[@"no_interstitial_available"]);
  }
}

RCT_EXPORT_METHOD(fetchVideo:(RCTResponseSenderBlock)callback) {
  [HZVideoAd fetchWithCompletion:^(BOOL result, NSError *error) {
    if (result) {
      callback(@[[NSNull null]]);
    } else if (error != nil) {
      callback(@[error]);
    } else {
      callback(@[@"completion_failure"]);
    }
  }];
}

RCT_EXPORT_METHOD(isVideoAvailable:(RCTResponseSenderBlock)callback) {
  callback(@[[NSNull null],@([HZVideoAd isAvailable])]);
}

RCT_EXPORT_METHOD(showVideo:(RCTResponseSenderBlock)callback) {
  if ([HZVideoAd isAvailable]) {
    [HZVideoAd showForTag:@"default" completion:^(BOOL result, NSError *error) {
      if (result) {
        callback(@[[NSNull null]]);
      } else if (error != nil) {
        callback(@[error]);
      } else {
        callback(@[@"completion_failure"]);
      }
    }];
  } else {
    callback(@[@"no_video_available"]);
  }
}

RCT_EXPORT_METHOD(fetchIncentivizedAd:(RCTResponseSenderBlock)callback) {
  [HZIncentivizedAd fetchWithCompletion:^(BOOL result, NSError *error) {
    if (result) {
      callback(@[[NSNull null]]);
    } else if (error != nil) {
      callback(@[error]);
    } else {
      callback(@[@"completion_failure"]);
    }
  }];
}

RCT_EXPORT_METHOD(isIncentivizedAdAvailable:(RCTResponseSenderBlock)callback) {
  callback(@[[NSNull null],@([HZIncentivizedAd isAvailable])]);
}

RCT_EXPORT_METHOD(showIncentivizedAd:(RCTResponseSenderBlock)callback) {
  if ([HZIncentivizedAd isAvailable]) {
    HZShowOptions *options = [HZShowOptions new];
    options.completion = ^(BOOL result, NSError *error) {
      if (result) {
        callback(@[[NSNull null]]);
      } else if (error != nil) {
        callback(@[error]);
      } else {
        callback(@[@"completion_failure"]);
      }
    };
    [HZIncentivizedAd showWithOptions:options];
  } else {
    callback(@[@"no_incentivized_ad_available"]);
  }
}

- (void)didShowAdWithTag:(NSString *)tag {
  [self sendEvent:@"ShowAd" body:@{ @"tag": tag,}];
}
- (void)didFailToShowAdWithTag:(NSString *)tag andError:(NSError *)error {
  NSMutableDictionary *body = [NSMutableDictionary new];
  [body setObject:tag forKey:@"tag"];
  if (error) {
    [body setObject:error forKey:@"error"];
  }
  [self sendEvent:@"ShowFail" body:body];
}
- (void)didReceiveAdWithTag:(NSString *)tag {
  [self sendEvent:@"RecieveAd" body:@{ @"tag": tag, }];
}
- (void)didFailToReceiveAdWithTag:(NSString *)tag {
  [self sendEvent:@"RecieveFail" body:@{ @"tag": tag }];
}
- (void)didClickAdWithTag:(NSString *)tag {
  [self sendEvent:@"ClickAd" body:@{ @"tag": tag }];
}
- (void)didHideAdWithTag:(NSString *)tag {
  [self sendEvent:@"HideAd" body:@{ @"tag": tag }];
}
- (void)willStartAudio {
  [self sendEvent:@"Audio" body:@{ @"reason": @"StartAudio" }];
}
- (void) didFinishAudio {
  [self sendEvent:@"Audio" body:@{ @"reason": @"FinishAudio" }];
}
- (void)didCompleteAdWithTag:(NSString *)tag {
  [self sendEvent:@"AdComplete" body:@{ @"tag": tag }];
}
- (void)didFailToCompleteAdWithTag:(NSString *)tag {
  [self sendEvent:@"AdFail" body:@{ @"tag": tag }];
}

@end
