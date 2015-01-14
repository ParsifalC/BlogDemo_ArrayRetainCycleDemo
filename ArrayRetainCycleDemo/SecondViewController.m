//
//  SecondViewController.m
//  ArrayRetainCycleDemo
//
//  Created by Parsifal on 15/1/13.
//  Copyright (c) 2015年 Parsifal. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) NSMutableArray *mulArray;
@property (strong, nonatomic) MyObjcet *obj;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapButton:(UIButton *)sender
{
    //3、第三种写法，在第二种基础上优化了下，只创建一个mulArray和obj对象。
    [self.mulArray addObject:self.obj];
    self.obj.array = self.mulArray;//同样的retain cycle
}

- (IBAction)back:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSMutableArray *)mulArray
{
    if (!_mulArray) {
        _mulArray = [NSMutableArray array];
    }
    
    return _mulArray;
}

- (MyObjcet *)obj
{
    if (!_obj) {
        _obj = [MyObjcet new];
    }
    
    return _obj;
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
