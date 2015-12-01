Pod::Spec.new do |spec|
  spec.name             = 'MMAlert'
  spec.version          = '0.0.9'
  spec.license          = { :type => 'MIT' }
  spec.homepage         = 'https://github.com/miscavage/Alert'
  spec.authors          = { 'Mark Miscavage' => 'miscavage' }
  spec.summary          = 'Alert is a simple notification that appears on the top of the screen.'
  spec.source           = { :git => 'https://github.com/miscavage/Alert.git' }
  spec.source_files     = "MMAlert/*.{h,m}"
  spec.requires_arc     = true
end