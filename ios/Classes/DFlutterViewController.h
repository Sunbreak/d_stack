#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "DNavigationManager.h"

@interface DFlutterViewController : FlutterViewController

@property (nonatomic, strong, readonly) DNode *node;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDNode:(DNode *)node;

@end
