//
//  ABInputBarView.m
//  ABInputBox
//
//  Created by lp on 2019/3/12.
//  Copyright © 2019 lp. All rights reserved.
//

#import "ABInputBarView.h"
#import "UITextView+ABPlaceHolder.h"
#import "UIView+AB.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define  Font(f) [UIFont systemFontOfSize:(f)]

@interface ABInputBarView ()<UITextViewDelegate>
{
    CGFloat textViewHeight;
}
@property (nonatomic, assign) CGFloat keyBoardEndY;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong)   UIView *textViewBg;

@end

@implementation ABInputBarView

#pragma mark ---textViewBg
- (UIView *)textViewBg{
    if (!_textViewBg) {
        _textViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textViewBg.layer.cornerRadius = 5;
        _textViewBg.backgroundColor = [UIColor blackColor];
    }
    return _textViewBg;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _sendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _sendBtn.backgroundColor = [UIColor blackColor];
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn.titleLabel setTextColor:[UIColor grayColor]];
    }
    return _sendBtn;
}

#pragma mark---textView
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = self.font;
        _textView.textColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.bounces = NO;
        _textView.textContainerInset = UIEdgeInsetsZero; //关闭textview的默认间距属性
        _textView.textContainer.lineFragmentPadding = 0;
        [_textView setPlaceHolderStyle:[UIColor grayColor] font:[UIFont systemFontOfSize:14] placeHolder:@" 发表评论:"];
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

#pragma mark---setter
-(void)setTopEdge:(CGFloat)topEdge{
    _topEdge  = topEdge;
    if (!_topEdge) {
        topEdge = 10;
    }
}
-(void)setMaxRow:(int)maxRow{
    _maxRow = maxRow;
    if (!_maxRow || _maxRow <=0) {
        _maxRow = 3;
    }
}
-(void)setFont:(UIFont *)font{
    _font = font;
    if (!font) {
        _font = Font(16);
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置默认属性
        self.topEdge = 8;
        self.font = Font(18);
        self.maxRow = 3;
        //监听键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark ----键盘位置  根据键盘状态，调整self的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
        NSDictionary *userInfo = [notification userInfo];
        NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
        self.keyBoardEndY = keyBoardEndY;
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            self.center = CGPointMake(self.center.x, keyBoardEndY - self.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        }];
    
    //右边控件的添加、移除
//    if ([[notification name] isEqualToString:@"UIKeyboardWillShowNotification"]) {
//        [self addSubview:self.sendBtn];
//    }
//    if ([[notification name] isEqualToString:@"UIKeyboardWillHideNotification"] && !self.textView.text.length) {
//        [self.sendBtn removeFromSuperview];
//    }
}

#pragma mark --- textView代理方法
- (void)textViewDidChange:(UITextView *)textView{
    CGFloat contentSizeH = self.textView.contentSize.height;
    CGFloat lineH = self.textView.font.lineHeight;
    CGFloat maxHeight = ceil(lineH * self.maxRow + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxHeight) {
        self.textView.height = contentSizeH;
    }else{
        self.textView.height = maxHeight;
    }
    
    //    用scrollRangeToVisible函数进行滚动，可以跳动到最后一行内容上
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
    
    //    这句代码设置了 UITextView 中的 layoutManager(NSLayoutManager) 的是否非连续布局属性，
    //    默认是 YES，设置为 NO 后 UITextView 就不会再自己重置滑动了
    //    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    
    CGFloat totalH = ceil(self.textView.height) + textViewHeight + 2 * self.topEdge;
    self.frame = CGRectMake(0, self.keyBoardEndY - totalH, self.width, totalH);
    self.textViewBg.height = self.height - 2 * self.topEdge;
    self.sendBtn.height = totalH;
}

#pragma mark ---设置textView、inputBarView、textViewBg的frame
-(void)beginUpdateUI:(CGRect)frame{
    self.textViewBg.frame = frame;
    [self addSubview:self.textViewBg];
    
    //通过topEdge和textView的frame设置BarView的frame
    self.frame = CGRectMake(0, SCREEN_HEIGHT - frame.size.height - 2*self.topEdge, SCREEN_WIDTH, frame.size.height + 2*self.topEdge);
    
    //设置textView的frame
    self.textView.frame = CGRectMake(5, (frame.size.height -ceil(self.textView.font.lineHeight))/2., self.textViewBg.width -5, ceil(self.textView.font.lineHeight));
    //设置sendBtn的frame
    self.sendBtn.frame = CGRectMake(CGRectGetMaxX(self.textViewBg.frame) +20, 0, SCREEN_WIDTH -40 -self.textViewBg.width, self.height);
    [self addSubview:self.sendBtn];
    
    textViewHeight = frame.size.height -ceil(self.textView.font.lineHeight);
    [self.textViewBg addSubview:self.textView];
}

- (void)sendBtnAction{
    if (self.block) {
        self.block(self.textView.text);
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
