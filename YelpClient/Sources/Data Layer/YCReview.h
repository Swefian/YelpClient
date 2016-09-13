//
//  YCReview.h
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-10.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCBusiness;

@interface YCReview : NSObject
@property (nonatomic, weak) YCBusiness *business;
@property (nonatomic, copy, readonly) NSString *excerpt;
@property (nonatomic, copy, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSDate *timeCreated;
@property (nonatomic, strong, readonly) NSNumber *rating;

- (instancetype) initWithJson:(NSDictionary *)json business:(YCBusiness *)business;

@end
