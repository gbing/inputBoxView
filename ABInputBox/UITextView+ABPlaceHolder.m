//
//  UITextView+ABPlaceHolder.m
//  ABInputBox
//
//  Created by lp on 2019/3/12.
//  Copyright © 2019 lp. All rights reserved.
//

#import "UITextView+ABPlaceHolder.h"

@implementation UITextView (ABPlaceHolder)

-(void)setPlaceHolderStyle:(UIColor *)color font:(UIFont *)font placeHolder:(NSString *)placeHolder{
    UILabel *placeHolderStr = [[UILabel alloc] init];
    placeHolderStr.text = placeHolder;
    placeHolderStr.numberOfLines = 0;
    placeHolderStr.textColor = color;
    [placeHolderStr sizeToFit];
    [self addSubview:placeHolderStr];
    self.backgroundColor = [UIColor yellowColor];
    placeHolderStr.font = font;
    [self setValue:placeHolderStr forKey:@"_placeholderLabel"];
}


@end
