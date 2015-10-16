Pod::Spec.new do |s|

  s.name         = 'ITRFlipper'
  s.version      = '1.0.0'
  s.summary      = 'Flipboard animation'
  s.homepage     = 'https://github.com/ITechRoof/ITRFlipper'
  
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }

  s.author       = { 'Kiruthika' => 'kirthi.shalom@gmail.com' }
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/ITechRoof/ITRFlipper.git', :tag => s.version.to_s }
  s.source_files = 'classes/*.{h,m}'
  s.frameworks   = 'UIKit'
  s.requires_arc = true

end
