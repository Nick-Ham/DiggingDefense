extends Node
class_name Util

static func safeConnect(signalToConnect : Signal, callableToConnect : Callable):
	if signalToConnect.is_connected(callableToConnect):
		signalToConnect.disconnect(callableToConnect)
	signalToConnect.connect(callableToConnect)
