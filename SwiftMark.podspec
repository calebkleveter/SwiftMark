Pod::Spec.new do |s|
s.name             = 'SwiftMark'
s.version          = '1.0.0'
s.summary          = "A Markdown renderer written in Swift."

s.description      = <<-DESC
A Markdown renderer with a simple interface written in Swift. It also works on SSS (Server-Side Swift).
DESC

s.homepage         = 'https://calebkleveter.github.io/SwiftDownSite/'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Caleb' => 'caleb.kleveter@gmail.com' }
s.source           = { :git => 'https://github.com/calebkleveter/SwiftDown.git', :tag => s.version.to_s }

s.source_files = 'Sources/*.swift'
s.ios.deployment_target = '10.0'
s.osx.deployment_target = '10.12'

end
