

Pod::Spec.new do |s|



  s.name         = "SlidingSegmentControl"
  s.version      = “1.1.0”
  s.summary      = "SlidingSegmentControl"

  s.description  = <<-DESC
this is only for Objective C.
                   DESC

  s.homepage     = "https://github.com/TonnyTeng/SlidingSegmentControl"
  s.license      = "MIT"

  s.author             = { "dengtao" => "1083683360@qq.com" }

  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/TonnyTeng/SlidingSegmentControl.git", :tag => “1.1.0” }

  s.source_files  = 'SlidingSegmentedControlDemo/SlidingSegmentedControlDemo/SlidingSegmentControl/*.{h,m}'

  #'SlidingSegmentControl/SlidingSegmentControl/*.{h,m}'

  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "PunchScrollView","~>1.1.1"

end
