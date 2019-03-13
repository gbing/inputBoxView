//
//  UITextView+ABPlaceHolder.h
//  ABInputBox
//
//  Created by lp on 2019/3/12.
//  Copyright © 2019 lp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ABPlaceHolder)

-(void)setPlaceHolderStyle:(UIColor *)color font:(UIFont *)font placeHolder:(NSString *)placeHolder;


@end

NS_ASSUME_NONNULL_END
