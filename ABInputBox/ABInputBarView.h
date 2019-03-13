//
//  ABInputBarView.h
//  ABInputBox
//
//  Created by lp on 2019/3/12.
//  Copyright © 2019 lp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^senBtnBlock)(void);

@interface ABInputBarView : UIView

@property(nonatomic,assign)int maxRow;//设置最大行数
@property(nonatomic,assign)CGFloat topEdge;//上间距
@property(nonatomic,strong)UIFont *font;//设置字体大小(决定输入框的初始高度)

@property(nonatomic, copy)senBtnBlock block;

- (void)beginUpdateUI:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
