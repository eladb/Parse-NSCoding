//
//  NSObject+Properties.h
//  UpdateZen
//
//  Created by Martin Rybak on 3/7/14.
//  Adapted from https://github.com/greenisus/NSObject-NSCoding
//

#import <Foundation/Foundation.h>

@interface NSObject (Properties)

- (NSDictionary *)properties;
- (NSDictionary *)dynamicProperties;
- (NSDictionary *)nonDynamicProperties;
- (void)encodeProperties:(NSDictionary*)properties withCoder:(NSCoder *)coder;
- (void)decodeProperties:(NSDictionary*)properties withCoder:(NSCoder *)coder;

@end
