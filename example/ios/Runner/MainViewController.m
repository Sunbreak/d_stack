#import "MainViewController.h"
#import "Masonry/Masonry.h"
#import "d_stack/DStack.h"

@interface MainViewController ()

@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (nonatomic, readonly) CGFloat navigationBarHeight;

-(void) initView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self initView];
}

-(CGFloat) statusBarHeight {
    UIWindow *firstWindow = UIApplication.sharedApplication.windows.firstObject;
    return firstWindow.windowScene.statusBarManager.statusBarFrame.size.height;
}

-(CGFloat) navigationBarHeight {
    if (self.navigationController != nil && !self.navigationController.navigationBar.isHidden) {
        return self.navigationController.navigationBar.frame.size.height;
    }
    return 0;
}

- (void)initView {
    self.view.backgroundColor = UIColor.whiteColor;
    [self setTitle:@"MainViewContoller"];

    UIStackView *stack = [[UIStackView alloc] init];
    [self.view addSubview:stack];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stack.superview.mas_top).with.offset(self.statusBarHeight + self.navigationBarHeight);
        make.width.equalTo(stack.superview.mas_width);
    }];

    UIButton *pushFlutter1 = [UIButton buttonWithType:UIButtonTypeSystem
               primaryAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [DStack.shared pushRoute:@"flutterPage1"];
    }]];
    [pushFlutter1 setTitle:@"push(FlutterPage1)" forState:UIControlStateNormal];
    [stack addArrangedSubview:pushFlutter1];

    UIButton *pushFlutter2 = [UIButton buttonWithType:UIButtonTypeSystem
               primaryAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [DStack.shared pushRoute:@"flutterPage2"];
    }]];
    [pushFlutter2 setTitle:@"push(FlutterPage2)" forState:UIControlStateNormal];
    [stack addArrangedSubview:pushFlutter2];

    UIButton *pushNative1 = [UIButton buttonWithType:UIButtonTypeSystem
               primaryAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [DStack.shared pushRoute:@"nativePage1"];
    }]];
    [pushNative1 setTitle:@"push(NativePage1)" forState:UIControlStateNormal];
    [stack addArrangedSubview:pushNative1];

    UIButton *pushNative2 = [UIButton buttonWithType:UIButtonTypeSystem
               primaryAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [DStack.shared pushRoute:@"nativePage2"];
    }]];
    [pushNative2 setTitle:@"push(NativePage2)" forState:UIControlStateNormal];
    [stack addArrangedSubview:pushNative2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
