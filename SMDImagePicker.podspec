Pod::Spec.new do |s|

  s.name = "SMDSelectiveBlurImageView"
  s.version = "0.1.1"
  s.summary = "UIImageView with tap to blur feature in swift."

  s.description = <<-DESC
                   UIImageView with tap to blur feature in swift.
                   DESC

  s.homepage = "https://github.com/gajjartejas/SMDSelectiveBlurImageView"
  s.screenshots = "https://github.com/gajjartejas/SMDImagePicker/blob/master/Screenshots/logo.png?raw=true"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "gajjartejas" => "gajjartejas26@gmail.com" }
  s.social_media_url = "https://twitter.com/gajjartejas"

  s.platform = :ios, '8.0'
  s.source = {
    :git => "https://github.com/gajjartejas/SMDImagePicker.git",
    :tag => "v#{s.version.to_s}"
  }

  s.source_files = "SMDImagePicker", "SMDImagePicker/**/*.swift"
  s.requires_arc = true

end
