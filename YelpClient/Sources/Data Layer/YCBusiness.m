//
//  YCRestaurant.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-09.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCYelpAPIConnector.h"
#import "YCBusiness.h"
#import "YCReview.h"

#define kSearchKey      @"term"
#define kSortKey        @"sort"
#define kLocationKey    @"location"
#define kNumberOfResult @"limit"

#define kIdKey @"id"
#define kImageUrlKey @"image_url"
#define kRatingUrlKey @"rating_img_url_large"
#define kNameKey @"name"
#define kWebUrlKey @"mobile_url"
#define kPhoneNumberKey @"display_phone"
#define kAddressKey @"location.display_address"
#define kLongitudeKey @"location.coordinate.longitude"
#define kLatitudeKey @"location.coordinate.latitude"

@interface YCBusiness()
@property (nonatomic, copy) NSString  *businessId;
@property (nonatomic, strong) NSURL   *businessImageUrl;
@property (nonatomic, strong) NSURL   *ratingUrl;

@property (nonatomic, strong) UIImage *businessImage;
@property (nonatomic, strong) UIImage *ratingImage;

@property (nonatomic, strong) NSArray<YCReview *> *reviews;

@end

@implementation YCBusiness

#pragma mark - Factory Pattern

+ (void) findBusinessesWithSearchTerm:(NSString *)searchTerm
                          withSorting:(YCSort)sort
                           completion:(void (^)(NSArray<YCBusiness *> *businesses))completionBlock
                              failure:(ErrorBlock)failureBlock {

    NSDictionary *parameters = @{kSearchKey : searchTerm,
                                 kLocationKey: @"Toronto",
                                 kSortKey: @(sort),
                                 kNumberOfResult: @(10)};

    [YCYelpAPIConnector GET:@"search" parameters:parameters success:^(id json) {
        NSMutableArray *businesses = [[NSMutableArray alloc] init];
        NSArray *jsonBusinesses = json[@"businesses"];
        for (NSDictionary *jsonBusiness in jsonBusinesses) {
            YCBusiness *business = [[YCBusiness alloc] initWithJson:jsonBusiness];
            [businesses addObject:business];
        }

        // return an immutable version of the business array
        completionBlock(businesses.copy);

    } failure:failureBlock];
}

#pragma mark - instance methods

- (instancetype) initWithJson:(NSDictionary *)json {
    self = [super init];

    _businessId = json[kIdKey];
    _businessImageUrl = [self urlForKey:kImageUrlKey fromJson:json];
    _ratingUrl = [self urlForKey:kRatingUrlKey fromJson:json];

    _name = json[kNameKey];
    _webUrl = [self urlForKey:kWebUrlKey fromJson:json];
    _phoneNumber = json[kPhoneNumberKey];

    _address = [json valueForKeyPath:kAddressKey];

    double longitude = [[json valueForKeyPath:kLongitudeKey] doubleValue];
    double latitude = [[json valueForKeyPath:kLatitudeKey] doubleValue];
    _coordinate = CLLocationCoordinate2DMake(latitude, longitude);

    return self;
}

- (NSURL *)urlForKey:(NSString *)key fromJson:(NSDictionary *)json {
    return [NSURL URLWithString:json[key]];
}


- (NSString *)description {
    return self.name;
}


#pragma mark - Lazy Data Retrieval

- (void) getBusinessImage:(ImageBlock)completionBlock {
    [self getImage:self.businessImage
 orRetrieveFromUrl:self.businessImageUrl
   withSetSelector:@selector(setBusinessImage:)
              then:completionBlock];
}

- (void) getRatingImage:(ImageBlock)completionBlock {
    [self getImage:self.ratingImage
 orRetrieveFromUrl:self.ratingUrl
   withSetSelector:@selector(setRatingImage:)
              then:completionBlock];
}

- (void) getReviews:(void (^)(NSArray<YCReview *> * _Nonnull))successBlock failure:(ErrorBlock)failure {
    if (self.reviews) {
        successBlock(self.reviews);
        return;
    }

    NSString *path = [NSString stringWithFormat:@"business/%@", self.businessId];
    [YCYelpAPIConnector GET:path parameters:nil success:^(id json) {
        NSMutableArray<YCReview *> *reviews = [[NSMutableArray alloc] init];
        NSArray *jsonReviews = json[@"reviews"];

        for (NSDictionary *jsonReview in jsonReviews) {
            YCReview *review = [[YCReview alloc] initWithJson:jsonReview business:self];
            [reviews addObject:review];
        }

        _reviews = [reviews copy];
        successBlock(reviews);
    } failure:failure];
}

/**
 * Centralized method for lazily getting images from the network 
 * the first time they are requested.
 *
 * Subsequent calls to this method will just return the cached image
 */
- (void) getImage:(UIImage *)image
orRetrieveFromUrl:(NSURL *)url
  withSetSelector:(SEL)setSelector
             then:(ImageBlock)completionBlock {

    if (image) {
        completionBlock(image);
        return;
    }

    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *retrievedImage = [UIImage imageWithData:data];

        // Quick and dirty compiler hack to supress the unknown selector warning
        // In production apps, you should probably not do this.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [weakSelf performSelector:setSelector withObject:retrievedImage];
#pragma clang diagnostic pop

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(retrievedImage);
        });
    }];
    [task resume];
}

@end
