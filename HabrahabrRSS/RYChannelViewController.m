//
//  RYChannelViewController.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYChannelViewController.h"
#import "RYDateConverter.h"
#import "RYButtonBack.h"

@interface RYChannelViewController ()

@end

@implementation RYChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleLable.text = _dataManager.channel.title;
    _descriptionLabel.text = _dataManager.channel.descriptionChannel;
    _languageTitle.text = [NSString stringWithFormat:@"Language: %@", _dataManager.channel.language];
    _managerEditorLabel.text = [NSString stringWithFormat:@"Manager editor: %@", _dataManager.channel.managingEditor];
    _generatorLabel.text = [NSString stringWithFormat:@"Generator: %@", _dataManager.channel.generator];
    _pubDateLabel.text = [NSString stringWithFormat:@"Published date: %@",
                          [RYDateConverter stringFromDate:_dataManager.channel.pubDate withFormat:RYDateFormatTodayInHHMM]];
    
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
    
    [self setupBackButton];
    [self loadImageView];
    
    self.title = @"Про канал";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadImageView
{
    [_dataManager channelImage:^(UIImage *image) {
        _imageView.image = image;
        [_activityIndicator stopAnimating];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error = %@, code = %li", [error localizedDescription], (long)statusCode);
        [_activityIndicator stopAnimating];
    }];
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

@end
