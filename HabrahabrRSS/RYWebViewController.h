//
//  RYWebViewController.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *articleLink;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
