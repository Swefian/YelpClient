//
//  YCReview.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-10.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCReview.h"

@implementation YCReview

#define kRatingKey      @"rating"
#define kExcerptKey     @"excerpt"
#define kTimeCreatedKey @"time_created"
#define kAuthorKey      @"user.name"

- (instancetype) initWithJson:(NSDictionary *)json business:(YCBusiness *)business {
    self = [super init];

    _business = business;
    _rating = json[kRatingKey];
    _excerpt = json[kExcerptKey];
    _author = [json valueForKeyPath:kAuthorKey];
    _timeCreated = [NSDate dateWithTimeIntervalSince1970:[json[kTimeCreatedKey] doubleValue]];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", self.rating, self.excerpt];
}

@end
