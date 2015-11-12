//
//  RYCoreDataManager.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 10.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYCoreDataManager.h"

#import "RYServerManager.h"
#import "RYCategory.h"
#import "RYGuid.h"
#import "RYImage.h"
#import "RYItem.h"
#import "RYKeys.h"
#import "RYDateConverter.h"

static NSString *kRssLink = @"http://habrahabr.ru/rss/hubs";
static NSString *kEntityChannel = @"RYChannel";
static NSString *kEntityCategory = @"RYCategory";
static NSString *kEntityGuid = @"RYGuid";
static NSString *kEntityImage = @"RYImage";
static NSString *kEntityItem = @"RYItem";

@implementation RYCoreDataManager
{
    RYServerManager *_serverManager;
}

//MARK: Init
+ (RYCoreDataManager *) shareCoreDataManager
{
    static dispatch_once_t onceToken;
    static RYCoreDataManager *coreDataManager = nil;
    
    dispatch_once(&onceToken, ^{
        coreDataManager = [[RYCoreDataManager alloc] init];
    });
    
    return coreDataManager;
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        [self managedObjectContext];
        _serverManager = [RYServerManager shareManager];
        _channel = [self channel];
    }
    
    return self;
}

//MARK: Server Connect
- (void) updateData:(void(^)(NSArray *items, BOOL isNew))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer
{
    __block BOOL isRecordInDatabase = NO;
    __block BOOL isAscendingItemsArray = NO;
    
    if (success) {
        success ([self itemsSortBy:RYSortByPubDate ascending:isAscendingItemsArray], isRecordInDatabase);
    }
    
    [_serverManager getRSSFrom:kRssLink
                     onSuccess:^(NSDictionary *dictionary) {

                         if (dictionary[kChannel]) {
                             NSDictionary *channelDict = dictionary[kChannel];
                             
                             if (channelDict[kPubDate]) {
                                 NSString *channelPubDateString= channelDict[kPubDate];
                                 NSDate *channelPubDate = [RYDateConverter dateFromString:channelPubDateString];
                                 
                                 NSDate *pubDate = self.channel.pubDate;
                                 
                                 if ((pubDate == nil) ||
                                     (pubDate && ![pubDate isEqualToDate:channelPubDate])) {
                                     isRecordInDatabase = YES;
                                 }
                                 
                                 if (isRecordInDatabase) {
                                     
                                     RYChannel *channelNew = [NSEntityDescription insertNewObjectForEntityForName:kEntityChannel inManagedObjectContext:self.managedObjectContext];
                                     
                                     channelNew.pubDate = channelPubDate;
                                     
                                     if (channelDict[kTitle]) {
                                         channelNew.title = channelDict[kTitle];;
                                     }
                                     
                                     if (channelDict[kLink]) {
                                         channelNew.link = channelDict[kLink];
                                         
                                     }
                                     
                                     if (channelDict[kDescription]) {
                                         channelNew.descriptionChannel = channelDict[kDescription];
                                     }
                                     
                                     if (channelDict[kLanguage]) {
                                         channelNew.language = channelDict[kLanguage];
                                     }
                                     
                                     if (channelDict[kManagingEditor]) {
                                         channelNew.managingEditor = channelDict[kManagingEditor];
                                     }
                                     
                                     if (channelDict[kGenerator]) {
                                         channelNew.generator = channelDict[kGenerator];
                                     }
                                     
                                     [self saveContext];
                                     
                                     //IMAGE
                                     if (channelDict[kImage]) {
                                         
                                         RYImage *imageNew = [NSEntityDescription insertNewObjectForEntityForName:kEntityImage inManagedObjectContext:self.managedObjectContext];
                                         imageNew.channel = channelNew;
                                         
                                         NSDictionary *channelImageDict=channelDict[kImage];
                                         
                                         if (channelImageDict[kImageLink]) {
                                             imageNew.link = channelImageDict[kImageLink];
                                         }
                                         
                                         if (channelImageDict[kImageUrl]) {
                                             imageNew.url = channelImageDict[kImageUrl];
                                         }
                                         
                                         if (channelImageDict[kImageTitle]) {
                                             imageNew.title = channelImageDict[kImageTitle];
                                         }
                                         
                                         [self saveContext];
                                     }
                                     
                                     //ARRAY ITEMS
                                     if (channelDict[kItem])
                                     {
                                         NSArray *items = channelDict[kItem];
                                         
                                         for (NSDictionary *item in items)
                                         {
                                             RYItem *itemNew = [NSEntityDescription insertNewObjectForEntityForName:kEntityItem inManagedObjectContext:self.managedObjectContext];
                                             itemNew.channel = channelNew;
                                             
                                             if (item[kItemTitle]) {
                                                 itemNew.title = item[kItemTitle];
                                             }
                                             
                                             if (item[kItemLink]) {
                                                 itemNew.link = item[kItemLink];
                                             }
                                             
                                             if (item[kItemDescription]) {
                                                 itemNew.descriptionItem = item[kItemDescription];
                                             }
                                             
                                             if (item[kItemPubDate]) {
                                                 NSString *itemPubDate = item[kItemPubDate];
                                                 itemNew.pubDate = [RYDateConverter dateFromString:itemPubDate];
                                             }
                                             
                                             if (item[kItemAuthor]) {
                                                 itemNew.author = item[kItemAuthor];
                                             }
                                             
                                             [self saveContext];
                                             
                                             //CATEGORY
                                             if (item[kItemCategory]) {
                                                 
                                                 NSArray *itemCategories = item[kItemCategory];
                                                 
                                                 for (NSString *category in itemCategories) {
                                                     
                                                     RYCategory *categoryNew = [NSEntityDescription insertNewObjectForEntityForName:kEntityCategory inManagedObjectContext:self.managedObjectContext];
                                                     categoryNew.item = itemNew;
                                                     categoryNew.title = category;
                                                     
                                                     [self saveContext];
                                                 }
                                             }
                                             
                                             //GUID
                                             if (item[kItemGuid]) {
                                                 
                                                 RYGuid *guidNew = [NSEntityDescription insertNewObjectForEntityForName:kEntityGuid inManagedObjectContext:self.managedObjectContext];
                                                 guidNew.item = itemNew;
                                                 
                                                 NSDictionary *itemGuid = item[kItemGuid];
                                                 
                                                 if (itemGuid[kItemGuidText]) {
                                                     guidNew.text = itemGuid[kItemGuidText];
                                                 }
                                                 
                                                 if (itemGuid[kItemGuidIsPermaLink]) {
                                                     NSString *itemGuidIsPermaLink = itemGuid[kItemGuidIsPermaLink];
                                                     
                                                     if ([itemGuidIsPermaLink isEqualToString:@"true"]) {
                                                         guidNew.isPermaLink = [NSNumber numberWithBool:YES];
                                                     } else {
                                                         guidNew.isPermaLink = [NSNumber numberWithBool:NO];
                                                     }
                                                 }
                                                 
                                                 [self saveContext];
                                             }
                                         }
                                        
                                         [self deleteOldChannels];
                                         
                                     }
                                 }
                             }
                         }
                         
                         if (success) {
                             success ([self itemsSortBy:RYSortByPubDate ascending:isAscendingItemsArray], isRecordInDatabase);
                         }
                         
                     }
                     onFailure:^(NSError *error, NSInteger statusCode) {

                         if (failer) {
                             failer (error, statusCode);
                         }
                         
                     }
     ];
}

