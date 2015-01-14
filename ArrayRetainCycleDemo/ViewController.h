//
//  ViewController.h
//  ArrayRetainCycleDemo
//
//  Created by Parsifal on 15/1/13.
//  Copyright (c) 2015年 Parsifal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyObjcet : NSObject
//错误的写法
@property (strong, nonatomic) NSArray *array;

//正确的写法
//@property (weak, nonatomic) NSArray *array;

@end



@interface ViewController : UIViewController


@end

