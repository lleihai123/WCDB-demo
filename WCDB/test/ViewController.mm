//
//  ViewController.m
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2017/11/8.
//  Copyright © 2017年 每日瑜伽雷海. All rights reserved.
//

#import "ViewController.h"
#import "YGHotSession.h"
#import "YGColdSession.h"
#import "NSObject+YG.h"
#import "YGHotSession+BLogic.h"
@interface ViewController ()
{
    UIButton    *removeBtn;
    UIButton    *queryBtn;
    UIButton    *addDataBtn;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor   = [UIColor grayColor];
    removeBtn   = [self normalBtn:CGPointMake(100, 200) title:@"清空数据" tag:11];
    queryBtn    = [self normalBtn:CGPointMake(100, 300) title:@"查询数据" tag:12];
    addDataBtn  = [self normalBtn:CGPointMake(100, 400) title:@"插入数据" tag:13];
    [self.view addSubview:removeBtn];
    [self.view addSubview:queryBtn];
    [self.view addSubview:addDataBtn];
}

- (void)deleteTable{
    [YGHotSession truncateTable];
    [[YGHotSession sharedManager] resetYGCache];
    [YGColdSession truncateTable];
    [[YGColdSession sharedManager] resetYGCache];
    NSLog(@"清空数据 操作完成");
}


- (void)queryTable{
    NSArray*array = [YGHotSession allSession];
    for (YGHotSession*hotSession in array) {
        NSLog(@"(hot:%@ **** cold:%@)",hotSession,hotSession.coldSession);
    }
    NSLog(@"查询数据 操作完成");
}


-(void)addData{
    for (NSInteger i = 1; i <= 5; i++) {
        [YGHotSession return:^(YGHotSession* value) {
            [value updateByDict:@{@"sessionId":@(i),
                                  @"lang":[NSString stringWithFormat:@"lang_%ld",(long)i],
                                  @"package":[NSString stringWithFormat:@"package_%ld",(long)i],
                                  }];
            [value.coldSession updateByDict:@{@"objDesc":[NSString stringWithFormat:@"objDesc_%@",value.lang],
                                              @"currentLevel":@(i%5)
                                              }];
            [value saveSelf];
            [value.coldSession saveSelf];
        }];
    }
    NSLog(@"插入数据 操作完成");
}

#pragma mark ====================

- (UIButton *)normalBtn:(CGPoint)point title:(NSString *)title tag:(NSInteger)tag
{
    UIButton    *button     = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 100, 30)];
    button.backgroundColor  = [UIColor colorWithRed:arc4random() % 255 green:arc4random() % 255 blue:arc4random() %255 alpha:1];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.tag              = tag;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 11:
            [self deleteTable];
            break;
        case 12:
            [self queryTable];
            break;
        case 13:
            [self addData];
            break;
        default:
            break;
    }
}
@end
