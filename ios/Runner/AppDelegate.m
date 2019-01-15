#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import Firebase;
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  [GMSServices provideAPIKey:@"AIzaSyCJYmuywg75jJhSjuKl8Fl8RvgigGU_77M"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
