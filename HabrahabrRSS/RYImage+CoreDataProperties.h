//
//  RYImage+CoreDataProperties.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RYImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RYImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) RYChannel *channel;

@end

NS_ASSUME_NONNULL_END
