//
//  RYDateConverter.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RYDateFormat) {
    RYDateFormatNoStyle,
    RYDateFormatTodayInHHMM,
    RYDateFormatLastUpdateFeed
};

@interface RYDateConverter : NSObject

+ (NSDate *) dateFromString:(NSString *) stringDate;
+ (NSString *) stringFromDate:(NSDate *)date withFormat:(RYDateFormat)dateFormat;

@end
