Pod::Spec.new do |s|
    s.name             = 'CalculatorApple'
    s.version          = '1.0.0'
    s.summary          = 'CalculatorApple'
    s.homepage         = ''
    s.license          = { :type => 'MIT'}
    s.author           = { 'mojucheng' => 'mjc289@mail.ustc.edu.cn' }
    s.source           = { :http => '' }
    s.ios.deployment_target = '${DEPLOYMENT_TARGET}'
    s.default_subspec = [${DEFAULT_SUBSPECS}]
    s.subspec 'Core' do |spec|
        spec.preserve_paths = '${SDK_TARGET_NAME}.framework.dSYM'
        spec.vendored_frameworks = '${SDK_TARGET_NAME}.framework'
    end
    s.subspec 'add' do |spec|
        spec.preserve_paths = 'add.framework.dSYM'
        spec.vendored_frameworks = 'add.framework'
    end
    s.subspec 'sub' do |spec|
        spec.preserve_paths = 'sub.framework.dSYM'
        spec.vendored_frameworks = 'sub.framework'
    end
