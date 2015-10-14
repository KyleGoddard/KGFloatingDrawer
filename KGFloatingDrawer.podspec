Pod::Spec.new do |s|
  s.name                  = "KGFloatingDrawer"
  s.version               = "0.2.0"
  s.summary               = "A floating navigation drawer with an interesting animated presentation written in Swift."
  s.homepage              = "https://github.com/KyleGoddard/KGFloatingDrawer"
  s.screenshots           = ["https://raw.githubusercontent.com/KyleGoddard/KGFloatingDrawer/master/kgfloatingdrawer_github_preview.gif"]
  s.license               = {:type => "MIT" }
  s.author                = { "KyleGoddard" => "kylegoddard@gmail.com" }

  s.requires_arc          = true
  s.platform              = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source                = { :git => "https://github.com/KyleGoddard/KGFloatingDrawer.git", :tag => s.version.to_s }
  s.source_files          = "Pod/Classes/"
end
