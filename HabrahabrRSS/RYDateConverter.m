//
//  RYDateConverter.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYDateConverter.h"

@implementation RYDateConverter

+ (NSDate *) dateFromString:(NSString *) stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    
    NSLocale *localeUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:localeUS];
    
    return [dateFormatter dateFromString:stringDate];
}

+ (NSString *) stringFromDate:(NSDate *)date withFormat:(RYDateFormat)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    switch (dateFormat) {
        case RYDateFormatNoStyle:
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [dateFormatter setDateFormat:@"dd MMMM HH:mm"];
            return [dateFormatter stringFromDate:date];
        }
            break;

        case RYDateFormatTodayInHHMM:
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date];
            NSDateComponents *today = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate:[NSDate date]];
            NSDateComponents *yesterday = [[NSDateComponents alloc] init];
            [yesterday setDay:-1];
            
            NSString *dayString = @"";
            
            if ([today day] == [otherDay day]) {
                dayString = @"сегодня";
            }
            
            else if ([yesterday day] == [otherDay day]) {
                 dayString = @"вчера";
            
            } else {
                [dateFormatter setDateFormat:@"dd MMMM"];
                dayString = [dateFormatter stringFromDate:date];
            }
            
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *timeString = [dateFormatter stringFromDate:date];
        
            return [NSString stringWithFormat:@"%@ в %@", dayString, timeString];
        }
            break;
            
        case RYDateFormatLastUpdateFeed:
        {
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"dd MMMM HH:mm:ss"];
            return [dateFormatter stringFromDate:date];
        }
            break;
            
        default:
            return @"";
            break;
    }
}

@end
