//
//  YCBusinessCell.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-10.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCBusinessCell.h"

@interface YCBusinessCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;


@end

@implementation YCBusinessCell

- (void) awakeFromNib {
    [self.layer setShadowOffset:CGSizeMake(0, -10)];
    [self.layer setShadowRadius:1];
    [self.layer setShadowOpacity:1];
    [self.layer setShadowColor:[UIColor lightGrayColor].CGColor];
}

- (void) updateWithBusiness:(YCBusiness *)business {
    self.name.text = business.name;

    [business getBusinessImage:^(UIImage * _Nonnull image) {
        self.businessImage.image = image;
    }];

    [business getRatingImage:^(UIImage * _Nonnull image) {
        self.ratingImage.image = image;
    }];
}

@end
