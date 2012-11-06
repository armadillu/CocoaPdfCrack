//
//  PDFBruteFroce.m
//  CocoaPdfCrack
//
//  Created by Oriol Ferrer Mesià on 06/11/12.
//  Copyright (c) 2012 Oriol Ferrer Mesià. All rights reserved.
//

#import "PDFBruteForce.h"

@implementation PDFBruteFroce

-(id)initWithPdfPath:(NSString*) pdfPath_ dictionaryPath:(NSString*) dictionaryP{

	pdfPath = [pdfPath_ retain];
	fileReader = [[FileReader alloc] initWithFilePath:dictionaryP];
	processing = FALSE;

	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordFound:) name:PDFDocumentDidUnlockNotification object:nil];
	return self;
}

//-(void)passwordFound:(id)obj{
//	NSLog(@"pass found: %@", [obj object]);
//}


-(void)startProcessing:(int)numThreads_{

	processing = TRUE;

	for(int i = 0; i < numThreads_; i++){
		[NSThread detachNewThreadSelector:@selector(process:) toTarget:self  withObject:[NSNumber numberWithInt:i]];
	}
}


-(void)process:(NSNumber *) threadID{

	int ID = [threadID intValue];
	unsigned long c = 0;
	NSString * pass;
	NSAutoreleasePool *	pool = [[NSAutoreleasePool alloc] init];
	PDFDocument * pdf = [[PDFDocument alloc] initWithURL: [NSURL fileURLWithPath: pdfPath] ];

	while( true ){

		if(!processing){
			NSLog(@"Thread %d >> Stopping, password already found!", ID);
			return;
		}

		@synchronized(fileReader){
			pass = [fileReader readLine];
		}

		if (pass == nil){
			NSLog(@"Thread %d >> PASS NOT FOUND on this thread! (%ld tested)", ID, c);
			return;
		}

		pass = [pass stringByReplacingOccurrencesOfString:@"\n" withString:@""];

		if ([pdf unlockWithPassword: pass]){
			NSLog(@"Thread %d >> PASS FOUND! >> %@ <<", ID, pass);
			processing = FALSE;
			return;
		}

		if (c%10000 == 1){
			NSLog(@"Thread %d >> Current word: \"%@\" (%ld tested)", ID, pass, c);
			[pool release];
			pool = [[NSAutoreleasePool alloc] init];
		}

		c++;
	}
}

@end
