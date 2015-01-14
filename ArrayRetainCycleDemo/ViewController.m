//
//  ViewController.m
//  ArrayRetainCycleDemo
//
//  Created by Parsifal on 15/1/13.
//  Copyright (c) 2015年 Parsifal. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@implementation MyObjcet

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *mulArray;
@property (strong, nonatomic) MyObjcet *obj;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapButton:(UIButton *)sender
{
    //1、第一种写法，MyObject和NSMutableArray两个都是局部变量，在本方法执行完之后，会被release一次，但由于obj与mutArray之间存在retain cycle，因而此处存在leaks。这种情况下，可用Instruments-Leaks查到
//    MyObjcet *obj = [MyObjcet new];
//
//    NSMutableArray *mutArray = [NSMutableArray array];
//    [mutArray addObject:obj];
//    obj.array = mutArray;//此处retain cycle
    
    //2、第二种写法，与第一种写法类似，不同的是将obj与mulArray变成当前controller的property（strong）了，也就是意味着这些属性要到controller销毁的时候才会被释放。按理来说在controller释放之前这些内存不应该归为leaks(释放之后就是leaks了)，但事实是Instruments-Leaks也查到了。分析原因是做mulArray和obj初始化的时候每次都会alloc一个新的对象，也就意味着上一个对象会被release一次，但又由于存在retain cycle无法正常释放，此处就形成了leaks。而leaks是可以被Instruments-Leaks查到的。
//    _obj = [MyObjcet new];
//    _mulArray = [NSMutableArray array];//第一个问题在这儿
//    
//    [self.mulArray addObject:self.obj];
//    self.obj.array = self.mulArray;//第二个问题同样的retain cycle
    
    //3、第三种写法，在第二种基础上优化了下，只创建一个mulArray和obj对象。这种写法造成的问题也很严重。obj不断的被添加到mulArray中，也就是一直被retain。controller释放之后，就变成leaks了。在本controller中（rootViewController）是不能被Leaks查到的，若要观察可到SecondViewController中观察。
    [self.mulArray addObject:self.obj];
    self.obj.array = self.mulArray;//同样的retain cycle
    
    //以上问题的本质是在于retain cycle，也就是“obj.array = self.mulArray;”这句话。解决方法是讲MyObject的array属性改用weak。当然，我们编程之中应该尽量避免这种数据结构出现。
    
}
- (IBAction)gotoNext:(UIButton *)sender
{
    SecondViewController *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    [self presentViewController:secondVC animated:NO completion:nil];
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

@end
