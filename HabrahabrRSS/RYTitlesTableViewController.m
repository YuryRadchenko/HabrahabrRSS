//
//  RYTitlesTableViewController.m
//  HabrahabrRSS
//
//  Created by Yury Radchenko on 09.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYTitlesTableViewController.h"

#import "RYCoreDataManager.h"
#import "RYChannel.h"
#import "RYItem.h"
#import "RYTitleTableViewCell.h"
#import "RYCoreDataManager.h"
#import "RYChannelViewController.h"
#import "RYWebViewController.h"
#import "RYDateConverter.h"

static NSString * const kSegueChannel = @"ChannelSegue";
static NSString * const kSegueWebView = @"WebViewSegue";

@interface RYTitlesTableViewController ()

@end

@implementation RYTitlesTableViewController
{
    NSArray *_itemsArray;
    RYCoreDataManager *_dataManager;
    UIRefreshControl *_refreshControl;
    NSDate *_lastRefreshDate;
    UIEdgeInsets _edgeInsets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _edgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = _edgeInsets;
    
    _itemsArray = [NSMutableArray new];
    _dataManager = [RYCoreDataManager shareCoreDataManager];
    
    self.title = @"RSS";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self updateData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    _refreshControl.backgroundColor = [UIColor lightGrayColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    
    [self.tableView addSubview:_refreshControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Update Data
- (void) updateData
{
    [_dataManager
        updateData:^(NSArray *items, BOOL isNew) {
            
            if ((items && isNew) ||
                (items && !isNew && (_itemsArray.count == 0)))
            {
                _itemsArray = [items copy];
                [self.tableView reloadData];
            }
            //else {NSLog(@"НЕТ СМЫСЛА ОБНОВЛЯТЬ ТАБЛИЦУ");}
            
            _lastRefreshDate = [NSDate new];
            [_refreshControl endRefreshing];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
     
        onFailure:^(NSError *error, NSInteger statusCode) {
            
            [_refreshControl endRefreshing];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [self showAlertDialog:[error localizedDescription] statusCode:statusCode];
        }
    ];
}

- (void)refresh:(id)sender
{
    if (!_lastRefreshDate) {
        _lastRefreshDate = [NSDate new];
    }
    
    NSString *lastUpdateDateString = [RYDateConverter stringFromDate:_lastRefreshDate withFormat:RYDateFormatLastUpdateFeed];
    NSString *title = [NSString stringWithFormat:@"Последнее обновление: %@", lastUpdateDateString];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    _refreshControl.attributedTitle = attributedTitle;
    
    [self updateData];
}

//MARK: Table Life

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    RYItem *item = _itemsArray[indexPath.row];
    
    UILabel *testLabel = [[UILabel alloc] init];
    
    //Title Hight
    NSString *titleText = item.title;
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - (_edgeInsets.left + _edgeInsets.right), 20000.0f);
    
    NSString *fontName = testLabel.font.fontName;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:fontName size:17]};
    
    CGSize size = [titleText boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attr
                                          context:nil].size;
    
    CGFloat heightTitleLabel = size.height;
    
    //Other size
    CGFloat height = heightTitleLabel + 16 + 2 + 1;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RYTitleTableViewCell *cell = (RYTitleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.item = _itemsArray[indexPath.row];
    
    return cell;
}

//MARK: Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueChannel]) {
        RYChannelViewController *channelVC = segue.destinationViewController;
        channelVC.dataManager = _dataManager;
        
    } else if ([segue.identifier isEqualToString:kSegueWebView]) {
        RYTitleTableViewCell *cell = (RYTitleTableViewCell *) sender;
        
        RYWebViewController *webVC = segue.destinationViewController;
        webVC.articleLink = cell.item.link;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kSegueChannel] && !_dataManager.channel) {
        return NO;
    }
    
    return YES;
}

//MARK: Alert
- (void) showAlertDialog:(NSString*) errorDescribe statusCode:(NSInteger)statusCode
{
    NSString *alertTitle = @"";
    NSString *alertMessage = @"";
    NSString *cancelTitle = @"";
    NSString *repeatTitle = @"";
    
    switch (statusCode) {
        case 0:
        {
            alertTitle = @"Internet фсё";
            alertMessage = [NSString stringWithFormat:@"%@\nError%@\nCode:%li",
            @"Ну я не знаю... Интернетушка пропал. Ма доллар.\nЧто найду в CoreData, то и покажу.",
            errorDescribe, (long)statusCode];
            cancelTitle = @"Нет базара";
            repeatTitle = @"Не гони!";
        }
            break;
            
        default:
        {
            alertTitle = @"Опсь ...";
            alertMessage = [NSString stringWithFormat:@"%@\nError%@\nCode:%li",
                            @"Я таки дико извиняюсь, но где-то у нас случилось. Давайте что-то решать.",
                            errorDescribe, (long)statusCode];
            cancelTitle = @"В лес!";
            repeatTitle = @"Не понял";
        }
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:alertTitle
                          message:alertMessage
                          delegate:self
                          cancelButtonTitle:cancelTitle
                          otherButtonTitles:repeatTitle, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [self updateData];
        }
            break;
            
        default:
            break;
    }
}

@end
