import PackageDescription

var package = Package(
    name: "TitanRouterMethodSugar",
    dependencies: [
      .Package(url: "https://github.com/bermudadigitalstudio/TitanRouter.git", majorVersion: 0, minor: 2)
    ]
)

// Uncomment the following to install sourcery for development
//package.dependencies.append(
//.Package(url: "https://github.com/krzysztofzablocki/Sourcery.git", "0.5.3")
//)

