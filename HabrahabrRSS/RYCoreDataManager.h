//
//  RYCoreDataManager.h
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RYChannel.h"

typedef NS_ENUM(NSInteger, RYSortBy) {
    RYSortByPubDate = 0,
    RYSortByTitle
};

@interface RYCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) RYChannel *channel;

+ (RYCoreDataManager *) shareCoreDataManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) updateData:(void(^)(NSArray *items, BOOL isNew))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer;
- (void) channelImage:(void(^)(UIImage * image))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer;

- (NSArray *) itemsSortBy:(RYSortBy)sortBy ascending:(BOOL)isAsceding;

@end
