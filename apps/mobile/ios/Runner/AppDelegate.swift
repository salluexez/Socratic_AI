import UIKit
import Flutter
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase programmatically
    let options = FirebaseOptions(googleAppID: "1:434260649356:ios:6b7c09bb32f334982422a9",
                                 gcmSenderID: "434260649356")
    options.projectID = "alumni-connect-2026"
    options.apiKey = "AIzaSyAntSQEdKi3vu5qKkefdkfN6PNd8CQFRAc"
    options.bundleID = "com.hiet.socraticAi"
    
    FirebaseApp.configure(options: options)
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Register for local notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
