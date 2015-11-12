//
//  RYGuid+CoreDataProperties.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RYGuid.h"

NS_ASSUME_NONNULL_BEGIN

@interface RYGuid (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isPermaLink;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) RYItem *item;

@end

NS_ASSUME_NONNULL_END
