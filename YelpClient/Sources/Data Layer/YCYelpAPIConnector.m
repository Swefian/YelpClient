//
//  YCYelpConnector.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-09.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCYelpAPIConnector.h"
#import "TDOAuth.h"
#import "YCBusiness.h"

#define kBaseUrl         @"api.yelp.com/v2/"

#define kConsumerKey     @"9lLiXaWsimlw1FssyuebLw"
#define kConsumerSecret  @"UD5ciOgKZuJ7iyPnl9rMxeZxAjM"
#define kToken           @"AU9JPLXGoiLvAzzb53qcqZ-UkjHSICgd"
#define kTokenSecret     @"5uBceeU_wm5sYvQ5HoMpURpPjng"

@implementation YCYelpAPIConnector

+ (void) GET:(NSString *)path
  parameters:(NSDictionary *)parameters
     success:(JsonBlock)successBlock
     failure:(ErrorBlock)failureBlock {

    NSURLRequest *request = [TDOAuth URLRequestForPath:path
                                         GETParameters:parameters
                                                  host:kBaseUrl
                                           consumerKey:kConsumerKey
                                        consumerSecret:kConsumerSecret
                                           accessToken:kToken
                                           tokenSecret:kTokenSecret];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error);
            });
        } else {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(json);
            });
        }
    }];

    [task resume];
}

@end
