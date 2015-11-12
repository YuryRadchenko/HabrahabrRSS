//
//  RYTitleTableViewCell.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYTitleTableViewCell.h"
#import "RYDateConverter.h"

@implementation RYTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    //self.title.layer.borderWidth = 1;
}

- (void) setItem:(RYItem *)item
{
    _item = item;
    
    _title.text = item.title;
    
    NSString *dateStr = [RYDateConverter stringFromDate:_item.pubDate withFormat:RYDateFormatTodayInHHMM];
    _dateLabel.text = [NSString stringWithFormat:@"%@ от %@", dateStr, _item.author];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
