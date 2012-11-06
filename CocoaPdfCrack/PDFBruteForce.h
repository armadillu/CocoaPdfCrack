//
//  PDFBruteFroce.h
//  CocoaPdfCrack
//
//  Created by Oriol Ferrer Mesià on 06/11/12.
//  Copyright (c) 2012 Oriol Ferrer Mesià. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>


@interface PDFBruteFroce : NSObject{
	
	PDFDocument * pdf ;
	NSArray * dictSplit;
	int numThreads ;

	BOOL processing;
}

-(id)initWithPdfPath:(NSString*) pdfPath dictionaryPath:(NSString*) dictionaryP;
-(void)startProcessing:(int)numThreads_;
-(void)stopProcessing;

@end
