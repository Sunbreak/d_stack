#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "MainViewController.h"
#import "d_stack/DStack.h"
#import "NativePage1ViewController.h"
#import "NativePage2ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DStack.shared initialize];
    [DStack.shared registerRoute:@{
        @"nativePage1": ^UIViewController *{ return [[NativePage1ViewController alloc] init]; },
        @"nativePage2": ^UIViewController *{ return [[NativePage2ViewController alloc] init]; },
    }];

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
