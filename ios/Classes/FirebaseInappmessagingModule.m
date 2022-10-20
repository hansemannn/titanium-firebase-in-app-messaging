/**
 * titanium-firebase-in-app-messaging
 *
 * Created by Hans Knöchel
 * Copyright (c) 2020 Hans Knöchel. All rights reserved.
 */

#import "FirebaseInappmessagingModule.h"
#import "FirebaseInappmessagingUtils.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation FirebaseInappmessagingModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"1a783c68-e7bc-4be2-8639-d5d014d7a79f";
}

- (NSString *)moduleId
{
  return @"firebase.inappmessaging";
}

#pragma Public APIs

- (void)triggerEvent:(id)event
{
  ENSURE_SINGLE_ARG(event, NSString);
  [[FIRInAppMessaging inAppMessaging] triggerEvent:event];
}

- (void)registerMessageDisplayComponent:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  _callback = callback;
  [[FIRInAppMessaging inAppMessaging] setMessageDisplayComponent:self];
}

- (FIRInAppMessagingDisplayMessage *)selectedDisplay
{
  _cardMessage || _bannerMessage || _modalMessage || _imageOnlyMessage;
}

- (void)impressionDetected:(id)unused
{
  if (_displayDelegate == nil || [self selectedDisplay] == nil) {
    return;
  }

  [_displayDelegate impressionDetectedForMessage:[self selectedDisplay]];
}

- (void)displayErrorEncountered:(id)unused
{
  if (_displayDelegate == nil || [self selectedDisplay] == nil) {
    return;
  }

  [_displayDelegate displayErrorForMessage:[self selectedDisplay] error:[NSError errorWithDomain:@"ti.firebase.in-app-messaging" code:0 userInfo:nil]];
}

- (void)messageClicked:(id)value
{
  if (_displayDelegate == nil || [self selectedDisplay] == nil) {
    return;
  }
  
  ENSURE_SINGLE_ARG(value, NSNumber);
  BOOL isPrimaryButton = [TiUtils boolValue:value];
  
  FIRInAppMessagingDisplayMessage *selectedMessage = [self selectedDisplay];
  
  // Handle card actions
  if ([selectedMessage isKindOfClass:[FIRInAppMessagingCardDisplay class]]) {
    FIRInAppMessagingAction *primaryAction = [[FIRInAppMessagingAction alloc] initWithActionText:_cardMessage.primaryActionButton.buttonText
                                                                                       actionURL:_cardMessage.primaryActionURL];
    
    FIRInAppMessagingAction *secondaryAction;
    if (_cardMessage.secondaryActionButton) {
      secondaryAction = [[FIRInAppMessagingAction alloc] initWithActionText:_cardMessage.secondaryActionButton.buttonText
                                                                  actionURL:_cardMessage.secondaryActionURL];
    }
    
    if (isPrimaryButton) {
      FIRInAppMessagingAction *actionToInvocate = isPrimaryButton ? primaryAction : secondaryAction != nil ? secondaryAction : nil;
      if (actionToInvocate != nil) {
        [_displayDelegate messageClicked:_cardMessage withAction:actionToInvocate];
      }
    }
    
  // Handle modal action
  } else if ([selectedMessage isKindOfClass:[FIRInAppMessagingModalDisplay class]]) {
    if (_modalMessage.actionButton != nil) {
      FIRInAppMessagingAction *action = [[FIRInAppMessagingAction alloc] initWithActionText:_modalMessage.actionButton.buttonText
                                                                                  actionURL:_modalMessage.actionURL];
      
      [_displayDelegate messageClicked:_modalMessage withAction:action];
    }
  // Handle banner action
  } else if ([selectedMessage isKindOfClass:[FIRInAppMessagingBannerDisplay class]]) {
    if (_bannerMessage.actionURL != nil) {
      FIRInAppMessagingAction *action = [[FIRInAppMessagingAction alloc] initWithActionText:nil actionURL:_bannerMessage.actionURL];
      
      [_displayDelegate messageClicked:_bannerMessage withAction:action];
    }
    
  // Handle image-only action
  } else if ([selectedMessage isKindOfClass:[FIRInAppMessagingImageOnlyDisplay class]]) {
    if (_imageOnlyMessage.actionURL != nil) {
      FIRInAppMessagingAction *action = [[FIRInAppMessagingAction alloc] initWithActionText:nil actionURL:_imageOnlyMessage.actionURL];
      
      [_displayDelegate messageClicked:_imageOnlyMessage withAction:action];
    }
  } else {
    NSLog(@"[ERROR] Unhandled in app messaging type: %li", selectedMessage.type);
  }
}

- (void)messageDismissed:(id)unused
{
  if (_displayDelegate == nil || [self selectedDisplay] == nil) {
    return;
  }

  [_displayDelegate messageDismissed:[self selectedDisplay] dismissType:FIRInAppMessagingDismissTypeAuto];
}

// MARK: FIRInAppMessagingDisplay

- (void)displayMessage:(nonnull FIRInAppMessagingDisplayMessage *)messageForDisplay displayDelegate:(nonnull id<FIRInAppMessagingDisplayDelegate>)displayDelegate {
  _displayDelegate = displayDelegate;
  
  NSMutableDictionary *event = nil;

  // Handle cards
  if ([messageForDisplay isKindOfClass:[FIRInAppMessagingCardDisplay class]]) {
    _cardMessage = (FIRInAppMessagingCardDisplay *)messageForDisplay;
    event = [FirebaseInappmessagingUtils dictionaryForCardDisplay:_cardMessage].mutableCopy;
  // Handle modal
  } else if ([messageForDisplay isKindOfClass:[FIRInAppMessagingModalDisplay class]]) {
    _modalMessage = (FIRInAppMessagingModalDisplay *)messageForDisplay;
    event = [FirebaseInappmessagingUtils dictionaryForModalDisplay:_modalMessage].mutableCopy;
  // Handle banner
  } else if ([messageForDisplay isKindOfClass:[FIRInAppMessagingBannerDisplay class]]) {
    _bannerMessage = (FIRInAppMessagingBannerDisplay *)messageForDisplay;
    event = [FirebaseInappmessagingUtils dictionaryForBannerDisplay:_bannerMessage].mutableCopy;
  // Handle image-only
  } else if ([messageForDisplay isKindOfClass:[FIRInAppMessagingImageOnlyDisplay class]]) {
    _imageOnlyMessage = (FIRInAppMessagingImageOnlyDisplay *)messageForDisplay;
    event = [FirebaseInappmessagingUtils dictionaryForImageOnlyDisplay:_imageOnlyMessage].mutableCopy;
  }

  if (event != nil) {
    event[@"type"] = @(messageForDisplay.type);
    event[@"triggerType"] = @(messageForDisplay.triggerType);

    [_callback call:@[event] thisObject:self];
  } else {
    NSLog(@"[ERROR] Unhandled in app messaging type: %li", messageForDisplay.type);
  }
}

@end
