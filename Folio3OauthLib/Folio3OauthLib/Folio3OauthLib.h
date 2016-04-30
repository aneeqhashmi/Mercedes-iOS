//
//  Folio3OauthLib.h
//  Folio3OauthLib
//
//  Created by sruthi mainampati on 4/28/16.
//  Copyright © 2016 Folio3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol OAuthLoginDelegate <NSObject>
/**
 Call back method notfies lister with the access token when user logged in successfully.
 */
- (void)didLoginSuccess:(NSString *)accessToken;

/**
 Call back method notfies listner with the error information when the user logged in failed.
 */
- (void)didLoginFailure:(NSError *)error;
@end


@interface Folio3OauthLib : NSObject

/**
 @required: Assign the webview instance to show the OAuthLogin Page
 */
@property (weak, nonatomic) UIWebView *wv_oauthLogin;
/**
 Add Listener to listen the call back methods.
 */
@property (weak, nonatomic) id<OAuthLoginDelegate> delegate;
/**
 @optional : Assign the loading Indicator instance to show the loading symbol while loading web page.
 */
@property (weak, nonatomic) UIActivityIndicatorView *loadingActivityIndicator;
/**
 Returns the Shared Instance.
 */
+ (Folio3OauthLib *)sharedInstance;
/**
 Clear the instance.
 */
+ (void)close;

/**
 Call this when it required to show Login.
 */
- (void)initiateLogin;

/**
 Get the user logged in status.
 */
- (BOOL)isUserLoggedIn;

/**
 Logout the current logged In User.
 */
- (void)logout;
@end

