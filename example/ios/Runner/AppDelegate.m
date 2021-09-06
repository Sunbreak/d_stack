#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "MainViewController.h"
#import "d_stack/DStack.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DStack.shared initialize];

    [GeneratedPluginRegistrant registerWithRegistry:DStack.shared.flutterEngine];

    self.window = [[UIWindow alloc] init];
    self.window.bounds = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];
    UINavigationController *navigation = [[UINavigationController alloc] init];
    [navigation pushViewController:[[MainViewController alloc] init] animated:YES];
    self.window.rootViewController = navigation;

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
