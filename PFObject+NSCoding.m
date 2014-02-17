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
	//Serialize Parse objectId and non-nil Parse property list
	//[self allKeys] returns only the @dynamic properties that have a value
	[encoder encodeObject:[self objectId] forKey:kPFObjectObjectId];
	[encoder encodeObject:[self allKeys] forKey:kPFObjectAllKeys];
	
	//Serialize each non-nil Parse property
	for (NSString* key in [self allKeys]) {
		id value = self[key];
		[encoder encodeObject:value forKey:key];
	}
    
	//Serialize each non-Parse property
	for (NSString* key in [self nonDynamicProperties]) {
		id value = [self valueForKey:key];
		[encoder encodeObject:value forKey:key];
    }
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	//Deserialize Parse objectId and non-nil Parse property list
    NSString* objectId = [aDecoder decodeObjectForKey:kPFObjectObjectId];
	NSArray* allKeys = [aDecoder decodeObjectForKey:kPFObjectAllKeys];
	
	//Recreate Parse object with objectId
	self = [[self class] objectWithoutDataWithObjectId:objectId];
    if (self) {
		
		//Deserialize each non-nil Parse property
		for (NSString* key in allKeys) {
            id obj = [aDecoder decodeObjectForKey:key];
			self[key] = obj;
		}
		
		//Deserialize each nil Parse property with NSNull
		//This is to prevent an NSInternalConsistencyException when trying to access them in the future
		for (NSString* key in [self dynamicProperties]) {
			if (![allKeys containsObject:key]) {
				self[key] = [NSNull null];
			}
		}
		
		//Deserialize each non-Parse property
		NSArray* nonParsePropertes = [self nonDynamicProperties];
		for (NSString* key in nonParsePropertes) {
            id obj = [aDecoder decodeObjectForKey:key];
			[self setValue:obj forKey:key];
        }
    }
    return self;
}

//Returns all the dynamic properties of this object
- (NSArray*)dynamicProperties
{
	NSDictionary* properties = [self propertiesDictionary];
    NSMutableArray* output = [[NSMutableArray alloc] init];
    for (id key in [properties allKeys]) {
		if ([properties[key] rangeOfString:@"D"].location != NSNotFound) {
			[output addObject:key];
		}
	}
	return output;
}

//Returns all the non-dynamic properties of this object
- (NSArray*)nonDynamicProperties
{
	NSDictionary* properties = [self propertiesDictionary];
    NSMutableArray* output = [[NSMutableArray alloc] init];
    for (id key in [properties allKeys]) {
		if ([properties[key] rangeOfString:@"D"].location == NSNotFound) {
			[output addObject:key];
		}
	}
	return output;
}

//Returns all the property names and attributes of this object
- (NSDictionary*)propertiesDictionary
{
	NSMutableDictionary* output = [[NSMutableDictionary alloc] init];
    unsigned int outCount;
    objc_property_t* properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyNameString = [NSString stringWithUTF8String:property_getName(property)];
		NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
		output[propertyNameString] = propertyAttributes;
    }
    
    free(properties);
    return [output copy];
}

@end
