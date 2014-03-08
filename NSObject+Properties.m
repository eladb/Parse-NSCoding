//
//  NSObject+Properties.m
//  UpdateZen
//
//  Created by Martin Rybak on 3/7/14.
//  Adapted from https://github.com/greenisus/NSObject-NSCoding
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

#pragma mark - Public

- (NSDictionary *)properties {
    return [self propertiesForClass:[self class]];
}

- (NSDictionary *)dynamicProperties {
	NSMutableDictionary* output = [[NSMutableDictionary alloc] init];
	NSDictionary* properties = [self properties];
	for (NSString* key in properties) {
		NSArray* attributes = properties[key][@"attributes"];
		if ([attributes containsObject:@"D"]) {
			output[key] = properties[key];
		}
	}
    return output;
	
}

- (NSDictionary *)nonDynamicProperties {
	NSMutableDictionary* output = [[NSMutableDictionary alloc] init];
	NSDictionary* properties = [self properties];
	for (NSString* key in properties) {
		NSArray* attributes = properties[key][@"attributes"];
		if (![attributes containsObject:@"D"]) {
			output[key] = properties[key];
		}
	}
    return output;
}

- (void)encodeProperties:(NSDictionary*)properties withCoder:(NSCoder *)coder {
    for (NSString *key in properties) {
        NSString *type = [properties objectForKey:key][@"type"];
        id value;
        unsigned long long ullValue;
        BOOL boolValue;
        float floatValue;
        double doubleValue;
        NSInteger intValue;
        unsigned long ulValue;
		long longValue;
		unsigned unsignedValue;
		short shortValue;
        NSString *className;
		
        NSMethodSignature *signature = [self methodSignatureForSelector:NSSelectorFromString(key)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:NSSelectorFromString(key)];
        [invocation setTarget:self];
        
        switch ([type characterAtIndex:0]) {
            case '@':   // object
                if ([[type componentsSeparatedByString:@"\""] count] > 1) {
                    className = [[type componentsSeparatedByString:@"\""] objectAtIndex:1];
                    Class class = NSClassFromString(className);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    value = [self performSelector:NSSelectorFromString(key)];
#pragma clang diagnostic pop
					
                    // only decode if the property conforms to NSCoding
                    if([class conformsToProtocol:@protocol(NSCoding)]){
                        [coder encodeObject:value forKey:key];
                    }
                }
                break;
            case 'c':   // bool
                [invocation invoke];
                [invocation getReturnValue:&boolValue];
                [coder encodeObject:[NSNumber numberWithBool:boolValue] forKey:key];
                break;
            case 'f':   // float
                [invocation invoke];
                [invocation getReturnValue:&floatValue];
                [coder encodeObject:[NSNumber numberWithFloat:floatValue] forKey:key];
                break;
            case 'd':   // double
                [invocation invoke];
                [invocation getReturnValue:&doubleValue];
                [coder encodeObject:[NSNumber numberWithDouble:doubleValue] forKey:key];
                break;
            case 'i':   // int
                [invocation invoke];
                [invocation getReturnValue:&intValue];
                [coder encodeObject:[NSNumber numberWithInt:intValue] forKey:key];
                break;
            case 'L':   // unsigned long
                [invocation invoke];
                [invocation getReturnValue:&ulValue];
                [coder encodeObject:[NSNumber numberWithUnsignedLong:ulValue] forKey:key];
                break;
            case 'Q':   // unsigned long long
                [invocation invoke];
                [invocation getReturnValue:&ullValue];
                [coder encodeObject:[NSNumber numberWithUnsignedLongLong:ullValue] forKey:key];
                break;
            case 'l':   // long
                [invocation invoke];
                [invocation getReturnValue:&longValue];
                [coder encodeObject:[NSNumber numberWithLong:longValue] forKey:key];
                break;
            case 's':   // short
                [invocation invoke];
                [invocation getReturnValue:&shortValue];
                [coder encodeObject:[NSNumber numberWithShort:shortValue] forKey:key];
                break;
            case 'I':   // unsigned
                [invocation invoke];
                [invocation getReturnValue:&unsignedValue];
                [coder encodeObject:[NSNumber numberWithUnsignedInt:unsignedValue] forKey:key];
                break;
            default:
                break;
        }
    }
}

- (void)decodeProperties:(NSDictionary*)properties withCoder:(NSCoder *)coder {
    for (NSString *key in properties) {
        NSString *type = [properties objectForKey:key][@"type"];
        id value;
        NSNumber *number;
        NSInteger i;
        float f;
        BOOL b;
        double d;
        unsigned long ul;
        unsigned long long ull;
		long longValue;
		unsigned unsignedValue;
		short shortValue;
        
        NSString *className;
        
        switch ([type characterAtIndex:0]) {
            case '@':   // object
                if ([[type componentsSeparatedByString:@"\""] count] > 1) {
                    className = [[type componentsSeparatedByString:@"\""] objectAtIndex:1];
                    Class class = NSClassFromString(className);
                    // only decode if the property conforms to NSCoding
                    if ([class conformsToProtocol:@protocol(NSCoding )]){
                        value = [coder decodeObjectForKey:key];
                        [self setValue:value forKey:key];
                    }
                }
                break;
            case 'c':   // bool
                number = [coder decodeObjectForKey:key];
                b = [number boolValue];
                [self setValue:@(b) forKey:key];
                break;
            case 'f':   // float
                number = [coder decodeObjectForKey:key];
                f = [number floatValue];
                [self setValue:@(f) forKey:key];
                break;
            case 'd':   // double
                number = [coder decodeObjectForKey:key];
                d = [number doubleValue];
                [self setValue:@(d) forKey:key];
                break;
            case 'i':   // int
                number = [coder decodeObjectForKey:key];
                i = [number intValue];
                [self setValue:@(i) forKey:key];
                break;
            case 'L':   // unsigned long
                number = [coder decodeObjectForKey:key];
                ul = [number unsignedLongValue];
                [self setValue:@(ul) forKey:key];
                break;
            case 'Q':   // unsigned long long
                number = [coder decodeObjectForKey:key];
                ull = [number unsignedLongLongValue];
                [self setValue:@(ull) forKey:key];
                break;
			case 'l':   // long
                number = [coder decodeObjectForKey:key];
                longValue = [number longValue];
                [self setValue:@(longValue) forKey:key];
                break;
            case 'I':   // unsigned
                number = [coder decodeObjectForKey:key];
                unsignedValue = [number unsignedIntValue];
                [self setValue:@(unsignedValue) forKey:key];
                break;
            case 's':   // short
                number = [coder decodeObjectForKey:key];
                shortValue = [number shortValue];
                [self setValue:@(shortValue) forKey:key];
                break;
            default:
                break;
        }
    }
}

#pragma mark - Private

- (NSMutableDictionary *)propertiesForClass:(Class)klass {
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *pattrs = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
		NSArray *pcomps = [pattrs componentsSeparatedByString:@","];
        NSString *type = [[pcomps objectAtIndex:0] substringFromIndex:1];
		NSArray *attrs = [pcomps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, pcomps.count - 1)]];
		
		results[name] = @{ @"type":type, @"attributes":attrs};
	}
    free(properties);
    
    if ([klass superclass] != [NSObject class]) {
        [results addEntriesFromDictionary:[self propertiesForClass:[klass superclass]]];
    }
    
    return results;
}

@end
