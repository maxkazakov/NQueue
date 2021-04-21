Pod::Spec.new do |spec|
    spec.name         = "NQueueTestHelpers"
    spec.version      = "1.0.0"
    spec.summary      = "Queue wrapper of DispatchQueue"

    spec.source       = { :git => "git@github.com:NikSativa/NQueue.git" }
    spec.homepage     = "https://github.com/NikSativa/NQueue"

    spec.license          = 'MIT'
    spec.author           = { "Nikita Konopelko" => "nik.sativa@gmail.com" }
    spec.social_media_url = "https://www.facebook.com/Nik.Sativa"

    spec.ios.deployment_target = "10.0"
    spec.swift_version = '5.0'

    spec.frameworks = 'XCTest', 'Foundation', 'UIKit'

    spec.default_subspec = 'Core'

    spec.dependency 'Nimble'
    spec.dependency 'Spry'
    spec.dependency 'Quick'
    spec.dependency 'Spry+Nimble'

    spec.scheme = {
      :code_coverage => true
    }

    spec.resources = ['TestHelpers/**/Test/**/*.{xcassets,json,imageset,png,strings,stringsdict}']
    spec.source_files = 'TestHelpers/**/Test*.{storyboard,xib,swift}',
                      'TestHelpers/**/Fake*.*',
                      'TestHelpers/**/*+TestHelper.*'

    spec.dependency 'NQueue'
    spec.test_spec 'Tests' do |tests|
        #        tests.requires_app_host = true
        tests.source_files = 'Tests/Specs/**/*Spec.swift'
    end
end
