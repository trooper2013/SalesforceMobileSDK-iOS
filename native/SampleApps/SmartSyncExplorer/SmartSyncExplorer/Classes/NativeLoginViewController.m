//
//  NativeLoginViewController.m
//  SmartSyncExplorer
//
//  Created by Raj Rao on 4/17/18.
//  Copyright © 2018 salesforce.com. All rights reserved.
//

#import "NativeLoginViewController.h"

@interface NativeLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)nativeLoginAction:(id)sender;

@end

@implementation NativeLoginViewController
@synthesize oauthView = _oauthView;

- (void)viewDidLoad {
    UIColor *backGroundColor = self.view.backgroundColor;
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    [self.activityIndicator setHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (UIView *)createTitleItem {
    NSString *title = @"Native Login";
    // Setup top item.
    UILabel *item = [[UILabel alloc] init];
    
    if (self.config.navBarTitleColor) {
        item.textColor = self.config.navBarTextColor;
    }
    if (self.config.navBarFont) {
        item.font = self.config.navBarFont;
    }
    
    item.text = title;
    return item;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"Hello");
}

- (void)showHostListView {
    return [super showHostListView];
}

- (void)hideHostListView:(BOOL)animated {
    return [super hideHostListView:animated];
}

- (void)handleBackButtonAction {
    [super handleBackButtonAction];
}

- (BOOL)shouldShowBackButton {
    return [super shouldShowBackButton];
}

- (void)handleLoginHostSelectedAction:(SFSDKLoginHost *)loginHost {
    return [super handleLoginHostSelectedAction:loginHost];
}

- (void)layoutWebView {
    
    if (nil != _oauthView) {
        [_oauthView setFrame:CGRectMake(0, 0, 0, 0)];
        [self.view addSubview:_oauthView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nativeLoginAction:(id)sender {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    __weak typeof (self) weakSelf = self;
    [[SFUserAccountManager sharedInstance] loginWithUserName:self.userNameTextField.text password:self.passwordTextField.text completionBlock:^(SFOAuthInfo * authInfo, SFUserAccount * userAccount) {
         [SFUserAccountManager sharedInstance].currentUser = userAccount;
        __weak typeof (weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.activityIndicator stopAnimating];
            [strongSelf.activityIndicator setHidden:YES];
        });
       
    } failure:^(SFOAuthInfo * authInfo, NSError * errror) {
         __weak typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@"failure %@",errror.localizedDescription);
        [strongSelf.activityIndicator stopAnimating];
        [strongSelf.activityIndicator setHidden:YES];
    } viewController: self];
}
@end
