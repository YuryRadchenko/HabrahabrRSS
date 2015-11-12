//
//  RYWebViewController.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYWebViewController.h"
#import "RYButtonBack.h"

@interface RYWebViewController ()

@end

@implementation RYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor lightGrayColor];
    
    [self loadWebView];
    
    [self setupBackButton];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void) loadWebView
{
    
    [_activityIndicator startAnimating];
    self.webView.alpha = 0.0f;
    NSURL *url = [NSURL URLWithString:_articleLink];
    NSURLRequest *requestArticle = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestArticle];
}

- (void) backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    
    [UIView animateWithDuration:1.5f
                     animations:^{
                         webView.alpha = 1.0f;
                     }
     ];
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
            [self loadWebView];
        }
            break;
            
        default:
            break;
    }
}

@end
