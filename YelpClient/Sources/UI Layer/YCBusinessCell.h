//
//  YCBusinessCell.h
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-10.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCBusiness.h"

@interface YCBusinessCell : UICollectionViewCell

- (void) updateWithBusiness:(YCBusiness *)business;

@end
