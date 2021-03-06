/**
 * This file was auto-generated by the Titanium Module SDK helper for Android
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package firebase.inappmessaging;

import androidx.annotation.NonNull;

import com.google.firebase.inappmessaging.FirebaseInAppMessaging;
import com.google.firebase.inappmessaging.FirebaseInAppMessagingDisplay;
import com.google.firebase.inappmessaging.FirebaseInAppMessagingDisplayCallbacks;
import com.google.firebase.inappmessaging.FirebaseInAppMessagingRegistrar;
import com.google.firebase.inappmessaging.display.FirebaseInAppMessagingDisplayRegistrar;
import com.google.firebase.inappmessaging.model.Action;
import com.google.firebase.inappmessaging.model.CardMessage;
import com.google.firebase.inappmessaging.model.ImageData;
import com.google.firebase.inappmessaging.model.InAppMessage;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiApplication;

@Kroll.module(name="TitaniumFirebaseInAppMessaging", id="firebase.inappmessaging")
public class TitaniumFirebaseInAppMessagingModule extends KrollModule implements FirebaseInAppMessagingDisplay
{
	private FirebaseInAppMessagingDisplayCallbacks _firebaseInAppMessagingDisplayCallbacks = null;
	private Action _primaryAction = null;
	private Action _secondaryAction = null;
	private KrollFunction _callback = null;

	// Methods

	@Kroll.method
	public void triggerEvent(String eventName)
	{
		FirebaseInAppMessaging.getInstance().triggerEvent(eventName);
	}

	@Kroll.method
	public void registerMessageDisplayComponent(KrollFunction callback)
	{
		_callback = callback;
		FirebaseInAppMessaging.getInstance().setMessageDisplayComponent(this);
	}

	@Kroll.method
	public void impressionDetected()
	{
		if (_firebaseInAppMessagingDisplayCallbacks == null) {
			return;
		}

		_firebaseInAppMessagingDisplayCallbacks.impressionDetected();
	}

	@Kroll.method
	public void displayErrorEncountered()
	{
		if (_firebaseInAppMessagingDisplayCallbacks == null) {
			return;
		}

		_firebaseInAppMessagingDisplayCallbacks.displayErrorEncountered(FirebaseInAppMessagingDisplayCallbacks.InAppMessagingErrorReason.IMAGE_DISPLAY_ERROR);
	}

	@Kroll.method
	public void messageClicked(boolean isPrimaryButton)
	{
		if (_firebaseInAppMessagingDisplayCallbacks == null) {
			return;
		}

		_firebaseInAppMessagingDisplayCallbacks.messageClicked(isPrimaryButton ? _primaryAction : _secondaryAction);
	}

	@Kroll.method
	public void messageDismissed()
	{
		if (_firebaseInAppMessagingDisplayCallbacks == null) {
			return;
		}

		_firebaseInAppMessagingDisplayCallbacks.messageDismissed(FirebaseInAppMessagingDisplayCallbacks.InAppMessagingDismissType.AUTO);
	}

	@Override
	public void displayMessage(@NonNull InAppMessage inAppMessage, @NonNull FirebaseInAppMessagingDisplayCallbacks firebaseInAppMessagingDisplayCallbacks)
	{
		_firebaseInAppMessagingDisplayCallbacks = null;
		_primaryAction = null;
		_secondaryAction = null;

		// Handle Cards
		if (inAppMessage instanceof CardMessage) {
			KrollDict event = new KrollDict();

			CardMessage cardMessage = (CardMessage)inAppMessage;
			ImageData portraitImage = cardMessage.getPortraitImageData();
			ImageData landscapeImage = cardMessage.getLandscapeImageData();

			// Basic info
			event.put("messageType", "card");
			event.put("title", cardMessage.getTitle());
			event.put("body", cardMessage.getBody());

			// Primary action
			KrollDict primaryAction = new KrollDict();
			primaryAction.put("url", cardMessage.getPrimaryAction().getActionUrl());
			primaryAction.put("title", cardMessage.getPrimaryAction().getButton().getText());
			event.put("primaryAction", primaryAction);

			// Secondary action
			KrollDict secondaryAction = new KrollDict();
			if (cardMessage.getSecondaryAction() != null) {
				secondaryAction.put("url", cardMessage.getSecondaryAction().getActionUrl());
				secondaryAction.put("title", cardMessage.getSecondaryAction().getButton().getText());
			}
			event.put("secondaryAction", primaryAction);

			// Images
			if (portraitImage != null) {
				event.put("portraitImage", portraitImage.getImageUrl());
			}
			if (landscapeImage != null) {
				event.put("landscapeImage", landscapeImage.getImageUrl());
			}

			// Set references to later objects that we need to track user interactions
			_primaryAction = cardMessage.getPrimaryAction();
			_secondaryAction = cardMessage.getSecondaryAction();
			_firebaseInAppMessagingDisplayCallbacks = firebaseInAppMessagingDisplayCallbacks;

			_callback.callAsync(krollObject, event);
			return;
		}

		// TODO: Handle more?

		Log.e("TiFIAM", "Unhandled in app messaging type: " + inAppMessage.getMessageType().name());
	}
}
