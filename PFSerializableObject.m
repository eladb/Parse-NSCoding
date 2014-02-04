//
//  PFSerializableObject.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFSerializableObject.h"

@implementation PFSerializableObject

#define kPFObjectObjectId @"___PFObjectId"
#define kPFObjectAllKeys @"___PFObjectAllKeys"

-(void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:[self objectId] forKey:kPFObjectObjectId];
	[encoder encodeObject:[self allKeys] forKey:kPFObjectAllKeys];
    for (NSString* key in [self allKeys]) {
        [encoder encodeObject:self[key] forKey:key];
    }
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    NSString* objectId = [aDecoder decodeObjectForKey:kPFObjectObjectId];
	NSArray* allKeys = [aDecoder decodeObjectForKey:kPFObjectAllKeys];
	
	self = [[[self class] alloc] init];
    if (self) {
		self.objectId = objectId;
        for (NSString * key in allKeys) {
            id obj = [aDecoder decodeObjectForKey:key];
            if (obj) {
                self[key] = obj;
            }
        }
    }
    return self;
}

@end
