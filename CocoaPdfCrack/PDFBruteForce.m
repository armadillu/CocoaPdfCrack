//
//  PDFBruteFroce.m
//  CocoaPdfCrack
//
//  Created by Oriol Ferrer Mesià on 06/11/12.
//  Copyright (c) 2012 Oriol Ferrer Mesià. All rights reserved.
//

#import "PDFBruteForce.h"

@implementation PDFBruteFroce

-(id)initWithPdfPath:(NSString*) pdfPath dictionaryPath:(NSString*) dictionaryP{

	pdf = [[PDFDocument alloc] initWithURL: [NSURL fileURLWithPath: pdfPath] ];

	NSLog(@"loading dictionary");
	NSString * dict = [NSString stringWithContentsOfURL: [NSURL fileURLWithPath: dictionaryP]];

	NSLog(@"splitting dictionary");
	dictSplit = [[dict componentsSeparatedByString:@"\n"] retain];

	NSLog(@"dict has %ld words", [dictSplit count]);

	processing = NO;
	return self;
}


-(void)startProcessing:(int)numThreads_{
	numThreads = numThreads_;
	processing = YES;
	for(int i = 0; i < numThreads; i++){
		[NSThread detachNewThreadSelector:@selector(process:) toTarget:self  withObject:[NSNumber numberWithInt:i]];
	}
}

-(void)stopProcessing{

	processing = NO;
}


-(void)process:(NSNumber *) threadID{

	int ID = [threadID intValue];
	unsigned long c = 0;

	unsigned long numPerThread = ([dictSplit count] / numThreads);
	unsigned long start = ID * numPerThread;
	unsigned long end = start + numPerThread;

	NSLog(@"Thread %d >> start at %ld and end at %ld",ID, start, end);
	for( unsigned long i = start; i < end; i++){

		if (!processing){
			NSLog(@"Thread %d >> STOPPED EARLY!", ID);
			break;
		}
		NSString * pass = [dictSplit objectAtIndex:i];
		c++;

		if (c%50000 == 1){
			NSLog(@"Thread %d >> Current word: %@    percent done: %.1f", ID, pass,  c / (double)[dictSplit count]);
		}

		if ([pdf unlockWithPassword: pass]){
			NSLog(@"Thread %d >> PASS FOUND! %@", ID, pass);
		}
	}

	NSLog(@"Thread %d >> PASS NOT FOUND!", ID);
	
}

@end
