Parse-NSCoding
==============

This library adds [NSCoding] support to subclasses of **PFObject** and **PFUser** so that they can be serialized and deserialized (for [custom caching], for example). All properties will be serialized, including Parse properties (those marked ```@dynamic```), as well as non-Parse properties. This library also serializes the related **PFACL** and **PFFile** classes. If your **PFFile** object contains NSData (```isDataAvailable == YES```), that too will be serialized.

##Sample Usage

Just install this library in your project. That's it. No header files to import! The Objective-C runtime will automatically send [NSCoding] messages to your Parse objects when you attempt to serialize them, and the category methods in this library will be invoked.

##Installation

Easiest installation is using CocoaPods:

```pod 'Parse+NSCoding', '~> 0.1.0'```

Otherwise you must manually copy the .h and .m files from this repo. Obviously you must also have the [Parse SDK] installed. Enjoy!

##Credits

Much of the code in this library came from:

https://parse.com/questions/persistent-store-of-pfobject-pffile

[NSCoding]:https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/Reference/Reference.html
[custom caching]:https://github.com/martinrybak/PFCloud-Cache
[Parse SDK]:https://parse.com/downloads/ios/parse-library/latest
