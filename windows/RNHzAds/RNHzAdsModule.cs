using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Hz.Ads.RNHzAds
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNHzAdsModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNHzAdsModule"/>.
        /// </summary>
        internal RNHzAdsModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNHzAds";
            }
        }
    }
}
