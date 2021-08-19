//
//  UIColor+Utils.m
//  AccessibilityIOS
//
//  Created by haleli on 2021/8/17.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)
//stackflow: https://stackoverflow.com/questions/42355778/how-to-compute-color-contrast-ratio-between-two-uicolor-instances

+(CGFloat)contrastRatio:(UIColor*)color1 between:(UIColor*)color2{
    CGFloat luminance1 = [color1 luminance];
    CGFloat luminance2 = [color2 luminance];
    
    CGFloat luminanceDarker = fmin(luminance1,luminance2);
    CGFloat luminanceLighter = fmax(luminance1, luminance2);
    return (luminanceLighter + 0.05) / (luminanceDarker + 0.05);
}

-(CGFloat)contrastRatioWithColor:(UIColor*)color{
    return [UIColor contrastRatio:self between:color];
}

-(CGFloat)luminance{
    CIColor *ciColor = [[CIColor alloc] initWithColor:self];
    return 0.2126 * [self adjust:ciColor.red] + 0.7152 *[self adjust:ciColor.green] + 0.0722 *[self adjust:ciColor.blue];
}

-(CGFloat)adjust:(CGFloat)colorComponent{
    return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4);
}

@end
