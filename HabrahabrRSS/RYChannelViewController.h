//
//  RYChannelViewController.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYCoreDataManager.h"

@interface RYChannelViewController : UIViewController

@property (nonatomic, strong) RYCoreDataManager *dataManager;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageTitle;

@property (weak, nonatomic) IBOutlet UILabel *managerEditorLabel;
@property (weak, nonatomic) IBOutlet UILabel *generatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
