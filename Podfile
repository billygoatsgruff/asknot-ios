platform :ios, '13.0'

def import_all
  pod 'TwitterKit'
  pod 'OneSignal'
  pod 'GPUImage'
  pod 'LUX', git: 'https://github.com/ThryvInc/LUX'
  pod 'LithoOperators', git: 'https://github.com/ThryvInc/LithoOperators'
  pod 'FunNet/Combine', git: 'https://github.com/schrockblock/funnet'
  pod 'PlaygroundVCHelpers', git: 'https://github.com/ThryvInc/playground-vc-helpers'
  pod 'FlexDataSource', git: 'https://github.com/ThryvInc/flex-data-source'
  pod 'Slippers'
  pod 'fuikit'
end

target 'ANLib' do
  use_frameworks!
  import_all

  target 'ANLibTests' do
    inherit! :search_paths
  end

  target 'AskNot' do
    inherit! :search_paths
    import_all

    target 'AskNotTests' do
      inherit! :search_paths
      # Pods for testing
    end
  end
end
