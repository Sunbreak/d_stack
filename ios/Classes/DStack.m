#import "DStack.h"
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "DFlutterViewController.h"

NSString * const EngineId = @"d_stack_engine";

@interface DStack()

@property (nonatomic) BOOL running;

@end

@implementation DStack

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initialize {
    if (!self.running) {
        self.flutterEngine = [[FlutterEngine alloc] initWithName:EngineId];
        self.running = [self.flutterEngine run];
    }
}

- (void)pushRoute:(NSString *)routeName {
    // TODO routeName
    UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
    navigation.navigationBarHidden = YES;
    [navigation pushViewController:[[DFlutterViewController alloc] init] animated:YES];
}

@end
