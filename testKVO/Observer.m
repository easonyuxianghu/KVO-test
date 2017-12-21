//
//  Observer.m
//  testKVO
//
//  Created by Yuxhu on 12/21/17.
//  Copyright © 2017 sheng. All rights reserved.
//

#import "Observer.h"

@implementation Observer

- (void)dealloc {
    NSLog(@"%zd - %s", __LINE__, __func__);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%s, updated ---- target = %@ changed", __func__, object);
}

@end
