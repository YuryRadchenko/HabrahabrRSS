//
//  RYServerManager.h
//  HabrahabrRSS
//
//  Created by Yury Radchenko on 09.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RYServerManager : NSObject

+ (RYServerManager*) shareManager;

- (void) getRSSFrom:(NSString *)link onSuccess:(void(^)(NSDictionary *dictionary))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer;
- (void) loadImageByLink:(NSString *)imageLink onSuccess:(void(^)(UIImage *img))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer;

@end
