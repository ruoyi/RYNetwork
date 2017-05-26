#
#  Be sure to run `pod spec lint RYNetwork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RYNetwork"
  s.version      = "0.0.1"
  s.summary      = "Simpler to useAFNetingworking"
  s.homepage     = "https://github.com/ruoyi/RYNetwork"
  s.license      = "MIT"
  s.author             = { "ruoyi" => "woruoyi@gmail.com" }
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ruoyi/RYNetwork.git", :tag => "#{s.version}" }
  s.source_files  = "NetWork", "RYNetWork/**/*.{h,m}"
  s.framework = "CFNetwork"
  s.dependency "AFNetworking", "~> 3.0"
end
