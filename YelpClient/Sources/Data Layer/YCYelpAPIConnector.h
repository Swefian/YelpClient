//
//  YCYelpConnector.h
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-09.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

@import Foundation;
@class YCBusiness;
#import "YCContants.h"

@interface YCYelpAPIConnector : NSObject

+ (void) GET:(NSString *)path
  parameters:(NSDictionary *)parameters
     success:(JsonBlock)successBlock
     failure:(ErrorBlock)failureBlock;

@end
