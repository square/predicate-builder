Pod::Spec.new do |s|
  # Core name/version/soure info
  s.name         = 'PredicateBuilder'
  s.version      = '1.0.0'

  # Required podspec metadata
  s.summary      = 'A declarative, type-safe way to build NSPredicates'
  s.homepage     = 'https://github.com/squareup/predicate-builder'
  s.license      = { :type => 'Proprietary', :text => '2023 Square, Inc.' }
  s.author       = { "Patrick Gatewood" => "patrick@patrickgatewood.com" }
  s.source = { :git => 'org-49461806@github.com:squareup/predicate-builder.git', :tag => "podify/#{ s.version.to_s }" }
  s.ios.deployment_target = '14.0'
  s.osx.deployment_target = '12.0'

  # Swift version
  s.swift_version = '5.7'

  # Local dependencies
  s.subspec 'PredicateBuilderCore' do |ss| ss.source_files = 'PredicateBuilderCore/Sources/**/*.swift' end
  s.subspec 'PredicateBuilderMacro' do |ss| ss.source_files = 'PredicateBuilderMacro/Sources/**/*.swift' end

  s.source_files = 'PredicateBuilder/Sources/**/*.swift'
end
