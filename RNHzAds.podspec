
Pod::Spec.new do |s|
  s.name         = "RNHzAds"
  s.version      = "1.0.1"
  s.summary      = "RNHzAds"
  s.description  = <<-DESC
                  React Native Heyzap Ads
                   DESC
  s.homepage     = "https://github.com/jim-lake/react-native-hzads"
  s.license      = "MIT"
  s.author       = { "author" => "jim@blueskylabs.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jim-lake/react-native-hzads.git", :tag => "master" }
  s.source_files  = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "Heyzap"

end

