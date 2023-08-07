#import <Foundation/Foundation.h>
#define APPLE_EXPORT __attribute__((visibility("default")))

APPLE_EXPORT @interface CalculatorApple : NSObject

+ (NSString *)getVersion;
- (NSInteger)add:(NSInteger) a second: (NSInteger) b;
- (NSInteger)sub:(NSInteger) a second: (NSInteger) b;

@end
