//
//  RYAboutViewController.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYAboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)doneButtonPressed:(id)sender;

@end
