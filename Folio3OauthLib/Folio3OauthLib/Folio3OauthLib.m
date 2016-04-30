//
//  Folio3OauthLib.m
//  Folio3OauthLib
//
//  Created by sruthi mainampati on 4/28/16.
//  Copyright © 2016 Folio3. All rights reserved.
//

#import "Folio3OauthLib.h"
#import "NXOAuth2.h"
#import "OAuthConstants.h"

static Folio3OauthLib *loginInstance = nil;
@interface Folio3OauthLib()<UIWebViewDelegate>
@end
@implementation Folio3OauthLib

+ (Folio3OauthLib *)sharedInstance{
    if (loginInstance == nil) {
        loginInstance = [[Folio3OauthLib alloc] init];
    }
    return loginInstance;
}

+ (void)close{
    loginInstance = nil;
}


- (BOOL)isUserLoggedIn {
    return [[[NXOAuth2AccountStore sharedStore] accountsWithAccountType:APP_OAUTH2_ACCOUNTYPE] count]?YES:NO;
}

- (void)logout {
    if ([self isUserLoggedIn] == NO) {
        return;
    }
    
    NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:APP_OAUTH2_ACCOUNTYPE];
    for (NXOAuth2Account *account in accounts){
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    }
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        //Initialization of Oauth Setup
        [[NXOAuth2AccountStore sharedStore] setClientID:APP_OAUTH2_CLIENTID
                                                 secret:APP_OAUTH2_SECRETID
                                       authorizationURL:[NSURL URLWithString:APP_OAUTH2_AUTHORIZATIONURL]
                                               tokenURL:[NSURL URLWithString:APP_OAUTH2_TOKENURL]
                                            redirectURL:[NSURL URLWithString:APP_OAUTH2_REDIRECTURL]
                                         forAccountType:APP_OAUTH2_ACCOUNTYPE];
        
        //Updating Confuguration with HeaderFields
        NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithDictionary:[[NXOAuth2AccountStore sharedStore] configurationForAccountType:APP_OAUTH2_ACCOUNTYPE]];
        
        NSDictionary *customHeaderFields = [NSDictionary dictionaryWithObject:APP_OAUTH2_CONFIGURATION forKey:@"Content-Type"];
        [configuration setObject:customHeaderFields forKey:kNXOAuth2AccountStoreConfigurationCustomHeaderFields];
        [[NXOAuth2AccountStore sharedStore] setConfiguration:configuration forAccountType:APP_OAUTH2_ACCOUNTYPE];
    }
    return self;
}

- (void)initiateLogin {
    [_wv_oauthLogin setDelegate:self];
    [_loadingActivityIndicator startAnimating];
    //Success CallBack
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NXOAuth2Account *account = [[aNotification userInfo] objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
                                                      NXOAuth2AccessToken *accessToken = account.accessToken;
                                                      // Update your UI
                                                      if (_delegate && [_delegate respondsToSelector:@selector(didLoginSuccess:)]) {
                                                          [_delegate didLoginSuccess:accessToken.accessToken];
                                                      }
                                                  }];
    //Failure CallBack
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      if (_delegate && [_delegate respondsToSelector:@selector(didLoginFailure:)]) {
                                                          [_delegate didLoginFailure:error];
                                                      }
                                                  }];
    
    //Login Request
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:APP_OAUTH2_ACCOUNTYPE
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                       [_wv_oauthLogin loadRequest:[NSURLRequest requestWithURL:preparedURL]];
                                   }];
}

#pragma mark - UIWebView Delegate Methods -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString rangeOfString:APP_OAUTH2_REDIRECTURL options:NSCaseInsensitiveSearch].location != NSNotFound) {
        [[NXOAuth2AccountStore sharedStore] handleRedirectURL:[NSURL URLWithString:request.URL.absoluteString]];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loadingActivityIndicator stopAnimating];
}


@end
