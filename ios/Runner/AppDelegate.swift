import UIKit
import Flutter

import GoogleMaps // add for google_map


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // add for google_map & put key value
    // GMSServices.provideAPIKey(Storage().googleMapApiKey)
    GMSServices.provideAPIKey("AIzaSyC4MDk3EWF8lSSMYxxFREVqFwSxiMXaCO0") 

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
