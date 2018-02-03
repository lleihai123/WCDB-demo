//
//  ViewController.m
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2017/11/8.
//  Copyright © 2017年 每日瑜伽雷海. All rights reserved.
//

#import "ViewController.h"
#import "TableManager.h"
#import "User.h"
#import "YGUser.h"
@interface ViewController ()

{
    UIButton    *createBtn;
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
    
    createBtn   = [self normalBtn:CGPointMake(100, 100) title:@"删除表" tag:10];
    removeBtn   = [self normalBtn:CGPointMake(100, 200) title:@"清空数据" tag:11];
    queryBtn    = [self normalBtn:CGPointMake(100, 300) title:@"查询数据" tag:12];
    addDataBtn  = [self normalBtn:CGPointMake(100, 400) title:@"插入数据" tag:13];

    [self.view addSubview:createBtn];
    [self.view addSubview:removeBtn];
    [self.view addSubview:queryBtn];
    [self.view addSubview:addDataBtn];
}

- (void)deleteTable:(NSString *)tableName
{
    [[TableManager defalutManager] deleteTable:tableName];
}


- (void)queryTable
{

    NSLog(@"------------YGUSER--------------");
    [YGUser queryAllData:^(NSArray *selectResults) {
        for (int i = 0; i < selectResults.count; i++) {
            NSLog(@"name == %@",((YGUser *)selectResults[i]).name);
            NSLog(@"hostID == %@",((YGUser *)selectResults[i]).hostID);
        }
    }];
    NSLog(@"------------User--------------");
    [User queryAllData:^(NSArray *msgArr) {
        for (int i = 0; i < msgArr.count; i++) {
            NSLog(@"hostID == %@",((User *)msgArr[i]).hostID);
            NSLog(@"userid == %ld",(long)((User *)msgArr[i]).userid);
            NSLog(@"localID == %ld",(long)((User *)msgArr[i]).localID);
            NSLog(@"name == %@",((User *)msgArr[i]).name);
            NSLog(@"content == %@",((User *)msgArr[i]).content);
            NSLog(@"tmpname == %@",((User *)msgArr[i]).tmpname);
        }
    }];

}


-(void)addData{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 1; i <= 3; i++) {
        User    *user   = [[User alloc] init];
        user.userid = i;
        user.localID = i;
        user.content    = [NSString stringWithFormat:@"%f",CFAbsoluteTimeGetCurrent()];
        user.name       = [NSString stringWithFormat:@"%d",2222];
        user.tmpname = [user.name stringByAppendingString:@"ddd"];
        user.hostID = [NSString stringWithFormat:@"sss_%ld",(long)i];
        [user saveSelf];
        YGUser    *yguser   = [[YGUser alloc] init];
        yguser.name       = [NSString stringWithFormat:@"%d",2222];
        yguser.hostID = [NSString stringWithFormat:@"yg_sss_%ld",(long)i];
        [yguser saveSelf];

    }
    NSLog(@"HY: Function Run Time: %f", CFAbsoluteTimeGetCurrent() - start);
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
        case 10:
            [User truncateTable];
            [YGUser truncateTable];
            break;
        case 11:
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [YGUser new];
}
@end
