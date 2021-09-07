#import <Foundation/Foundation.h>

@interface DNode : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *routeName;

@end

@interface DNavigationManager : NSObject

@property (class, nonatomic, readonly) DNavigationManager *shared;

- (instancetype)init NS_UNAVAILABLE;

- (void)pushRoute:(NSString *)routeName;

@end
