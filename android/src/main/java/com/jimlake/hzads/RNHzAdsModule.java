package com.jimlake.hzads;

import javax.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter;

import com.heyzap.sdk.ads.HeyzapAds;
import com.heyzap.sdk.ads.IncentivizedAd;
import com.heyzap.sdk.ads.InterstitialAd;
import com.heyzap.sdk.ads.VideoAd;

public class RNHzAdsModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  private final HeyzapAds.OnStatusListener statusListener = new HeyzapAds.OnStatusListener() {
    @Override
    public void onShow(String tag) {
      sendReactEvent("ShowAd",tag);
    }
    @Override
    public void onClick(String tag) {
      sendReactEvent("ClickAd",tag);
    }
    @Override
    public void onHide(String tag) {
      sendReactEvent("HideAd",tag);
    }
    @Override
    public void onFailedToShow(String tag) {
      sendReactEvent("ShowFail",tag);
    }
    @Override
    public void onAvailable(String tag) {
      sendReactEvent("RecieveAd",tag);
    }
    @Override
    public void onFailedToFetch(String tag) {
      sendReactEvent("HideAd",tag);
    }
    @Override
    public void onAudioStarted() {
      final WritableMap map = new WritableNativeMap();
      map.putString("reason","StartAudio");
      sendReactEvent("Audio",map);
    }
    @Override
    public void onAudioFinished() {
      final WritableMap map = new WritableNativeMap();
      map.putString("reason","FinishAudio");
      sendReactEvent("Audio",map);
    }
  };

  private final HeyzapAds.OnIncentiveResultListener incentiveResultListener = new HeyzapAds.OnIncentiveResultListener() {
    @Override
    public void onComplete(String tag) {
      sendReactEvent("AdComplete",tag);
    }

    @Override
    public void onIncomplete(String tag) {
      sendReactEvent("AdFail",tag);
    }
  };

  public RNHzAdsModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  private void sendReactEvent(final String eventName,final String tag) {
    final WritableMap params = new WritableNativeMap();
    params.putString("name",eventName);
    params.putString("tag",tag);
    sendReactEvent(eventName,params);
  }

  private void sendReactEvent(final String eventName, @Nullable WritableMap params) {
    if (params == null) {
      params = new WritableNativeMap();
      params.putString("name",eventName);
    }
    getReactApplicationContext()
      .getJSModule(RCTDeviceEventEmitter.class)
      .emit("HzEvent",params);
  }

  @Override
  public String getName() {
    return "RNHzAds";
  }

  @ReactMethod
  public void initWithPublisherID(final String publisherId,final Callback callback) {
    HeyzapAds.start(publisherId, getCurrentActivity());
    InterstitialAd.setOnStatusListener(statusListener);
    VideoAd.setOnStatusListener(statusListener);
    IncentivizedAd.setOnStatusListener(statusListener);
    IncentivizedAd.setOnIncentiveResultListener(incentiveResultListener);

    getStatus(callback);
  }

  @ReactMethod
  public void getStatus(final Callback callback) {
    WritableMap map = new WritableNativeMap();

    map.putBoolean("isAdColonyInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.ADCOLONY));
    map.putBoolean("isAdMobInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.ADMOB));
    map.putBoolean("isAppLovinInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.APPLOVIN));
    map.putBoolean("isChartboostInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.CHARTBOOST));
    map.putBoolean("isFacebookInitilized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.FACEBOOK));
    map.putBoolean("isHeyzapInitialized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.HEYZAP));
    map.putBoolean("isHyprMXInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.HYPRMX));
    map.putBoolean("isIADInitialized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.IAD));
    map.putBoolean("isInMobiInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.INMOBI));
    map.putBoolean("isUnityAdsInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.UNITYADS));
    map.putBoolean("isVungleInitiailized",HeyzapAds.isNetworkInitialized(HeyzapAds.Network.VUNGLE));

    callback.invoke((Object)null,map);
  }

  @ReactMethod
  public void showDebugPanel() {
    HeyzapAds.startTestActivity(getCurrentActivity());
  }

  @ReactMethod
  public void fetchInterstitial(final Callback callback) {
    this.fetchInterstitialForTag("default",callback);
  }
  @ReactMethod
  public void fetchInterstitialForTag(final String tag,final Callback callback) {
    InterstitialAd.fetch(tag);
    callback.invoke((Object)null);
  }

  @ReactMethod
  public void isInterstitialAvailable(final Callback callback) {
    this.isInterstitialAvailableForTag("default",callback);
  }
  @ReactMethod
  public void isInterstitialAvailableForTag(final String tag,final Callback callback) {
    callback.invoke((Object)null,InterstitialAd.isAvailable(tag));
  }

  @ReactMethod
  public void showInterstitial(final Callback callback) {
    this.showInterstitialForTag("default",callback);
  }
  @ReactMethod
  public void showInterstitialForTag(final String tag,final Callback callback) {
    InterstitialAd.display(getCurrentActivity(),tag);
    callback.invoke((Object)null);
  }

  @ReactMethod
  public void fetchVideo(final Callback callback) {
    this.fetchVideoForTag("default",callback);
  }
  @ReactMethod
  public void fetchVideoForTag(final String tag,final Callback callback) {
    VideoAd.fetch(tag);
    callback.invoke((Object)null);
  }

  @ReactMethod
  public void isVideoAvailable(final Callback callback) {
    this.isVideoAvailableForTag("default",callback);
  }
  @ReactMethod
  public void isVideoAvailableForTag(final String tag,final Callback callback) {
    callback.invoke((Object)null,VideoAd.isAvailable(tag));
  }

  @ReactMethod
  public void showVideo(final Callback callback) {
    this.showVideoForTag("default",callback);
  }
  @ReactMethod
  public void showVideoForTag(final String tag,final Callback callback) {
    if (VideoAd.isAvailable(tag)) {
      VideoAd.display(getCurrentActivity(),tag);
      callback.invoke((Object)null);
    } else {
      callback.invoke("no_video_available");
    }
  }

  @ReactMethod
  public void fetchIncentivizedAd(final Callback callback) {
    this.fetchIncentivizedAdForTag("default",callback);
  }
  @ReactMethod
  public void fetchIncentivizedAdForTag(final String tag,final Callback callback) {
    IncentivizedAd.fetch(tag);
    callback.invoke((Object)null);
  }

  @ReactMethod
  public void isIncentivizedAdAvailable(final Callback callback) {
    this.isIncentivizedAdAvailableForTag("default",callback);
  }
  @ReactMethod
  public void isIncentivizedAdAvailableForTag(final String tag,final Callback callback) {
    callback.invoke((Object)null,IncentivizedAd.isAvailable(tag));
  }

  @ReactMethod
  public void showIncentivizedAd(final Callback callback) {
    this.showIncentivizedAdForTag("default",callback);
  }
  @ReactMethod
  public void showIncentivizedAdForTag(final String tag,final Callback callback) {
    if (IncentivizedAd.isAvailable(tag)) {
      IncentivizedAd.display(getCurrentActivity(),tag);
      callback.invoke((Object)null);
    } else {
      callback.invoke("no_incentivized_ad_available");
    }
  }
}
