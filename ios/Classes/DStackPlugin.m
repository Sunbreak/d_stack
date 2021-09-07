#import "DStackPlugin.h"

NSString * const kMethodActionToFlutter = @"methodActionToFlutter";

NSString * const kActionActivate = @"activate";

@interface DStackPlugin ()

@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

@implementation DStackPlugin

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    DStackPlugin.shared.channel = [FlutterMethodChannel
                                   methodChannelWithName:@"d_stack"
                                   binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:DStackPlugin.shared channel:DStackPlugin.shared.channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
}

- (void)activateFlutterNode:(DNode *)node {
    [self.channel invokeMethod:kMethodActionToFlutter arguments:@{
        @"action": kActionActivate,
        @"node": [node toDictionary],
    }];
}

@end
