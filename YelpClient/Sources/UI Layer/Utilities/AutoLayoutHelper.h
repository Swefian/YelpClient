//
//  AutoLayoutHelper.h
//

@import Foundation;
@import UIKit;
@import CoreGraphics;

@interface AutoLayoutHelper : NSObject

+ (void) pinSubview:(UIView *)view
          attribute:(NSLayoutAttribute)attribute
           constant:(CGFloat)constant;

+ (void) pinAllEdgesOfView:(UIView *)view
               toSuperview:(UIView *)superview
                 edgeInset:(UIEdgeInsets)edgeInset;

+ (void) centerView:(UIView *)view
          superview:(UIView *)superview;

+ (void) setSize:(CGSize)size view:(UIView *)view;


+ (NSLayoutConstraint *) pinnedConstraintForView:(UIView *)view
                                          toView:(UIView *)toView
                                       attribute:(NSLayoutAttribute)attribute
                                        constant:(CGFloat)constant;

+ (NSLayoutConstraint *) instrinsicConstraintForView:(UIView *)view
                                           attribute:(NSLayoutAttribute)attribute
                                            constant:(CGFloat)constant;

+ (NSLayoutConstraint *) percentageConstraintWithView:(UIView *)view
                                        fromAttribute:(NSLayoutAttribute)fromAttribute
                                          toAttribute:(NSLayoutAttribute)toAttribute
                                           percentage:(CGFloat)percentage;

+ (NSArray *)constraintsForView:(UIView *)view
                      superview:(UIView *)superview
         attributesAndConstants:(NSDictionary *)attributesAndConstants;


+ (void) addInstrinsticConstraintToView:(UIView *)view
                              attribute:(NSLayoutAttribute)attribute
                               constant:(CGFloat)constant;

+ (void) addPercentageConstraintWithView:(UIView *)view
                           fromAttribute:(NSLayoutAttribute)fromAttribute
                             toAttribute:(NSLayoutAttribute)toAttribute
                              percentage:(CGFloat)percentage;

+ (void) animateTranslationOnView:(UIView *)view
                            delta:(CGPoint)delta
                         duration:(NSTimeInterval)animationDuration
                  completionBlock:(void(^)(BOOL finished))completionBlock;

+ (void) animateTranslationOnViews:(NSArray *)views
                             delta:(CGPoint)delta
                          duration:(NSTimeInterval)animationDuration
                           options:(UIViewAnimationOptions)options
                   completionBlock:(void (^)(BOOL))completionBlock;

/**
 Hunts through the superview's constraints and pulls out all the constraints that reference this view
 */
+ (NSArray *)constraintsForView:(UIView *)view;
+ (void) removeConstraintsForView:(UIView *)view;

+ (void) animateConstraint:(NSLayoutConstraint *)constraint
                      view:(UIView *)view
          newConstantValue:(CGFloat)newConstantValue
                  duration:(NSTimeInterval)duration
                completion:(void(^)(BOOL finished))completion;

@end
