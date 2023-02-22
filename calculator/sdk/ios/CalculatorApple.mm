#import "CalculatorApple.h"
#include "calculator.h"

@implementation CalculatorApple

Calculator calculator;

+ (NSString *)getVersion
{
    return [NSString stringWithUTF8String:Calculator::getVersion().c_str()];
}

- (NSInteger)add:(NSInteger) a second:(NSInteger)b
{
    return (NSInteger)calculator.add(a, b);
}

- (NSInteger)sub:(NSInteger) a second:(NSInteger)b
{
    return (NSInteger)calculator.sub(a, b);
}

@end
