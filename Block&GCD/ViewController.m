//
//  ViewController.m
//  块与大中枢派发
//
//  Created by zzy on 2023/6/2.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) NSString *name;
@property(nonatomic ,strong) NSMutableArray *arrayT;
@property(nonatomic, copy) void(^block1)(void);
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark --像函数一样使用块
    int (^myBlock)(int, int) = ^int(int i, int j) {
        return i + j;
    };
    
    int a = myBlock(2,7);
    NSLog(@"%d ", a);
    NSLog(@"%d", myBlock(9, 8));
    //像函数一样使用块
    //表达式中，return 语句使用的是 count + 1 语句的返回类型。如果表达式中有多个 return 语句，则所有 return 语句的返回值类型必须一致。
//    如果表达式中没有 return 语句，则可以用 void 表示，或者也省略不写。代码如
    ^ void (int count)  { printf("%d\n", count); };    // 返回值类型使用 void
    ^ (int count) { printf("%d\n", count); };    // 省略返回值类型
#pragma mark --修改为块所捕获的变量
    NSArray *array = @[@0, @1, @2, @3, @4, @5];
    __block NSInteger count = 0;
    //块作为方法的参数
    [array enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
            if ([number compare:@2] == NSOrderedAscending) {
                count++;
            }
        NSLog(@"%ld====%@",(unsigned long)idx, number);
        NSLog(@"作为方法的参数");
    }];
    NSLog(@"%ld", (long)count);
//    [self useblockAsMethodparameter];
    [self useBlockAsProperty];
    [self NSGlobalBlock];
    [self NSStackBlock];
    [self NSMallocBlock];
    [self blockFromNSObject];
    [self diffStackAndHip];
    [self diffStackAndHip2];
    [self diffStackAndHip3];
//    [self diffStackAndHip4];
    //内联块的用法，传给“numberateObjectsUsingBlock:"方法的块并未先赋给局部变量，而是直接在内联函数中调用了，如果块所捕获的变量类型是对象类型的话，那么就会自动保留它，系统在释放这个块的时候，也会将其一并释放。这就引出了一个与块有关的重要问题，块本身可以视为对象，在其他oc对象能响应的选择子中，很多块也可以响应，最重要的是，块本身也会像其他对象一样，有引用计数，为0时，块就回收了，同时也会释放块所捕获的变量，以便平衡捕获时所执行的保留操作
    //如果块定义在oc类的实例方法中，那么除了可以访问类的所有实例变量之外，还可以使用self变量，块总能修改实例变量，那么除了声明时无需添加__block。不过，如果通过读取或写入操作捕获了实例变量，那么也会自动把self给捕获了，因为实例变量是与self所指代的实例关联在一起的。
    // 需要注意的是(self也是一个对象，也会被保留），如果在块内部使用了实例变量，块会自动对self进行保留操作，以确保在块执行期间保持对象的有效性。但是，如果在块内部直接使用了self，并对其进行读取或写入操作，那么self也会被捕获，从而导致循环引用的问题。为了避免循环引用，可以在块内部使用__weak修饰符来避免对self进行保留操作。
    
    //把block变量作为局部变量，在一定范围内使用
    

}
- (void)NSGlobalBlock {
    //block1没有引用到局部变量
    int a = 10;
    void (^block)(void) = ^{
         NSLog(@"hello world");

    };
    block();
    NSLog(@"block:%@", block);

    //    block2中引入的是静态变量
    static int a1 = 20;
    void (^block1)(void) = ^{
     
        NSLog(@"hello - %d",a1);
    };

    NSLog(@"block:%@", block);


}
- (void)NSStackBlock {
    __block int a = 10;
    static int a1 = 20;
    void (^__weak block)(void) = ^{
        NSLog(@"hello - %d",a);
        NSLog(@"hello - %d",a1);
    };
    block();
    NSLog(@"block:%@", block);

}
- (void)NSMallocBlock {
    int a = 10;
    NSMutableArray *abc = [NSMutableArray arrayWithObjects:@"1", nil];
    _arrayT = [NSMutableArray arrayWithObjects:@"4", nil];
    NSLog(@"%@",_arrayT);
    NSLog(@"%p",_arrayT);
    NSLog(@"%p",&a);
    void (^block1)(void) = ^{
        NSLog(@"%p",&a);
        NSLog(@"%@",abc);
        [abc addObject:@"2"];
        
        _arrayT = nil;
        NSLog(@"%@",_arrayT);
        NSLog(@"%p",_arrayT);
    };
    block1();
    NSLog(@"%p",&a);
    NSLog(@"%@",_arrayT);
    NSLog(@"%p",_arrayT);
    NSLog(@"block1:%@", block1);

    __block int b = 10;
    void (^block2)(void) = ^{
        NSLog(@"%d",b);
    };

    NSLog(@"block2:%@", block2);

}
//block继承与nsobject
- (void)blockFromNSObject {
    void (^block1)(void) = ^{
        NSLog(@"block1");
    };
    NSLog(@"%@",[block1 class]);
    NSLog(@"%@",[[block1 class] superclass]);
    NSLog(@"%@",[[[block1 class] superclass] superclass]);
    NSLog(@"%@",[[[[block1 class] superclass] superclass] superclass]);
    NSLog(@"%@",[[[[[block1 class] superclass] superclass] superclass] superclass]);

}
// Blocks 变量作为本地变量
- (void)useBlockAsLocalVariable {
    void (^myLocalBlock)(void) = ^{
        NSLog(@"useBlockAsLocalVariable");
    };
    myLocalBlock();
}
//作为带有 property声明的成员变量，（nonatomic， copy）返回值类型（^变量名）（参数列表）
//类似于delegate实现block回调

