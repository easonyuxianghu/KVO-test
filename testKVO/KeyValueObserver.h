#import <Foundation/Foundation.h>

/**
 The KeyValueObserver class manages the lifecycle of a single KVO observation.
 This helps mitigate issues with dangling pointers and avoids duplicate observation.
 NOTE: Observers are not automatically removed.
 At the very least, your -dealloc should call -removeAllKeyValueObservers.
 The return value from the -add methods is a string identifier which can be used with -start/stop.
 
 When calling -add, the selector should have the signature:
 - (void)blah:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
 You may use the NSKeyValueObserving method on NSObject:
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
 However, you must also then compare the context to make sure it is your observation.
 The KeyValueObserver API allows you to set up individual or grouped handlers like NSNotificationCenter.
 */
@interface NSObject (KeyValueObserver)

- (NSString *)addKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (NSString *)addKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options;
- (NSString *)addKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath;
- (void)removeKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath context:(void *)context;
- (void)removeKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath;
- (void)removeAllKeyValueObservers;

- (void)startKeyValueObserversForIdentifiers:(id<NSFastEnumeration>)identifiers;
- (void)stopKeyValueObserversForIdentifiers:(id<NSFastEnumeration>)identifiers;

@end
