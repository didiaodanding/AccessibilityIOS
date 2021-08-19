//
//  UIColor+Utils.h
//  AccessibilityIOS
//
//  Created by haleli on 2021/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utils)
+(CGFloat)contrastRatio:(UIColor*)color1 between:(UIColor*)color2;
-(CGFloat)contrastRatioWithColor:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
