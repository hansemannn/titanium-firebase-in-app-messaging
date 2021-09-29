/**
 * titanium-firebase-in-app-messaging
 *
 * Created by Hans Knöchel
 * Copyright (c) 2020 Hans Knöchel. All rights reserved.
 */

#import "FirebaseInappmessagingModule.h"
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

- (void)impressionDetected:(id)unused
{
  if (_displayDelegate == nil || _cardMessage == nil) { return; }
  [_displayDelegate impressionDetectedForMessage:_cardMessage];
}

- (void)displayErrorEncountered:(id)unused
{
  if (_displayDelegate == nil || _cardMessage == nil) { return; }
  [_displayDelegate displayErrorForMessage:_cardMessage error:[NSError errorWithDomain:@"ti.firebase.in-app-messaging" code:0 userInfo:nil]];
}

- (void)messageClicked:(id)value
{
  ENSURE_SINGLE_ARG(value, NSNumber);
  BOOL isPrimaryButton = [TiUtils boolValue:value];

  if (_displayDelegate == nil || _cardMessage == nil) { return; }

  FIRInAppMessagingAction *primaryAction = [[FIRInAppMessagingAction alloc] initWithActionText:_cardMessage.primaryActionButton.buttonText
                                                                                     actionURL:_cardMessage.primaryActionURL];
  FIRInAppMessagingAction *secondaryAction = [[FIRInAppMessagingAction alloc] initWithActionText:_cardMessage.secondaryActionButton.buttonText
                                                                                       actionURL:_cardMessage.secondaryActionURL];

  if (isPrimaryButton) {
    [_displayDelegate messageClicked:_cardMessage withAction: isPrimaryButton ? primaryAction : secondaryAction];
  }
}

- (void)messageDismissed:(id)unused
{
  if (_displayDelegate == nil || _cardMessage == nil) { return; }
  [_displayDelegate messageDismissed:_cardMessage dismissType:FIRInAppMessagingDismissTypeAuto];
}

// MARK: FIRInAppMessagingDisplay delegate

- (void)displayMessage:(nonnull FIRInAppMessagingDisplayMessage *)messageForDisplay displayDelegate:(nonnull id<FIRInAppMessagingDisplayDelegate>)displayDelegate {
  _displayDelegate = displayDelegate;

  // Handle Cards
  if ([messageForDisplay isKindOfClass:[FIRInAppMessagingCardDisplay class]]) {
    _cardMessage = (FIRInAppMessagingCardDisplay *)messageForDisplay;

    NSDictionary *event = @{
      @"title": _cardMessage.title,
      @"body": _cardMessage.body,
      @"portraitImage": _cardMessage.portraitImageData.imageURL,
      @"landscapeImage": _cardMessage.landscapeImageData.imageURL,
      @"primaryAction": @{
        @"title": NULL_IF_NIL(_cardMessage.primaryActionButton.buttonText),
        @"url": NULL_IF_NIL(_cardMessage.primaryActionURL.absoluteString)
      },
      @"secondaryAction": @{
        @"title": NULL_IF_NIL(_cardMessage.secondaryActionButton.buttonText),
        @"url": NULL_IF_NIL(_cardMessage.secondaryActionURL.absoluteString)
      },
    };

    [_callback call:@[event] thisObject:self];
    
    return;
  }

  NSLog(@"[ERROR] Unhandled in app messaging type: %li", messageForDisplay.type);
}

@end
