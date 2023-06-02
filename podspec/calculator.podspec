Pod::Spec.new do |s|
    s.name             = 'calculator'
    s.version          = '1.0.0'
    s.summary          = 'calculator'
    s.homepage         = 'https://github.com/ustc-mjc/test_plugin_with_cmake'
    s.license          = { :type => 'MIT'}
    s.author           = { 'mojucheng' => 'mjc289@mail.ustc.edu.cn' }
    s.source           = { :http => 'http://hellomjc.xyz:9000/test/calculator.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=J72MY6CIRS9XD1KXDS43%2F20230506%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230506T034100Z&X-Amz-Expires=604800&X-Amz-Security-Token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NLZXkiOiJKNzJNWTZDSVJTOVhEMUtYRFM0MyIsImV4cCI6MTY4MzM4NzYxOSwicGFyZW50IjoibWluaW8ifQ.c54mbzmxoTwwoBIKsUd6wGOoXrmFUckIdoJ1Z3zs_AJG23sYeqquwqMO_kp8h5VCJIE6L5PZ6j2aDdtV2op-gw&X-Amz-SignedHeaders=host&versionId=null&X-Amz-Signature=eb804666917b97cf9f4f291b8da44339c3e0567c1140979ff3d92e659538f827'}
    s.ios.deployment_target = '11.0'
    s.default_subspec = ['Core', 'add', 'sub']
    s.subspec 'Core' do |spec|
        spec.preserve_paths = 'calculator.framework.dSYM'
        spec.vendored_frameworks = 'calculator.framework'
    end
    s.subspec 'add' do |spec|
        spec.preserve_paths = 'add.framework.dSYM'
        spec.vendored_frameworks = 'add.framework'
    end
    s.subspec 'sub' do |spec|
        spec.preserve_paths = 'sub.framework.dSYM'
        spec.vendored_frameworks = 'sub.framework'
    end
end
