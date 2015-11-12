//
//  RYTitleTableViewCell.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYItem.h"

@interface RYTitleTableViewCell : UITableViewCell

@property (nonatomic, strong) RYItem *item;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
