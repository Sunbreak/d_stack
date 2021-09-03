#import "DFlutterViewController.h"
#import "DStack.h"

@interface DFlutterViewController ()

- (void)attachToEngine;
- (void)detachFromEngine;

@end

@implementation DFlutterViewController

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
