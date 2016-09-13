//
//  YCRestaurant.h
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-09.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreLocation;
#import "YCContants.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YCSort) {
    YCSortBestMatched = 0,
    YCYSortDistance = 1,
    YCSortHighestRated = 2
};

@class YCReview;
typedef void (^ImageBlock)(UIImage *image);
@interface YCBusiness : NSObject

@property (nonatomic, copy,   readonly) NSString *businessId;
@property (nonatomic, copy,   readonly) NSString *name;
@property (nonatomic, strong, readonly) NSURL    *webUrl;

@property (nonatomic, strong, readonly) NSString   *phoneNumber;
@property (nonatomic, strong, readonly) NSArray    *address;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

// Factory Pattern that connects to API
+ (void) findBusinessesWithSearchTerm:(NSString *)searchTerm
                          withSorting:(YCSort)sort
                           completion:(void (^)(NSArray<YCBusiness *> *businesses))completionBlock
                              failure:(ErrorBlock)failureBlock;

- (instancetype) initWithJson:(NSDictionary *)json;

- (void) getBusinessImage:(ImageBlock)completionBlock;
- (void) getRatingImage:(ImageBlock)completionBlock;

- (void) getReviews:(void(^)(NSArray<YCReview *> *reviews))successBlock
            failure:(ErrorBlock)failure;

@end
NS_ASSUME_NONNULL_END
