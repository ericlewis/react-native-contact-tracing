require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-contact-tracing"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-contact-tracing
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-contact-tracing"
  s.license      = "UNLICENSED"
  s.authors      = { "Eric Lewis" => "ericlewis777@gmail.com" }
  s.platforms    = { :ios => "13.4" }
  s.source       = { :git => "https://github.com/github_account/react-native-contact-tracing.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
end

