#import "DFlutterViewController.h"
#import "DStack.h"

@interface DFlutterViewController ()

// private setter
@property (nonatomic, strong, readwrite) DNode *node;

- (void)attachToEngine;
- (void)detachFromEngine;

@end

@implementation DFlutterViewController

- (instancetype)initWithDNode:(DNode *)node {
    self = [super init];
    if (self) {
        _node = node;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self attachToEngine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self attachToEngine];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:^{
        if (completion != nil) completion();
        [self detachFromEngine];
    }];
}

- (void)attachToEngine {
    if (DStack.shared.flutterEngine.viewController != self) {
        DStack.shared.flutterEngine.viewController = self;
    }
}

- (void)detachFromEngine {
    if (DStack.shared.flutterEngine.viewController == self) {
        DStack.shared.flutterEngine.viewController = nil;
    }
}

@end