- (void)useBlockAsProperty {
    self.myProBlock = ^{
        NSLog(@"useBlockAsProperty");
    };
    self.myProBlock();
}
// Blocks 变量作为 OC 方法参数
- (void)someMethodThatTakesABlock:(void (^)(NSString *)) block {
    
    block(@"someMethodThatTakesABlock:");
}
//调用含有block参数的方法
- (void)useblockAsMethodparameter {
    [self someMethodThatTakesABlock:^(NSString *str) {
        NSLog(@"%@", str);
    }];
    NSLog(@"after");
}
- (void)diffStackAndHip {
    __block int a = 10;
    __block int b = 20;
    NSLog(@"a:%p---b:%p", &a, &b);
    void (^__weak block)(void) = ^{
        NSLog(@"hello - %d---%p",a, &a);
        a++;
    };
    void (^block1)(void) = ^{
        NSLog(@"hello - %d---%p",b, &b);
        b++;
    };
    block();
    block1();
    NSLog(@"block:%@---block1:%@", block, block1);
    NSLog(@"a:%d---b:%d", a, b);
    NSLog(@"a:%p---b:%p", &a, &b);


}
- (void)diffStackAndHip2 {
    NSObject *objc = [NSObject new];
    NSLog(@"%@---%ld",objc, CFGetRetainCount((__bridge CFTypeRef)(objc)));// 1
    // block 底层源码
    // 捕获 + 1
    // 堆区block
    // 栈 - 内存 -> 堆  + 1
    void(^strongBlock)(void) = ^{ // 1 - block -> objc 捕获 + 1 = 2
        NSLog(@"%@---%ld",objc, CFGetRetainCount((__bridge CFTypeRef)(objc)));
    };
    strongBlock();

    void(^__weak weakBlock)(void) = ^{ // + 1
        NSLog(@"%@---%ld",objc, CFGetRetainCount((__bridge CFTypeRef)(objc)));
    };
    weakBlock();
    
    void(^mallocBlock)(void) = [weakBlock copy];
    mallocBlock();

}
- (void)diffStackAndHip3 {
    NSObject *a = [NSObject alloc];
    NSLog(@"1---%@--%p", a, &a);
    void(^__weak weakBlock)(void) = nil;
    
    
    {
        // 栈区
        void(^__weak strongBlock)(void) = ^{
            NSLog(@"2---%@--%p", a, &a);
        };
     
        strongBlock();
        
        NSLog(@"7---%@--%p", a, &a);
        NSLog(@"9 - %@ ",strongBlock);
        weakBlock = strongBlock;
        
        NSLog(@"3 - %@ - %@",weakBlock,strongBlock);

    }
    
    weakBlock();
    NSLog(@"4---%@--%p", a, &a);

}
- (void)diffStackAndHip4 {
    NSObject *a = [NSObject alloc];
    NSLog(@"1---%@--%p", a, &a);
    void(^__weak weakBlock)(void) = nil;
    {
        // 栈区
        void(^__strong strongBlock)(void) = ^{
            NSLog(@"2---%@--%p", a, &a);
        };
        weakBlock = strongBlock;
        strongBlock();
        NSLog(@"3 - %@ - %@",weakBlock,strongBlock);
    }
//  weakBlock();//测试的时候取消注释
    NSLog(@"4---%@--%p", a, &a);

}
- (void)loopUse {
    self.name = @"fix";
    self.block1 = ^{
        NSLog(@"%@", self.name);
    };
}

- (void)loopUseAns1 {
    __weak typeof(self) weakSelf = self;
    self.name = @"Felix";
    self.block1 = ^{
        NSLog(@"%@", weakSelf.name);
    };
}
- (void)loopUseAns2 {
    __weak typeof(self) weakSelf = self;
    self.name = @"Felix";
    self.block1 = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//延迟操作比如dissmiss页面，self的weak会在界面消失的时候释放
            NSLog(@"%@", weakSelf.name);
        });
    };
}
- (void)loopUseAns3 {
    __weak typeof(self) weakSelf = self;
    self.name = @"Felix";
    self.block1 = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", strongSelf.name);
        });
    };
}

//block变量的循环引用，以及如何避免
//从上文中我们知道 Block 会对引用的局部变量进行持有。同样，如果 Block 也会对引用的对象进行持有，从而会导致相互持有，引起循环引用。
//person *person = [[person alloc] init];
//person.blk = ^{
//NSLog(@"%@", person);
//
//}
//在ARC下，通过__weak修饰符来消除循环引用
/*
 在 ARC 下，可声明附有 __weak 修饰符的变量，并将对象赋值使用。
 int main() {
     Person *person = [[Person alloc] init];
     __weak typeof(person) weakPerson = person;
     person.blk = ^{
         NSLog(@"%@",weakPerson);
     };
     return 0;
 }
 这样，通过 __weak，person 持有成员变量 myBlock blk，而 blk 对 person 进行弱引用，从而就消除了循环引用。
 MRC 下，是不支持 weak 修饰符的。但是我们可以通过 block 来消除循环引用。
 int main() {
     Person *person = [[Person alloc] init];
     __block typeof(person) blockPerson = person;
     person.blk = ^{
         NSLog(@"%@", blockPerson);
     };
     return 0;
 }
 通过 __block 引用的 blockPerson，是通过指针的方式来访问 person，而没有对 person 进行强引用，所以不会造成循环引用。

 */
@end
