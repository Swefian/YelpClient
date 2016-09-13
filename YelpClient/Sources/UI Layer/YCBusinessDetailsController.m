//
//  YCBusinessDetailsController.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-12.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCBusinessDetailsController.h"
#import "YCBusiness.h"
#import "YCReview.h"

@import MapKit;
@import SafariServices;

@interface YCBusinessDetailsController () <MKMapViewDelegate>
@property (nonatomic, strong) YCBusiness *business;

@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UITextView *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation YCBusinessDetailsController

- (instancetype) initWithBusiness:(YCBusiness *)business {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    _business = business;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindData];
    [self configureMapView];
}

- (void) bindData {
        // Bind all the data from the Business Model
    __weak typeof(self) weakSelf = self;
    self.title = self.business.name;

    [self.business getBusinessImage:^(UIImage * _Nonnull image) {
        weakSelf.businessImage.image = image;
    }];

    [self.business getRatingImage:^(UIImage * _Nonnull image) {
        weakSelf.ratingImage.image = image;
    }];

    self.phoneLabel.text = self.business.phoneNumber;
    self.addressLabel.text = [self.business.address componentsJoinedByString:@"\n"];

    [self.business getReviews:^(NSArray<YCReview *> * _Nonnull reviews) {
            // The Yelp api onyl returns a single review.  Hopefull that will change
            // in the V3 version of the API
        YCReview *review = [reviews firstObject];
        self.reviewLabel.text = [NSString stringWithFormat:@"%@ Stars\n\n%@\n\n%@", review.rating, review.excerpt, review.author];
    } failure:^(NSError *error) {
        [self.reviewLabel setText:@"No Reviews"];
    }];
}

- (void) configureMapView {
    // Center the map to the business and add single pin
    MKMapCamera *camera = [[MKMapCamera alloc] init];
    [camera setCenterCoordinate:self.business.coordinate];
    [camera setAltitude:8000];
    [self.mapView setCamera:camera];

    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate:self.business.coordinate];
    [pin setTitle:self.business.name];
    [self.mapView addAnnotation:pin];
}

- (IBAction)viewOnYelpTapped:(id)sender {
    // Open Safari to see the full page for this business instead of the limited one
    // provided by this the Yelp API.
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:self.business.webUrl entersReaderIfAvailable:NO];
    [self presentViewController:safari animated:YES completion:nil];
}

- (IBAction)mapTapped:(id)sender {
    // Open the full maps app with the location of the business
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.business.coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:self.business.name];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
