'use strict';

import ReactNative from 'react-native';
import EventEmitter from 'events';

const {
  Platform,
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
} = ReactNative;
const { RNHzAds } = NativeModules;

const g_eventEmitter = new EventEmitter();
if (Platform.OS === 'ios') {
  const g_hzEventEmitter = new NativeEventEmitter(RNHzAds);

  g_hzEventEmitter.addListener('HzEvent',e => {
    g_eventEmitter.emit(e.name,e.body);
  });
} else {
  DeviceEventEmitter.addListener('HzEvent',e => {
    g_eventEmitter.emit(e.name,e);
  });
}

function once(event,callback) {
  g_eventEmitter.once(event,callback);
}
function on(event,callback) {
  g_eventEmitter.on(event,callback);
}
function removeListener(event,callback) {
  g_eventEmitter.removeListener(event,callback);
}

function init(publisherId,done) {
  if (!done) {
    done = function() {};
  }
  RNHzAds.initWithPublisherID(publisherId,done);
}

const getStatus = RNHzAds.getStatus;
const showDebugPanel = RNHzAds.showDebugPanel;

const isInterstitialAvailable = RNHzAds.isInterstitialAvailable;
const isVideoAvailable = RNHzAds.isVideoAvailable;
const isIncentivizedAdAvailable = RNHzAds.isIncentivizedAdAvailable;

function wrapMethod(method) {
  return (done) => {
    if (!done) {
      done = function() {};
    }
    method(done);
  }
}

const fetchInterstitial = wrapMethod(RNHzAds.fetchInterstitial);
const showInterstitial = wrapMethod(RNHzAds.showInterstitial);

const fetchVideo = wrapMethod(RNHzAds.fetchVideo);
const showVideo = wrapMethod(RNHzAds.showVideo);

const fetchIncentivizedAd = wrapMethod(RNHzAds.fetchIncentivizedAd);
const showIncentivizedAd = wrapMethod(RNHzAds.showIncentivizedAd);

export default {
  once,
  on,
  removeListener,
  init,

  getStatus,
  showDebugPanel,

  isInterstitialAvailable,
  isVideoAvailable,
  isIncentivizedAdAvailable,

  fetchInterstitial,
  showInterstitial,

  fetchVideo,
  showVideo,

  fetchIncentivizedAd,
  showIncentivizedAd,
};
