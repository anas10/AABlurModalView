Pod::Spec.new do |s|
    s.name         = "AABlurModalView"
    s.version      = "0.1.0"
    s.summary      = "Simple fullscreen blur view presented as a modal with a content view"

    s.homepage     = "https://github.com/anas10/AABlurModalView"
    s.license      = { :type => "MIT", :file => "LICENSE" }

    s.author             = { "Anas AIT ALI" => "aitali.anas@gmail.com" }
    s.social_media_url   = "http://twitter.com/anasaitali"

    s.platform     = :ios, "8.0"
    s.requires_arc = true

    s.module_name  = 'PieOverlayMenu'
    s.source	 = { :git => "https://github.com/anas10/AABlurModalView.git", :tag => s.version.to_s }

    s.source_files = 'Source/AABlurModalView.swift'

end