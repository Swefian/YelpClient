//
//  AutoLayoutHelper.m
//
//

#import "AutoLayoutHelper.h"

@implementation AutoLayoutHelper

+ (void) pinSubview:(UIView *)view
          attribute:(NSLayoutAttribute)attribute
           constant:(CGFloat)constant {

    [view.superview addConstraint:[self pinnedConstraintForView:view toView:view.superview attribute:attribute constant:constant]];
}

+ (void) centerView:(UIView *)view
          superview:(UIView *)superview {
    NSDictionary *centerAttrbutes = @{@(NSLayoutAttributeCenterX) : @0,
                                      @(NSLayoutAttributeCenterY) : @0};
    [self pinSubview:view superview:superview attributesAndConstants:centerAttrbutes];
}

+ (void) setSize:(CGSize)size view:(UIView *)view {
    [self addInstrinsticConstraintToView:view attribute:NSLayoutAttributeWidth constant:size.width];
    [self addInstrinsticConstraintToView:view attribute:NSLayoutAttributeHeight constant:size.height];
}

+ (void) pinAllEdgesOfView:(UIView *)view
               toSuperview:(UIView *)superview
                 edgeInset:(UIEdgeInsets)edgeInset {
    
    NSDictionary *allEdges = @{@(NSLayoutAttributeLeading): @(edgeInset.left),
                               @(NSLayoutAttributeTop) : @(edgeInset.top),
                               @(NSLayoutAttributeTrailing) : @(edgeInset.right),
                               @(NSLayoutAttributeBottom) : @(edgeInset.bottom)};
    
    [self pinSubview:view superview:superview attributesAndConstants:allEdges];
}

+ (void) pinSubview:(UIView *)view
         superview:(UIView *)superview
attributesAndConstants:(NSDictionary *)attributesAndConstants {
    [superview addConstraints:[self constraintsForView:view superview:superview attributesAndConstants:attributesAndConstants]];
}

+ (void) addInstrinsticConstraintToView:(UIView *)view
                              attribute:(NSLayoutAttribute)attribute
                               constant:(CGFloat)constant {
    
    [view addConstraint:[self instrinsicConstraintForView:view attribute:attribute constant:constant]];
}

+ (NSLayoutConstraint *) pinnedConstraintForView:(UIView *)view
                                          toView:(UIView *)toView
                                       attribute:(NSLayoutAttribute)attribute
                                        constant:(CGFloat)constant {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:toView
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:constant];

}

+ (NSArray *)constraintsForView:(UIView *)view
                      superview:(UIView *)superview
         attributesAndConstants:(NSDictionary *)attributesAndConstants {
    
    NSMutableArray *constaints = [[NSMutableArray alloc] initWithCapacity:attributesAndConstants.count];
    
    for (NSNumber *attribute in attributesAndConstants) {
        NSLayoutConstraint *constraint = [self pinnedConstraintForView:view
                                                                toView:superview
                                                             attribute:attribute.integerValue
                                                              constant:[attributesAndConstants[attribute] floatValue]];
        [constaints addObject:constraint];
    }
    
    return [constaints copy];
}

+ (NSLayoutConstraint *) instrinsicConstraintForView:(UIView *)view
                                           attribute:(NSLayoutAttribute)attribute
                                            constant:(CGFloat)constant {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:0
                                       multiplier:1.0
                                         constant:constant];
}

+ (void) addPercentageConstraintWithView:(UIView *)view fromAttribute:(NSLayoutAttribute)fromAttribute toAttribute:(NSLayoutAttribute)toAttribute percentage:(CGFloat)percentage {
    
    NSLayoutConstraint *percentageContraint = [self percentageConstraintWithView:view fromAttribute:fromAttribute toAttribute:toAttribute percentage:percentage];
    [view.superview addConstraint:percentageContraint];
}

+ (NSLayoutConstraint *) percentageConstraintWithView:(UIView *)view fromAttribute:(NSLayoutAttribute)fromAttribute toAttribute:(NSLayoutAttribute)toAttribute percentage:(CGFloat)percentage {
    
    // Workaround to get pass new iOS 8 limit that makes it illegal to have a multipier of 0
    // The multiplier is so close to zero that no one would will ever notice
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        if (percentage == 0) percentage = 0.00000001;
    }
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:fromAttribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view.superview
                                        attribute:toAttribute
                                       multiplier:percentage
                                         constant:0];
}

+ (void) animateTranslationOnView:(UIView *)view
                            delta:(CGPoint)delta
                         duration:(NSTimeInterval)animationDuration
                  completionBlock:(void(^)(BOOL finished))completionBlock {
    
    [self animateTranslationOnViews:@[view] delta:delta duration:animationDuration options:UIViewAnimationOptionCurveEaseInOut completionBlock:completionBlock];
}

+ (void) animateTranslationOnViews:(NSArray *)views
                             delta:(CGPoint)delta
                          duration:(NSTimeInterval)animationDuration
                           options:(UIViewAnimationOptions)options
                   completionBlock:(void (^)(BOOL))completionBlock {
    
    NSMutableArray *transforms = [[NSMutableArray alloc] initWithCapacity:views.count];
    for (int i = 0; i < views.count; i++) {
        CATransform3D transform = [[views[i] layer] transform];
        transform = CATransform3DTranslate(transform, delta.x, delta.y, 0);
        transforms[i] = [NSValue valueWithBytes:&transform objCType:@encode(CATransform3D)];
    }
    
    [UIView animateWithDuration:animationDuration delay:0 options:options animations:^{
        for (int i = 0; i < views.count; i++) {
            UIView *view = views[i];
            CATransform3D transform;
            [transforms[i] getValue:&transform];
            
            [view.layer setTransform:transform];
        }
    } completion:completionBlock];
    
}

+ (NSArray *)constraintsForView:(UIView *)view {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if ([constraint.firstItem isEqual:view]) {
            [constraints addObject:constraint];
        }
    }
    
    return constraints.count > 0 ? [constraints copy] : nil;
}

+ (void) removeConstraintsForView:(UIView *)view {
    // This method only removes constraints from the superview and itself,
    // since that is where constraints are likely to be placed.
    // If there is another relationship, those constraints need to be removed manually
    
    NSArray *contraints = [self constraintsForView:view];
    
    if (contraints) {
        [view.superview removeConstraints:contraints];
    }

    [view removeConstraints:view.constraints];
}

+ (void) animateConstraint:(NSLayoutConstraint *)constraint
                      view:(UIView *)view
          newConstantValue:(CGFloat)newConstantValue
                  duration:(NSTimeInterval)duration
                completion:(void(^)(BOOL finished))completion {
    
    [view layoutIfNeeded];
    
    constraint.constant = newConstantValue;
    [view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration animations:^{
        [view layoutIfNeeded];
    } completion:completion];
}
@end