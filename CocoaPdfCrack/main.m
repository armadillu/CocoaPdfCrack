//
//  main.cpp
//  CocoaPdfCrack
//
//  Created by Oriol Ferrer Mesià on 06/11/12.
//  Copyright (c) 2012 Oriol Ferrer Mesià. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>
#import "PDFBruteForce.h"

int main(int argc, char *argv[]){

	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	if (argc != 4) {
		printf("usage: CocoaPdfCrack file.pdf dictionary.txt numThreads");
		exit(0);
	}

	NSString * pdfPath = [NSString stringWithCString: argv[1] encoding:NSASCIIStringEncoding];
	NSLog(@"PDF PATH: %@", pdfPath);
	NSString * dictPath = [NSString stringWithCString: argv[2] encoding:NSASCIIStringEncoding];
	NSLog(@"DICTIONARY PATH: %@", dictPath);
	int numT = [[NSString stringWithCString:argv[3] encoding:NSASCIIStringEncoding] intValue];
	NSLog(@"NUM THREADS: %d", numT);


	PDFBruteFroce * brute = [[PDFBruteFroce alloc] initWithPdfPath: pdfPath
													dictionaryPath: dictPath];

	[brute startProcessing: numT];

    [[NSRunLoop currentRunLoop] run];

	[pool release];

}


