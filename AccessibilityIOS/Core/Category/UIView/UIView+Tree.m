//
//  UIView+Tree.m


#import "UIView+Tree.h"
#import "UIColor+Utils.h"

CG_INLINE CGPoint CGPointCenteredInRect(CGRect bounds) {
    return CGPointMake(bounds.origin.x + bounds.size.width * 0.5f, bounds.origin.y + bounds.size.height * 0.5f);
}

@implementation UIView (Tree)

+(NSMutableDictionary *)tree{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray* windows = [UIApplication sharedApplication].windows;
    if(windows.count == 1) {
        [windows[0] subviews:dict];
    } else {
        for (UIWindow* window in windows) {
            [window subviews:dict];
        }
    }
    return dict ;
}


-(BOOL) isViewDisplayedInScreen{
    
    if(self.superview == nil){
        return false ;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds ;
    
    CGRect rect = [self.superview convertRect:self.frame toView:nil ] ;
    
    if(CGRectIsEmpty(rect) || CGRectIsNull(rect)){
        return false ;
    }
    
    if(CGSizeEqualToSize(rect.size, CGSizeZero)){
        return false ;
    }
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect) ;
    if(CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)){
        return false ;
    }
    
    return true ;
}

- (BOOL)isProbablyTappable
{
    // There are some issues with the tappability check in UIWebViews, so if the view is a UIWebView we will just skip the check.
    return [NSStringFromClass([self class]) isEqualToString:@"UIWebBrowserView"] || self.isTappable;
}

// Is this view currently on screen?
- (BOOL)isTappable;
{
    return ([self hasTapGestureRecognizer] ||
            [self isTappableInRect:self.bounds]);
}

- (BOOL)hasTapGestureRecognizer
{
    __block BOOL hasTapGestureRecognizer = NO;
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj,
                                                          NSUInteger idx,
                                                          BOOL *stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            hasTapGestureRecognizer = YES;
            
            if (stop != NULL) {
                *stop = YES;
            }
        }
    }];
    
    return hasTapGestureRecognizer;
}

- (BOOL)isTappableWithHitTestResultView:(UIView *)hitView;
{
    // Special case for UIControls, which may have subviews which don't respond to -hitTest:,
    // but which are tappable. In this case the hit view will be the containing
    // UIControl, and it will forward the tap to the appropriate subview.
    // This applies with UISegmentedControl which contains UISegment views (a private UIView
    // representing a single segment).
    if ([hitView isKindOfClass:[UIControl class]] && [self isDescendantOfView:hitView]) {
        return YES;
    }
    
    // Button views in the nav bar (a private class derived from UINavigationItemView), do not return
    // themselves in a -hitTest:. Instead they return the nav bar.
    if ([hitView isKindOfClass:[UINavigationBar class]] && [self isNavigationItemView] && [self isDescendantOfView:hitView]) {
        return YES;
    }
    
    return [hitView isDescendantOfView:self] || [self isDescendantOfView:hitView] ;
}

- (BOOL)isNavigationItemView;
{
    return [self isKindOfClass:NSClassFromString(@"UINavigationItemView")] || [self isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")];
}

- (BOOL)isTappableInRect:(CGRect)rect;
{
    CGPoint tappablePoint = [self tappablePointInRect:rect];
    
    return !isnan(tappablePoint.x);
}

- (CGPoint)tappablePointInRect:(CGRect)rect;
{
    // Start at the top and recurse down
    CGRect frame = [self.window convertRect:rect fromView:self];
    
    UIView *hitView = nil;
    CGPoint tapPoint = CGPointZero;
    
    // Mid point
    tapPoint = CGPointCenteredInRect(frame);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Top left
    tapPoint = CGPointMake(frame.origin.x + 1.0f, frame.origin.y + 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Top right
    tapPoint = CGPointMake(frame.origin.x + frame.size.width - 1.0f, frame.origin.y + 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Bottom left
    tapPoint = CGPointMake(frame.origin.x + 1.0f, frame.origin.y + frame.size.height - 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Bottom right
    tapPoint = CGPointMake(frame.origin.x + frame.size.width - 1.0f, frame.origin.y + frame.size.height - 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    return CGPointMake(NAN, NAN);
}


- (void)subviews:(NSMutableDictionary *)dict
{
    
    if([NSStringFromClass([self class]) isEqual:@"UIRemoteKeyboardWindow"]){
        return ;
    }
    
    if(self.hidden){
        return ;
    }
    if([NSStringFromClass([self class]) isEqual:@"UITableViewLabel"]){
        NSLog(@"aaaa");
    }
    if([self isViewDisplayedInScreen] &&[self isProbablyTappable] ){
        if([self isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel*)self;
            NSString* text = [label text];
            UIFont *font = [label font];
            __block CGFloat lineSpacing = -1;
            __block CGFloat paragraphSpacing = -1;
            NSAttributedString *attributedString = [label attributedText] ;
            [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attributedString.length)  options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if(value){
                    *stop = YES;
                    NSMutableParagraphStyle *paragraphStyle = (NSMutableParagraphStyle*)value;
                    lineSpacing = paragraphStyle.lineSpacing;
                    paragraphSpacing = paragraphStyle.paragraphSpacing;
                }
            }];
            
            BOOL assertFlag = true;
            
            //label不为空
            if(assertFlag && (text == nil || [text isEqual:@""])){
                assertFlag = false;
            }
            
            //label中不含英文单词、数字、符号的任意两种混合
            int mixcount = 0;
            if(assertFlag && [self isStringContainNumberWith:text]){
                mixcount = mixcount + 1;
            }
            if(assertFlag && [self isStringContainCharacterWith:text]){
                mixcount = mixcount + 1;
            }
            if(assertFlag && [self isStringContainSymbolWith:text]){
                mixcount = mixcount + 1;
            }
            if(mixcount >=2){
                assertFlag = false;
            }
            
            //字号小于18
            if([font pointSize] <18){
                assertFlag = false;
            }
            
            //行间距至少为1.3倍
            if(assertFlag && lineSpacing > 0 && lineSpacing < (1.3 * [font pointSize])){
                assertFlag = false;
            }
            
            if(assertFlag && paragraphSpacing > 0 && paragraphSpacing < (1.3 * 1.3 * [font pointSize])){
                assertFlag = false;
            }
            
            CGFloat contrasRatio = [UIColor contrastRatio:[label textColor] between:[label backgroundColor]];
            
//            //字号小于18 并且 颜色对比度小于4.5
//            if(assertFlag && [font pointSize] <= 18 && contrasRatio < 4.5){
//                assertFlag = false;
//            }
//            //字号大于18 并且 颜色对比度小于3
//            if(assertFlag && [font pointSize] > 18 && contrasRatio < 3){
//                assertFlag = false;
//            }
            
            if(!assertFlag){
                self.layer.borderWidth = 1.f;
                self.layer.borderColor = [UIColor redColor].CGColor;
            }
            
        }
    }
    for (UIView *view in self.subviews) {
        [view subviews:dict];
    }
}


#pragma mark - 判断字符串是否包含数字
- (BOOL)isStringContainNumberWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[0-9]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 判断字符串是否包含字母
- (BOOL)isStringContainCharacterWith:(NSString *)str {

    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 判断字符串是否包含特殊符号
- (BOOL)isStringContainSymbolWith:(NSString *)str {

    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[~!@#$%^&*()_+-/\<>,.\\[\\]]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}
@end
