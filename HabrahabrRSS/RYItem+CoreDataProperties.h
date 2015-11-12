//
//  RYItem+CoreDataProperties.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RYItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RYItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *descriptionItem;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSDate *pubDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<RYCategory *> *categories;
@property (nullable, nonatomic, retain) RYChannel *channel;
@property (nullable, nonatomic, retain) RYGuid *grid;

@end

@interface RYItem (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(RYCategory *)value;
- (void)removeCategoriesObject:(RYCategory *)value;
- (void)addCategories:(NSSet<RYCategory *> *)values;
- (void)removeCategories:(NSSet<RYCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
