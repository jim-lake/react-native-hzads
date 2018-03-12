
# react-native-hz-ads

## Getting started

`$ npm install react-native-hz-ads --save`

### Mostly automatic installation

`$ react-native link react-native-hz-ads`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-hz-ads` and add `RNHzAds.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNHzAds.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNHzAdsPackage;` to the imports at the top of the file
  - Add `new RNHzAdsPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-hz-ads'
  	project(':react-native-hz-ads').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-hz-ads/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-hz-ads')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNHzAds.sln` in `node_modules/react-native-hz-ads/windows/RNHzAds.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Hz.Ads.RNHzAds;` to the usings at the top of the file
  - Add `new RNHzAdsPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNHzAds from 'react-native-hz-ads';

// TODO: What to do with the module?
RNHzAds;
```
  