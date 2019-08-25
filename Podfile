# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'RepoStars' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RepoStars
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RxSwiftExt'
	pod 'Moya/RxSwift', '~> 13.0'
	pod 'SteviaLayout'
	pod 'Kingfisher'
	
	# Tests
	def test_pods
		pod 'Quick'
		pod 'Nimble'
		pod 'RxTest'
	end

  target 'RepoStarsTests' do
    inherit! :search_paths
    test_pods
  end

  target 'RepoStarsUITests' do
    inherit! :search_paths
    test_pods
  end

end
