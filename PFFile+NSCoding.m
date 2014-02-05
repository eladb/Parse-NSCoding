//
//  PFFile+NSCoding.m
//  UpdateZen
//
//  Created by Martin Rybak on 2/3/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFFile+NSCoding.h"
#import <objc/runtime.h>

#define kPFFileName @"_name"
#define kPFFileIvars @"ivars"
#define kPFFileData @"data"

@implementation PFFile (NSCoding)

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.name forKey:kPFFileName];
	[encoder encodeObject:[self ivars] forKey:kPFFileIvars];
	if (self.isDataAvailable) {
		[encoder encodeObject:[self getData] forKey:kPFFileData];
	}
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	NSString* name = [aDecoder decodeObjectForKey:kPFFileName];
	NSDictionary* ivars = [aDecoder decodeObjectForKey:kPFFileIvars];
	NSData* data = [aDecoder decodeObjectForKey:kPFFileData];
	
	self = [PFFile fileWithName:name data:data];
	if (self) {
		for (NSString* key in [ivars allKeys]) {
			[self setValue:ivars[key] forKey:key];
		}
	}
	return self;
}

- (NSDictionary*)ivars
{
    NSMutableDictionary* ivarsDict = [NSMutableDictionary new];
    unsigned int count;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        const char* type = ivar_getTypeEncoding(ivar);
        ptrdiff_t offset = ivar_getOffset(ivar);
		
		id value;
		if (strncmp(type, "i", 1) == 0) {
            int intValue = *(int*)((uintptr_t)self + offset);
			value = @(intValue);
            NSLog(@"%s = %i", name, intValue);
        } else if (strncmp(type, "f", 1) == 0) {
            float floatValue = *(float*)((uintptr_t)self + offset);
			value = @(floatValue);
            NSLog(@"%s = %f", name, floatValue);
        } else if (strncmp(type, "@", 1) == 0) {
            value = object_getIvar(self, ivar);
            NSLog(@"%s = %@", name, value);
        }
		
		if (value) {
			[ivarsDict setObject:value forKey:[NSString stringWithFormat: @"%s", name]];
		}
    }
    free(ivars);
    return ivarsDict;
}

@end
