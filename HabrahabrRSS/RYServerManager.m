//
//  RYServerManager.m
//  HabrahabrRSS
//
//  Created by Yury Radchenko on 09.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYServerManager.h"
#import <AFNetworking.h>
#import <XMLDictionary.h>

@implementation RYServerManager

+ (RYServerManager *) shareManager
{
    static dispatch_once_t onceToken;
    static RYServerManager *manager = nil;
    
    dispatch_once(&onceToken, ^{
        manager = [[RYServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        //if need
    }
    return self;
}

- (void) getRSSFrom:(NSString *)link onSuccess:(void(^)(NSDictionary *dictionary))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer
{
    AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = responseSerializer;
    
    [manager GET:link
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             if ([responseObject isKindOfClass:[NSData class]]) {
                 
                 if (success) {
                     success ([NSDictionary dictionaryWithXMLData:responseObject]);
                 }
             }
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             
             if (failer) {
                 failer(error, operation.response.statusCode);
             }
         }
     ];
    
}

- (void) loadImageByLink:(NSString *)imageLink onSuccess:(void(^)(UIImage *img))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failer
{
    NSURLRequest *urlReqest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:imageLink]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlReqest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage *imageDownload = (UIImage *) responseObject;
        
        if (success) {
            success(imageDownload);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failer) {
            failer(error, operation.response.statusCode);
        }
        
    }];
    
    [requestOperation start];
}


@end
