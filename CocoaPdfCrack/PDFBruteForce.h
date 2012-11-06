//
//  PDFBruteFroce.h
//  CocoaPdfCrack
//
//  Created by Oriol Ferrer Mesià on 06/11/12.
//  Copyright (c) 2012 Oriol Ferrer Mesià. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "FileReader.h"



@interface PDFBruteFroce : NSObject{

	PDFDocument * pdf ;
	int numThreads ;
	FileReader* fileReader;
	BOOL processing;
}

-(id)initWithPdfPath:(NSString*) pdfPath dictionaryPath:(NSString*) dictionaryP;
-(void)startProcessing:(int)numThreads_;
-(void)stopProcessing;

@end
