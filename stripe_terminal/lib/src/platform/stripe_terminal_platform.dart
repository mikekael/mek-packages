library stripe_terminal;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';
import 'package:mek_stripe_terminal/src/models/card.dart';
import 'package:mek_stripe_terminal/src/models/refund.dart';
import 'package:mek_stripe_terminal/src/models/setup_intent.dart';
import 'package:one_for_all/one_for_all.dart';

part 'stripe_terminal_handlers.dart';
part 'stripe_terminal_platform.api.dart';

@HostApi(
  hostExceptionHandler: StripeTerminalPlatform._throwIfIsHostException,
  kotlinMethod: MethodApiType.callbacks,
  swiftMethod: MethodApiType.async,
)
class StripeTerminalPlatform extends _$StripeTerminalPlatform {
  @MethodApi(kotlin: MethodApiType.sync)
  @override
  Future<void> init();

  @MethodApi(kotlin: MethodApiType.sync, swift: MethodApiType.sync)
  @override
  Future<void> clearCachedCredentials();

//region Reader discovery, connection and updates

  @MethodApi(kotlin: MethodApiType.sync)
  @override
  Future<ConnectionStatus> connectionStatus();

  @MethodApi(kotlin: MethodApiType.sync, swift: MethodApiType.sync)
  @override
  Future<bool> supportsReadersOfType({
    required DeviceType deviceType,
    required DiscoveryMethod discoveryMethod,
    required bool simulated,
  });

  @override
  Stream<List<Reader>> discoverReaders({
    required DiscoveryMethod discoveryMethod,
    required bool simulated,
    required String? locationId,
  });

  @override
  Future<Reader> connectBluetoothReader(
    String serialNumber, {
    required String locationId,
    required bool autoReconnectOnUnexpectedDisconnect,
  });

  @override
  Future<Reader> connectHandoffReader(String serialNumber);

  @override
  Future<Reader> connectInternetReader(
    String serialNumber, {
    required bool failIfInUse,
  });

  @override
  Future<Reader> connectMobileReader(
    String serialNumber, {
    required String locationId,
  });

  @override
  Future<Reader> connectUsbReader(
    String serialNumber, {
    required String locationId,
    required bool autoReconnectOnUnexpectedDisconnect,
  });

  @MethodApi(kotlin: MethodApiType.sync)
  @override
  Future<Reader?> connectedReader();

  @override
  Future<void> cancelReaderReconnection();

  @override
  Future<List<Location>> listLocations({
    required String? endingBefore,
    required int? limit,
    required String? startingAfter,
  });

  @MethodApi(kotlin: MethodApiType.sync)
  @override
  Future<void> installAvailableUpdate();

  @override
  Future<void> cancelReaderUpdate();

  @override
  Future<void> disconnectReader();
//endregion

//region Taking payments
  @override
  Future<PaymentIntent> createPaymentIntent(PaymentIntentParameters parameters);

  @override
  Future<PaymentIntent> retrievePaymentIntent(String clientSecret);

  @MethodApi(swift: MethodApiType.callbacks)
  @override
  Future<PaymentIntent> startCollectPaymentMethod({
    required int operationId,
    required String paymentIntentId,
    required bool moto,
    required bool skipTipping,
  });

  @override
  Future<void> stopCollectPaymentMethod(int operationId);

  @override
  Future<PaymentIntent> processPayment(String paymentIntentId);

  @override
  Future<PaymentIntent> cancelPaymentIntent(String paymentIntentId);
//endregion

//region Saving payment details for later use
  @MethodApi(swift: MethodApiType.callbacks)
  @override
  Future<PaymentMethod> startReadReusableCard({
    required int operationId,
    required String? customer,
    required Map<String, String>? metadata,
  });

  @override
  Future<void> stopReadReusableCard(int operationId);

  @override
  Future<SetupIntent> createSetupIntent({
    required String? customerId,
    required Map<String, String>? metadata,
    required String? onBehalfOf,
    required String? description,
    required SetupIntentUsage? usage,
  });

  @override
  Future<SetupIntent> retrieveSetupIntent(String clientSecret);

  @MethodApi(swift: MethodApiType.callbacks)
  @override
  Future<SetupIntent> startCollectSetupIntentPaymentMethod({
    required int operationId,
    required String setupIntentId,
    required bool customerConsentCollected,
  });

  @override
  Future<void> stopCollectSetupIntentPaymentMethod(int operationId);

  @override
  Future<SetupIntent> confirmSetupIntent(String setupIntentId);

  @override
  Future<SetupIntent> cancelSetupIntent(String setupIntentId);
//endregion

//region Card-present refunds
  @override
  @MethodApi(swift: MethodApiType.callbacks)
  Future<void> startCollectRefundPaymentMethod({
    required int operationId,
    required String chargeId,
    required int amount,
    required String currency,
    required Map<String, String>? metadata,
    required bool? reverseTransfer,
    required bool? refundApplicationFee,
  });

  @override
  Future<void> stopCollectRefundPaymentMethod(int operationId);

  @override
  Future<Refund> processRefund();
//endregion

//region Display information to customers
  @override
  Future<void> setReaderDisplay(Cart cart);

  @override
  Future<void> clearReaderDisplay();
//endregion

  static void _throwIfIsHostException(PlatformException exception) {
    if (exception.code.isEmpty) return;
    throw TerminalException(
      rawCode: exception.code,
      message: exception.message,
      details: exception.details,
    );
  }
}
