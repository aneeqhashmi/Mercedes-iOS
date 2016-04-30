//
//  ViewController.h
//  Folio3OAuthSample
//
//  Created by sruthi mainampati on 4/28/16.
//  Copyright © 2016 Folio3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *wv_login;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;
- (IBAction)loginAction:(id)sender;

@end

