Parse-NSCoding
==============

This library adds [NSCoding] support to **PFObject**, **PFUser**, **PFACL**, and **PFFile** so that they can be serialized (for custom caching, for example).

##Sample Usage

Just install this library in your project. That's it. No header files to import! The Objective-C runtime will automatically send NSCoding messages to your Parse objects, and the category methods in this library will be invoked.

##Non-Parse Properties

If you use custom subclasses of **PFObject** or **PFUser** that contain additional non-Parse properties (not marked ```@dynamic```), those properties will **not** be automatically serialized using the categories above. You will need to subclass **PFSerializableObject** or **PFSerializableUser**, override the [NSCoding] methods, and append additional encoding statements for those properties:

```
#import "PFSerializableObject.h"
or
#import "PFSerializableUser.h"

...

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[super encodeWithCoder:encoder];
	[encoder encodeObject:self.nonParseProperty1 forKey:@"nonParseProperty1"];
	[encoder encodeObject:self.nonParseProperty2 forKey:@"nonParseProperty2"];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		self.nonParseProperty1 = [aDecoder decodeObjectForKey:@"nonParseProperty1"];
		self.nonParseProperty2 = [aDecoder decodeObjectForKey:@"nonParseProperty2"];
	}
	return self;
}
```

##Installation

Easiest installation is using CocoaPods to resolve all dependencies:

```pod 'Parse+NSCoding', '~> 0.0.1'```

Otherwise you must manually copy the .h and .m files from this repo. Obviously you must also have the [Parse SDK] installed. Enjoy!

##Credits

Much of the code in this library came from:

https://parse.com/questions/persistent-store-of-pfobject-pffile

[NSCoding]:https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/Reference/Reference.html
[Parse SDK]:https://parse.com/downloads/ios/parse-library/latest
