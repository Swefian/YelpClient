//
//  YCBusinessDetailsController.h
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-12.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCBusiness;
@interface YCBusinessDetailsController : UIViewController

- (instancetype) initWithBusiness:(YCBusiness *)business;

@end
