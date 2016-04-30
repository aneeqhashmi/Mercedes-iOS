//
//  ViewController.m
//  Folio3OAuthSample
//
//  Created by sruthi mainampati on 4/28/16.
//  Copyright © 2016 Folio3. All rights reserved.
//

#import "ViewController.h"
#import "Folio3OauthLib.h"

@interface ViewController ()<OAuthLoginDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    _btn_login.hidden = YES;
    [Folio3OauthLib sharedInstance].wv_oauthLogin = _wv_login;
    [[Folio3OauthLib sharedInstance] initiateLogin];
    [[Folio3OauthLib sharedInstance] setDelegate:self];
}


#pragma mark - OAuthLogin Delegate Methods-

- (void)didLoginSuccess:(NSString *)accessToken {
    
    // Save Data into CoreData (Encrypted)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SUCCESS" message:[NSString stringWithFormat:@"Logged in Successfully. \n AccessToken = %@",accessToken] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:NO completion:nil];
    
}

- (void)didLoginFailure:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:NO completion:nil];
}

@end
