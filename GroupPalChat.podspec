Pod::Spec.new do |spec|
spec.name          = 'GroupPalChat'
spec.version       = '1.0.0'
spec.license       = { :type => 'MIT' }
spec.homepage      = 'https://grouppal.in/'
spec.authors       = { 'Aravindhan' => 'aravindhan.n@grouppal.in' }
spec.summary       = 'Chat SDK of GroupPal'
spec.source        = { :git => 'https://github.com/Grouppal-Mobile/Grouppal-iOSChat', :tag => spec.version }

spec.ios.deployment_target  = '11.0'
spec.swift_version = '5'

spec.source_files   = 'native/GroupPalChat/**/*.{swift,h,m}'
spec.resources = 'native/GroupPalChat/**/*.{strings,xib,xcassets,strings,ttf,otf,css,js,html,storyboard,eot,svg,woff,xcdatamodeld,json,sh,rb,py,gif,jpeg,jpg}'

spec.framework      = 'UIKit'
spec.dependency  'Alamofire'

end
