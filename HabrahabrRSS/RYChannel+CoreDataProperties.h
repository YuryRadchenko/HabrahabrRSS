//
//  RYChannel+CoreDataProperties.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RYChannel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RYChannel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *descriptionChannel;
@property (nullable, nonatomic, retain) NSString *generator;
@property (nullable, nonatomic, retain) NSString *language;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *managingEditor;
@property (nullable, nonatomic, retain) NSDate *pubDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<RYItem *> *items;
@property (nullable, nonatomic, retain) RYImage *image;

@end

@interface RYChannel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(RYItem *)value;
- (void)removeItemsObject:(RYItem *)value;
- (void)addItems:(NSSet<RYItem *> *)values;
- (void)removeItems:(NSSet<RYItem *> *)values;

@end

NS_ASSUME_NONNULL_END
