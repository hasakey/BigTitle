//
//  NSString+extend.m
//  BigTitle
//
//  Created by 丁巍巍 on 2019/1/30.
//  Copyright © 2019年 丁巍巍. All rights reserved.
//

#import "NSString+extend.h"

@implementation NSString (extend)

-(CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect frame = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
    
    return frame.size;
}

@end
