#import <Flutter/Flutter.h>
#import "DNavigationManager.h"

@interface DStackPlugin : NSObject<FlutterPlugin>

@property (class, nonatomic, readonly) DStackPlugin *shared;

- (void)activateFlutterNode:(DNode *)node;

@end
