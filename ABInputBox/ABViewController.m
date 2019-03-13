//
//  ABViewController.m
//  ABInputBox
//
//  Created by lp on 2019/3/12.
//  Copyright © 2019 lp. All rights reserved.
//

#import "ABViewController.h"
#import "ABInputBarView.h"
@interface ABViewController ()<UITextViewDelegate>
@property(nonatomic, strong) ABInputBarView *barView;
@end

@implementation ABViewController

-(ABInputBarView *)barView{
    if (!_barView) {
        _barView =[[ABInputBarView alloc]initWithFrame:CGRectZero];
        _barView.backgroundColor =[UIColor grayColor];
        _barView.maxRow = 3;
        _barView.topEdge = 10;
        _barView.font = [UIFont systemFontOfSize:14];
        CGRect frame = CGRectMake(20, 10, 300, 30);
        [_barView beginUpdateUI:frame];
    }
    return _barView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"限制行数输入框";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.barView];
    self.barView.block = ^{
        NSLog(@"发送");
    };
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
