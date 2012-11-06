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
	fileReader = [[FileReader alloc] initWithFilePath:dictionaryP];
	processing = FALSE;

	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordFound:) name:PDFDocumentDidUnlockNotification object:nil];
	return self;
}

//-(void)passwordFound:(id)obj{
//	NSLog(@"pass found: %@", [obj object]);
//}


-(void)startProcessing:(int)numThreads_{

	numThreads = numThreads_;
	processing = TRUE;

	for(int i = 0; i < numThreads; i++){
		[NSThread detachNewThreadSelector:@selector(process:) toTarget:self  withObject:[NSNumber numberWithInt:i]];
	}
}


-(void)process:(NSNumber *) threadID{

	int ID = [threadID intValue];
	unsigned long c = 0;
	NSString * pass;
	BOOL found = FALSE;
	BOOL locked;
	NSAutoreleasePool *	pool = [[NSAutoreleasePool alloc] init];

	while( true ){

		if(!processing){
			NSLog(@"Thread %d >> PASS FOUND! >> %@ <<", ID, pass);
			return;
		}

		@synchronized(fileReader){
			pass = [fileReader readLine];
		}

		if (pass == nil){
			NSLog(@"Thread %d >> PASS NOT FOUND! (%ld passwords tested)", ID, c);
			return;
		}

		pass = [pass stringByReplacingOccurrencesOfString:@"\n" withString:@""];

		@synchronized(pdf){
			locked = [pdf isLocked];
		}
		
		if(locked){
			found = [pdf unlockWithPassword: pass];
			if (found){
				NSLog(@"Thread %d >> PASS FOUND! >> %@ <<", ID, pass);
				processing = FALSE;
				return;
			}
		}

		if (c%10000 == 1){
			NSLog(@"Thread %d >> Current word: \"%@\" (%ld passwords tested)", ID, pass, c);
			[pool release];
			pool = [[NSAutoreleasePool alloc] init];
		}

		c++;
	}
}

@end