- (void) deleteOldChannels
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description =
    [NSEntityDescription entityForName:kEntityChannel inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError* requestError = nil;
    NSArray* allChannels = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (!requestError) {
        
        for (NSInteger i=0; i < allChannels.count-1; i++) {
            RYChannel *deleteChannel = allChannels[i];
            [self.managedObjectContext deleteObject:deleteChannel];
            [self.managedObjectContext save:nil];
        }
        
    } else {
        NSLog(@"Error = %@", [requestError localizedDescription]);
    }
}

- (void) channelImage:(void(^)(UIImage * image))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer
{
    if (success && self.channel.image.image) {
        success ([UIImage imageWithData:_channel.image.image]);
    }
    
    [_serverManager loadImageByLink:self.channel.image.url
                          onSuccess:^(UIImage *img) {
                              
                              if (img) {
                                  
                                  self.channel.image.image = UIImagePNGRepresentation(img);
                                  [self saveContext];
                                  
                                  if (success) {
                                      success (img);
                                  }
                                  
                              } else {
                                  if (success) {
                                      success (nil);
                                  }
                              }
                              
                          }
                          onFailure:^(NSError *error, NSInteger statusCode) {
                              if (failer) {
                                  failer (error, statusCode);
                              }
                          }
     ];
}

//MARK: Getters
- (NSArray *) itemsSortBy:(RYSortBy)sortBy ascending:(BOOL)isAsceding
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description =
    [NSEntityDescription entityForName:kEntityItem inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSString *keyDescriptor;
    switch (sortBy) {
        case RYSortByPubDate: keyDescriptor = @"pubDate"; break;
        case RYSortByTitle: keyDescriptor = @"title"; break;
        default: keyDescriptor = @"pubDate"; break;
    }
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyDescriptor ascending:isAsceding];
    [request setSortDescriptors:@[sortDescriptor]];
    
    
    NSError* requestError = nil;
    NSArray* itemsArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"Error = %@", [requestError localizedDescription]);
        return nil;
        
    } else if (itemsArray.count > 0) {
        return itemsArray;
        
    } else {
        return nil;
    }
}

- (RYChannel *) channel
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:kEntityChannel
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* channelsArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"Error = %@", [requestError localizedDescription]);
    }
    
    if (channelsArray.count > 0) {
        RYChannel *channel = channelsArray[0];
        _channel = channel;
        return channel;
    } else {
        _channel = nil;
        return nil;
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ipadchenko.HabrahabrRSS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HabrahabrRSS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HabrahabrRSS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
