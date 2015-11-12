//
//  RYItem.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RYCategory, RYChannel, RYGuid;

NS_ASSUME_NONNULL_BEGIN

@interface RYItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RYItem+CoreDataProperties.h"
