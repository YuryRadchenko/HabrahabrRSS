//
//  RYWebViewController.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYWebViewController.h"
#import "RYButtonBack.h"
#import "UIWebView+Clean.h"

@interface RYWebViewController ()

@end

@implementation RYWebViewController
{
    NSURLRequest *_requestArticle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSURL *url = [NSURL URLWithString:_articleLink];
    _requestArticle = [NSURLRequest requestWithURL:url];
    
    self.webView.backgroundColor = [UIColor lightGrayColor];
    [self setupWebView];
    [self.webView loadRequest:_requestArticle];
    
    [self setupBackButton];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self freeMemory];
    [self.webView cleanForDealloc];
    self.webView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self freeMemory];
    [self setupWebView];
    [self.webView reload];
}

//MARK: Setups
- (void) setupBackButton
{
    RYButtonBack *backButton = [[RYButtonBack alloc] initWithTarget:self action:@selector(backAction)];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

//MARK: Actions
- (void) backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: UIWebView delegate
- (void) setupWebView
{
    self.webView.delegate = self;
}

- (void)freeMemory
{
    //[self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [_activityIndicator stopAnimating];
    [self showAlertDialog:[error localizedDescription] statusCode:error.code];
}

//MARK: Alert
- (void) showAlertDialog:(NSString*) errorDescribe statusCode:(NSInteger)statusCode
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Опсь ..."
                          message:[NSString stringWithFormat:@"%@\nError%@\nCode:%li",
                                   @"Я таки дико извиняюсь, но где-то у нас случилось. Давайте что-то решать.",
                                   errorDescribe, (long)statusCode]
                          delegate:self
                          cancelButtonTitle:@"В лес!"
                          otherButtonTitles:@"Обнаглели!", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [self.webView reload];
        }
            break;
            
        default:
            break;
    }
}

@end
