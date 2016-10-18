//
//  MFBSequence.h
//  Pods
//
//  Created by Mykola Tarbaiev on 22.08.16.
//
//

#import <Foundation/Foundation.h>

@interface MFBSequenceStep : NSObject

/**
 This method is called by MFBSequence class. Also it may be called directly
 to start sequence from a specific step.
 */
- (void)start;

/**
 Call this method to notify a sequence about receiver's completion.
 If you override this method, you must call super at some point in your implementation.
 */
- (void)complete;

@end

@class MFBSequence;

@protocol MFBSequenceDelegate

/**
 Sent to the delegate when sequence (i.e. its last step) has been completed.

 @param sequence The sequence that has been completed.
 */
- (void)didCompleteSequence:(MFBSequence *)sequence;
@end

@interface MFBSequence : NSObject

@property (nonatomic, weak) IBOutlet id<MFBSequenceDelegate> delegate;

- (instancetype)initWithSteps:(NSArray<MFBSequenceStep *> *)steps;

/**
 Starts the first step of the receiver.
 */
- (void)start;

@end
