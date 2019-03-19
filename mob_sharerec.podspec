Pod::Spec.new do |s|
  s.name             = 'mob_sharerec'
  s.version          = "2.0.5"
  s.summary          = 'ShareREC is SDK that enable users can can record their mobile game play screen and share it.'
  s.license          = 'MIT'
  s.author           = { "mob" => "mobproducts@163.com" }

  s.homepage         = 'http://www.mob.com'
  s.source           = { :git => "https://github.com/MobClub/ShareREC-for-iOS.git", :tag => s.version.to_s }
  s.platform         = :ios
  s.ios.deployment_target = "8.0"
  s.frameworks       = 'JavaScriptCore'
  s.libraries        = 'icucore', 'z.1.2.5', 'stdc++'
  s.default_subspecs = 'ShareREC'
  s.dependency 'MOBFoundation'

  # 核心模块
  s.subspec 'ShareREC' do |sp|
    sp.vendored_frameworks = 'SDK/ShareREC/ShareREC.framework','SDK/ShareREC/ShareRECSocial.framework','SDK/ShareREC/ShareRECEdit.framework','SDK/ShareREC/ShareRECCloud.framework'
    sp.resources = 'SDK/ShareREC/ShareREC.bundle','SDK/ShareREC/ShareRECSocial.bundle','SDK/ShareREC/ShareRECCloud.bundle'
  end
end
