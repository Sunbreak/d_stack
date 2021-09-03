#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

FOUNDATION_EXPORT NSString * const EngineId;

@interface DStack: NSObject

@property (class, nonatomic, readonly) DStack *shared;

@property (nonatomic) FlutterEngine *flutterEngine;

- (instancetype)init NS_UNAVAILABLE;

- (void)initialize;

- (void)pushRoute:(NSString *)routeName;

@end
