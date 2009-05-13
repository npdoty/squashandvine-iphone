#import <Foundation/Foundation.h>
#include <libxml/xmlreader.h>

@interface BSTweetParser : NSObject {
	
@private
	NSArray *statuses;
	NSData *xmlData;
	NSURL *url;
	xmlTextReaderPtr _reader;
	int _readReturnInt;
}


@property (retain) NSArray *statuses;
@property (retain) NSData *xmlData;
@property (retain) NSURL *url;

- (id)initWithData:(NSData *)d URL:(NSURL *)aURL;
- (NSArray*) getDataForLat:(double)lat Lon:(double)lon;

@end
