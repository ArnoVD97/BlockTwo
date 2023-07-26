////
////  BlockOfCPP.m
////  Block&GCD
////
////  Created by zzy on 2023/7/25.用来重写来查看底层代码
////
//
//#import <Foundation/Foundation.h>
//
//int main(){
//    
//    int a = 10;
//    NSMutableArray *abc = [NSMutableArray arrayWithObjects:@"1", nil];
//    NSLog(@"%@",abc);
//    NSLog(@"%p",abc);
//    NSLog(@"%p",&a);
//    void (^block1)(void) = ^{
//        NSLog(@"%p",&a);
//        [abc addObject:@"2"];
//        NSLog(@"%@",abc);
//        NSLog(@"%p",abc);
//    };
//    block1();
//    NSLog(@"%p",&a);
//    NSLog(@"%@",abc);
//    NSLog(@"%p",abc);
//    NSLog(@"block1:%@", block1);
//}
