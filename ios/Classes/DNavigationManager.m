#import "DNavigationManager.h"
#import "DFlutterViewController.h"

static inline DNode *createDNode(NSString *routeName) {
    DNode *node = [[DNode alloc] init];
    node.identifier = [[NSUUID UUID] UUIDString];
    node.routeName = routeName;
    return node;
}

@implementation DNode

@end

@interface DNavigationManager ()

- (NSMutableArray<NSMutableArray *> * const)nodeGroups;

@end

@implementation DNavigationManager

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray<NSMutableArray *> * const)nodeGroups {
    static NSMutableArray<NSMutableArray *> *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void)pushRoute:(NSString *)routeName {
    DNode *node = createDNode(routeName);
    [self putNodeIfAbsent:node];

    UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
    navigation.navigationBarHidden = YES;
    DFlutterViewController *flutterViewController = [[DFlutterViewController alloc] initWithDNode:node];
    [navigation pushViewController:flutterViewController animated:YES];
}

- (NSMutableArray *)findLastGroup:(DNode *)node {
    // TODO reverse
    for (NSMutableArray *group in self.nodeGroups) {
        for (DNode *n in group) {
            if ([n.identifier isEqual:node.identifier]) {
                return group;
            }
        }
    }
    return nil;
}

- (void)putNodeIfAbsent:(DNode *)node {
    NSMutableArray *group = [self findLastGroup:node];
    if (group != nil) return;

    // TODO native page
    if (self.nodeGroups.count <= 0) {
        [self.nodeGroups addObject:[[NSMutableArray alloc] initWithObjects:node, nil]];
    } else {
        [[self.nodeGroups lastObject] addObject:node];
    }
}

@end
