//
//  UIImage+border.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/31.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (border)

+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

@end
