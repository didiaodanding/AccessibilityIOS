//
//  UIView+Tree.h


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIView (Tree)
+(NSMutableDictionary *)tree ;
- (CGPoint)tappablePointInRect:(CGRect)rect ;
@end

NS_ASSUME_NONNULL_END
