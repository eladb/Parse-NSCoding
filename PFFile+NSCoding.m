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

- (NSDictionary *)ivars
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    unsigned int outCount;
	
    Ivar* ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++){
        Ivar ivar = ivars[i];
        NSString* ivarNameString = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSValue* value = [self valueForKey:ivarNameString];
        if (value) {
            [dict setValue:value forKey:ivarNameString];
        }
    }
	
    free(ivars);
    return dict;
}

@end
