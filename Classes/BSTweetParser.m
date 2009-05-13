#import "BSTweetParser.h";

@implementation BSTweetParser

@synthesize statuses, xmlData, url;

#pragma mark Init

- (id)initWithData:(NSData *)d URL: (NSURL *)aURL {
	if (![self init])
		return nil;
	self.xmlData = d;
	self.url = aURL;
	self.statuses = [NSMutableDictionary dictionaryWithCapacity:100];
	return self;
	}


#pragma mark Dealloc

- (void)dealloc {
	self.statuses = nil;
	self.xmlData = nil;
	self.url = nil;
	[super dealloc];
	}


#pragma mark Parse

- (const xmlChar *)_nodeValue {
	if (xmlTextReaderIsEmptyElement(_reader))
		return nil;
	int nodeType = XML_READER_TYPE_NONE;
	while (true) {
		nodeType = xmlTextReaderNodeType(_reader);
		if (nodeType == XML_READER_TYPE_TEXT)
			return xmlTextReaderConstValue(_reader);
		if (nodeType == XML_READER_TYPE_END_ELEMENT)
			return nil;
		_readReturnInt = xmlTextReaderRead(_reader);
		if (_readReturnInt != 1)
			return nil;
		}
	return nil;
	}


- (NSString *)_nodeValueAsString {
	const xmlChar *nodeValue = [self _nodeValue];
	if (!nodeValue)
		return nil;
	return [NSString stringWithUTF8String:(const char *)nodeValue];
	}


- (NSDictionary *)_publicTimelineDictionaryForNodeWithName:(const xmlChar *)parentNodeName {
	if (xmlTextReaderIsEmptyElement(_reader))
		return nil;
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	while (true) {
		_readReturnInt = xmlTextReaderRead(_reader);
		if (_readReturnInt != 1)
			break;
		int nodeType = xmlTextReaderNodeType(_reader);
		const xmlChar *name = xmlTextReaderConstName(_reader);
		if (nodeType == XML_READER_TYPE_END_ELEMENT && xmlStrEqual(parentNodeName, name))
			break;			
		if (nodeType == XML_READER_TYPE_ELEMENT) {
			//if (xmlStrEqual(name, BAD_CAST "user")) /*"user" is the name of a sub-dictionary in each <status> item*/
			//	[d setObject:[self _publicTimelineDictionaryForNodeWithName:BAD_CAST "user"] forKey:@"user"];
			//else { /*It's just a string*/
				NSString *s = [self _nodeValueAsString];
				if (s)
					[d setObject:s forKey:[NSString stringWithUTF8String:(const char *)name]];
			//	}
			}
		if (_readReturnInt != 1) /*Above calls may have advanced reader*/
			break;
		}
	return d;
	}


- (void)parse {
	_reader = xmlReaderForMemory([xmlData bytes], [xmlData length], [[url absoluteString] UTF8String], nil, XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
	if (!_reader)
		return;
	NSMutableArray *tempArray = [NSMutableArray array];
	while (true) {
		_readReturnInt = xmlTextReaderRead(_reader);
		if (_readReturnInt != 1)
			break;
		if (xmlTextReaderNodeType(_reader) != XML_READER_TYPE_ELEMENT)
			continue;
		if (xmlStrEqual(xmlTextReaderConstName(_reader), BAD_CAST "vegetable"))
			[tempArray addObject:[self _publicTimelineDictionaryForNodeWithName:BAD_CAST "vegetable"]];
		if (_readReturnInt != 1) /*Check because _dictionaryForStatusElement advances the reader*/
			break;
		}
	xmlFree(_reader);
	self.statuses = tempArray;
	}


- (NSArray*) getDataForLat:(double)lat Lon:(double)lon
{	
	NSLog(@"Downloading vegetables feed... wait a sec...");
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSURL *publicTimelineURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8081/feed.xml?lat=%f&lon=%f", lat, lon]];	//change localhost:8081 to whatsinseason.appspot.com to run against web server
	xmlData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:publicTimelineURL] returningResponse:&response error:&error];	
	
	BSTweetParser *parser = nil;
	parser = [[[BSTweetParser alloc] initWithData:xmlData URL:publicTimelineURL] autorelease];
	[parser parse];
	
	return parser.statuses;                                                        
}

@end

/*
int main (int argc, const char * argv[]) {
 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"Downloading public timeline... wait a sec...");
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSURL *publicTimelineURL = [NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.xml"];
	NSData *xmlData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:publicTimelineURL] returningResponse:&response error:&error];
	//I don't need to remind you about error checking, I'm sure.
	
	int reps = 1000;
	NSLog(@"Got it, parsing it %d times...", reps);
	BSTweetParser *parser = nil;
	NSDate *start = [NSDate date];
	int i;
	for (i = 0; i < reps; i++) {
		parser = [[BSTweetParser alloc] initWithData:xmlData URL:publicTimelineURL];
		[parser parse];
		[parser release];
		}
	NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:start];
	NSLog(@"Total time: %f", t);
	NSLog(@"Avg. time: %f", t / reps);
		
	parser = [[[BSTweetParser alloc] initWithData:xmlData URL:[NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.xml"]] autorelease];
	[parser parse];
	NSLog(@"Here's the public timeline as an array of dictionaries:\n%@", parser.statuses);
	
//	/*Write it to disk so you can look at it in Property List Editor	
//	[parser.statuses writeToFile:[@"~/Desktop/BSTwitterPublicTimelineArray.plist" stringByExpandingTildeInPath] atomically:YES];
	
    [pool drain];
    return 0;
}
*/

