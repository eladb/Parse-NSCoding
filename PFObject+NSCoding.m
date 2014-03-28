//
//  PFObject+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFObject+NSCoding.h"
#import "NSObject+Properties.h"

@implementation PFObject (NSCoding)

@dynamic createdAt;
@dynamic updatedAt;

#define kPFObjectObjectId @"___PFObjectId"
#define kPFObjectAllKeys @"___PFObjectAllKeys"
#define kPFObjectClassName @"___PFObjectClassName"
#define kPFObjectCreatedAtKey @"___PFObjectCreatedAt"
#define kPFObjectUpdatedAtKey @"___PFObjectUpdatedAt"
#define kPFObjectIsDataAvailableKey @"hasBeenFetched"

- (void)encodeWithCoder:(NSCoder*)encoder
{
	//Serialize Parse-specific values
	[encoder encodeObject:[self objectId] forKey:kPFObjectObjectId];
	[encoder encodeObject:[self parseClassName] forKey:kPFObjectClassName];
	[encoder encodeObject:[self allKeys] forKey:kPFObjectAllKeys];
	[encoder encodeBool:[self isDataAvailable] forKey:kPFObjectIsDataAvailableKey];
	
	//Serialize Parse timestamps
	[encoder encodeObject:self.createdAt forKey:kPFObjectCreatedAtKey];
	[encoder encodeObject:self.updatedAt forKey:kPFObjectUpdatedAtKey];
	
	//Serialize all non-nil Parse properties
	//[self allKeys] returns only the @dynamic properties that are not nil
	for (NSString* key in [self allKeys]) {
		id value = self[key];
		[encoder encodeObject:value forKey:key];
	}
	
	//Serialize all non-Parse properties
	NSDictionary* nonParseProperties = [self nonDynamicProperties];
	[self encodeProperties:nonParseProperties withCoder:encoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	//Deserialize Parse-specific values
    NSString* objectId = [aDecoder decodeObjectForKey:kPFObjectObjectId];
	NSString* parseClassName = [aDecoder decodeObjectForKey:kPFObjectClassName];
	NSArray* allKeys = [aDecoder decodeObjectForKey:kPFObjectAllKeys];
	BOOL isDataAvailable = [aDecoder decodeBoolForKey:kPFObjectIsDataAvailableKey];
	
	if ([self isMemberOfClass:[PFObject class]]) {
		//If this is a PFObject, recreate the object using the Parse class name and objectId
		self = [PFObject objectWithoutDataWithClassName:parseClassName objectId:objectId];
	}
	else {
		//If this is a PFObject subclass, recreate the object using PFSubclassing
		self = [[self class] objectWithoutDataWithObjectId:objectId];
	}
	
	if (self) {
		
		//Deserialize Parse timestamps
		self.createdAt = [aDecoder decodeObjectForKey:kPFObjectCreatedAtKey];
		self.updatedAt = [aDecoder decodeObjectForKey:kPFObjectUpdatedAtKey];
		
		//Deserialize all non-nil Parse properties
		for (NSString* key in allKeys) {
            id obj = [aDecoder decodeObjectForKey:key];
			self[key] = obj;
		}
		
		//Deserialize all nil Parse properties with NSNull
		//This is to prevent an NSInternalConsistencyException when trying to access them in the future
		//Loop through all dynamic properties that aren't in [self allKeys]
		NSDictionary* allParseProperties = [self dynamicProperties];
		for (NSString* key in allParseProperties) {
			if (![allKeys containsObject:key]) {
				self[key] = [NSNull null];
			}
		}
		
		//Deserialize all non-Parse properties
		NSDictionary* nonParseProperties = [self nonDynamicProperties];
		[self decodeProperties:nonParseProperties withCoder:aDecoder];
    }
	
	//Mark PFObject as not dirty
	[self->operationSetQueue removeAllObjects];
	
	//Mark PFObject with same hasBeenFetched value as before encoding
	[self setValue:@(isDataAvailable) forKey:kPFObjectIsDataAvailableKey];
	
    return self;
}

@end
