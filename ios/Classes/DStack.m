#import "DStack.h"
#import <UIKit/UIKit.h>
#import "DNavigationManager.h"

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

- (void)registerRoute:(NSDictionary<NSString *,NativeRoute> *)routeMap {
    [DNavigationManager.shared registerRoute:routeMap];
}

- (void)pushRoute:(NSString *)routeName {
    [DNavigationManager.shared pushRoute:routeName];
}

@end
