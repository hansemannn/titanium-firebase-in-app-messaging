/**
 * titanium-firebase-in-app-messaging
 *
 * Created by Hans Knöchel
 * Copyright (c) 2020 Hans Knöchel. All rights reserved.
 */

#import "TiModule.h"
#import <FirebaseInAppMessaging/FirebaseInAppMessaging.h>

@interface FirebaseInappmessagingModule : TiModule<FIRInAppMessagingDisplay> {
  KrollCallback *_callback;
  FIRInAppMessagingCardDisplay *_cardMessage;
  id<FIRInAppMessagingDisplayDelegate> _displayDelegate;
}

- (void)triggerEvent:(id)event;

- (void)registerMessageDisplayComponent:(id)callback;

- (void)impressionDetected:(id)unused;

- (void)displayErrorEncountered:(id)unused;

- (void)messageClicked:(id)value;

- (void)messageDismissed:(id)unused;

@end
