package com.example.flutter_native_code_sample

import android.os.Bundle
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "battery"
    private val EVENT_CHANNEL = "counter"
    private val BASIC_MESSAGE_CHANNEL = "message"
    private var message: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("native_view", NativeViewFactory());

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            CounterHandler
        )

        val basicMessageChannel = BasicMessageChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BASIC_MESSAGE_CHANNEL,
            StringCodec.INSTANCE
        )
        basicMessageChannel.setMessageHandler { message, reply ->
            Log.d("Android", "Received message = $message")
            reply.reply("Reply from Android")
        }

        Handler().postDelayed({
            basicMessageChannel.send("Hello World from Android") { reply ->
                Log.d("Android", "$reply")
            }
        }, 500)

        MessageApi.setUp(flutterEngine.dartExecutor.binaryMessenger, object: MessageApi {
            override fun sendMessage(msg: Message) {
                message = msg.content
            }

            override fun receiveMessage(): Message {
                var msg = Message(message)
                return msg
            }
        })
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(
                null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )
            batteryLevel =
                intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(
                    BatteryManager.EXTRA_SCALE,
                    -1
                )
        }
        return batteryLevel
    }
}

object CounterHandler : EventChannel.StreamHandler {
    private val handler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var counter: Int = 0

    private val runnable: Runnable = object : Runnable {
        override fun run() {
            countUp()
        }
    }

    fun countUp() {
        eventSink?.success(counter++)
        handler.postDelayed(runnable, 1000)
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        handler.post(runnable)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        handler.removeCallbacks(runnable)
    }
}