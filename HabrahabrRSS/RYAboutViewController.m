//
//  RYAboutViewController.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYAboutViewController.h"


@interface RYAboutViewController ()

@end

@implementation RYAboutViewController
{
    NSString* _htmlString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Задание";
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.bounces = NO;
    
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource:@"aboutTask"
                                                         ofType:@"html"
                                                    inDirectory:nil
                                                forLocalization:nil];
    
    _htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    [self setupWebView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.webView cleanForDealloc];
    self.webView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self freeMemory];
    [self setupWebView];
}

- (void)doneButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: webView
- (void) setupWebView
{
    self.webView.delegate = self;
    [_webView loadHTMLString:_htmlString baseURL:nil];
}

- (void)freeMemory
{
    [self.webView loadHTMLString:@"" baseURL:nil];
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

- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    // Clear cache
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

@end
