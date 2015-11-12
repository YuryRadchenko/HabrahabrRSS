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
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
