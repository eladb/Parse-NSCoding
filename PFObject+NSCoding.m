//
//  PFObject+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFObject+NSCoding.h"
#import <objc/runtime.h>

@implementation PFObject (NSCoding)

#define kPFObjectObjectId @"___PFObjectId"
#define kPFObjectAllKeys @"___PFObjectAllKeys"

- (void)encodeWithCoder:(NSCoder*)encoder
{
	//Serialize Parse objectId and Parse property list
	//[self allKeys] returns only the @dynamic properties that have a value
	[encoder encodeObject:[self objectId] forKey:kPFObjectObjectId];
	[encoder encodeObject:[self allKeys] forKey:kPFObjectAllKeys];
	
	//Serialize each Parse property
	for (NSString* key in [self allKeys]) {
        [encoder encodeObject:self[key] forKey:key];
    }
    
	//Serialize each non-Parse property
	for (NSString* key in [self nonDynamicProperties]) {
		id value = [self valueForKey:key];
		if (value) {
			[encoder encodeObject:value forKey:key];
		}
    }
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	//Serialize Parse objectId and Parse property list
    NSString* objectId = [aDecoder decodeObjectForKey:kPFObjectObjectId];
	NSArray* allKeys = [aDecoder decodeObjectForKey:kPFObjectAllKeys];
	
	//Can't use [super init] or [PFObject objectWithoutDataWithClassName:objectId:]
	self = [[[self class] alloc] init];
    if (self) {
		
		//Set the Parse objectId
		self.objectId = objectId;
        
		//Deserialize each Parse property
		for (NSString* key in allKeys) {
            id obj = [aDecoder decodeObjectForKey:key];
            if (obj) {
                self[key] = obj;
            }
        }
		
		//Deserialize each non-Parse property
		NSArray* nonParsePropertes = [self nonDynamicProperties];
		for (NSString* key in nonParsePropertes) {
            id obj = [aDecoder decodeObjectForKey:key];
            if (obj) {
				[self setValue:obj forKey:key];
            }
        }
    }
    return self;
}

//Returns all the non-dynamic properties of this object
- (NSArray*)nonDynamicProperties
{
    NSMutableArray* output = [[NSMutableArray alloc] init];
    unsigned int outCount;
    objc_property_t* properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyNameString = [NSString stringWithUTF8String:property_getName(property)];
		NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
		if ([propertyAttributes rangeOfString:@"D"].location == NSNotFound) {
			[output addObject:propertyNameString];
		}
    }
    
    free(properties);
    return output;
}

@end
