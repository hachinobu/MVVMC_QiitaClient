platform :ios, ’10.0’
use_frameworks!
 
target 'MVVMC_QiitaClient' do
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
    pod 'APIKit',     '~> 3.1'
    pod 'Kingfisher', '~> 4.0'
    pod 'Action'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'APIKit'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
