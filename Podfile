source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/skylib/SnapPods'

platform :ios, '8.0'

target 'SnapOnboarding-iOS' do
  use_frameworks!

  pod 'TTTAttributedLabel'
  pod 'SnapFonts-iOS'
  pod 'SnapTagsView'

  target 'Unit_tests' do
    inherit! :search_paths

  end

  target 'UI_tests' do
    inherit! :search_paths

  end

  target 'Snapshot_tests' do
    inherit! :search_paths

    pod 'SnapFBSnapshotBase'
  end

end
