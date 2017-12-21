#import "KeyValueObserver.h"

#import <objc/message.h>

#import "RuntimeHelpers.h"

@interface KeyValueObserver : NSObject

@property (nonatomic, getter=isObserving) BOOL observing;
@property (nonatomic, readonly, weak) id object;
@property (nonatomic, readonly, weak) id observer;
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly, copy) NSString *keyPath;
@property (nonatomic, readonly) NSKeyValueObservingOptions options;
@property (nonatomic, readonly) void *context;
@property (nonatomic, readonly) NSString *identifier;

@end

@implementation KeyValueObserver {
    __unsafe_unretained id _originalObject;
}

- (instancetype)initWithObject:(id)object observer:(id)observer selector:(SEL)selector keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    self = [super init];
    if (self != nil) {
        _originalObject = object;
        _object = object;
        _observer = observer;
        _selector = selector;
        _keyPath = [keyPath copy];
        _options = options;
        _context = context;
        _identifier = [[self class] identifierForObject:object observer:observer selector:selector keyPath:keyPath context:context];
    }
    
    return self;
}

- (void)dealloc {
    [self stopObserving];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; isObserving = %@; object = %p; observer = %p; selector = %@; keyPath = %@; options = %lu; context = %p; identifier = %@>",
            NSStringFromClass([self class]),
            self,
            NSStringFromBool(self.isObserving),
            self.object,
            self.observer,
            NSStringFromSelector(self.selector),
            self.keyPath,
            (unsigned long)self.options,
            self.context,
            self.identifier];
}

- (void)startObserving {
    if (!self.isObserving && (self.object != nil) && (self.observer != nil)) {
        [self.object addObserver:self forKeyPath:self.keyPath options:self.options context:self.context];
        self.observing = YES;
    }
}

- (void)stopObserving {
    if (self.isObserving) {
        // The weak object might be zeroed by the time your code's dealloc is invoked.
        // It is your code's responsibility to retain the object and to call one of the -remove methods below before your dealloc is complete.
        [_originalObject removeObserver:self forKeyPath:self.keyPath context:self.context];
        self.observing = NO;
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([self.observer respondsToSelector:self.selector]) {
        ((void(*)(id, SEL, NSString *, id, NSDictionary *, void *))objc_msgSend)(self.observer, self.selector, keyPath, object, change, context);
    }
}

#pragma mark - Private methods

+ (NSString *)identifierForObject:(id)object observer:(id)observer selector:(SEL)selector keyPath:(NSString *)keyPath context:(void *)context {
    return [NSString stringWithFormat:@"<%@: object = %p; observer = %p; selector = %@; keyPath = %@; context = %p>",
            NSStringFromClass(self),
            object,
            observer,
            NSStringFromSelector(selector),
            keyPath,
            context];
}

@end

@implementation NSObject (KeyValueObserver)

- (NSString *)addKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    KeyValueObserver *keyValueObserver = [[KeyValueObserver alloc] initWithObject:object observer:self selector:selector keyPath:keyPath options:options context:context];
    [keyValueObserver startObserving];
    
    NSString *identifier = keyValueObserver.identifier;
    [[self keyValueObserverRegistry] setObject:keyValueObserver forKey:identifier];
    return identifier;
}

- (NSString *)addKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    return [self addKeyValueObserverWithSelector:selector forObject:object keyPath:keyPath options:options context:NULL];
}

- (NSString *)addKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath {
    return [self addKeyValueObserverWithSelector:selector forObject:object keyPath:keyPath options:0 context:NULL];
}

- (void)removeKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath context:(void *)context {
    [[self keyValueObserverRegistry] removeObjectForKey:[KeyValueObserver identifierForObject:object observer:self selector:selector keyPath:keyPath context:context]];
}

- (void)removeKeyValueObserverWithSelector:(SEL)selector forObject:(id)object keyPath:(NSString *)keyPath {
    [self removeKeyValueObserverWithSelector:selector forObject:object keyPath:keyPath context:NULL];
}

- (void)removeAllKeyValueObservers {
    [[self keyValueObserverRegistry] removeAllObjects];
}

- (void)startKeyValueObserversForIdentifiers:(id<NSFastEnumeration>)identifiers {
    for (NSString *identifier in identifiers) {
        [[[self keyValueObserverRegistry] objectForKey:identifier] startObserving];
    }
}

- (void)stopKeyValueObserversForIdentifiers:(id<NSFastEnumeration>)identifiers {
    for (NSString *identifier in identifiers) {
        [[[self keyValueObserverRegistry] objectForKey:identifier] stopObserving];
    }
}

#pragma mark - Private methods

- (NSMutableDictionary *)keyValueObserverRegistry {
    NSMutableDictionary *keyValueObserverRegistry = objc_getAssociatedObject(self, _cmd);
    if (keyValueObserverRegistry == nil) {
        keyValueObserverRegistry = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, _cmd, keyValueObserverRegistry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return keyValueObserverRegistry;
}

@end
