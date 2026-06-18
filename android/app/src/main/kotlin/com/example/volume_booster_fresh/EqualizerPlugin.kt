package com.FutureDialLabs.Volume.Booster.Sound

import android.content.Context
import android.media.AudioManager
import android.media.audiofx.Equalizer
import android.media.audiofx.LoudnessEnhancer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class EqualizerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var audioManager: AudioManager
    private var equalizer: Equalizer? = null
    private var loudnessEnhancer: LoudnessEnhancer? = null
    private var sessionId: Int = 0
    private var currentGainDb: Int = 0

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.volume.booster/equalizer")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        println("EqualizerPlugin: Attached")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initEqualizer" -> initEqualizer(result)
            "setLoudnessBoost" -> setLoudnessBoost(call, result)
            "applyBoost" -> applyBoost(call, result)
            "disableEq" -> disableEq(result)
            "getCurrentGain" -> getCurrentGain(result)
            else -> result.notImplemented()
        }
    }

    private fun initEqualizer(result: Result) {
        try {
            sessionId = 0
            equalizer = Equalizer(0, sessionId)
            equalizer?.enabled = true
            loudnessEnhancer = LoudnessEnhancer(sessionId)
            loudnessEnhancer?.enabled = true
            result.success(true)
            println("EqualizerPlugin: Initialized - Can boost up to +60dB")
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun setLoudnessBoost(call: MethodCall, result: Result) {
        try {
            val percentage = call.argument<Int>("percent") ?: 100
            val gainDb = when {
                percentage >= 200 -> 60
                percentage >= 180 -> 54
                percentage >= 160 -> 48
                percentage >= 140 -> 42
                percentage >= 120 -> 36
                percentage >= 100 -> 0
                else -> 0
            }
            loudnessEnhancer?.setTargetGain(gainDb)
            loudnessEnhancer?.enabled = gainDb > 0
            currentGainDb = gainDb
            result.success(gainDb)
            println("EqualizerPlugin: ${percentage}% → +${gainDb}dB boost")
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun applyBoost(call: MethodCall, result: Result) {
        try {
            val percentage = call.argument<Int>("percent") ?: 100
            val gainDb = ((percentage - 100) * 0.6).toInt().coerceIn(0, 60)
            loudnessEnhancer?.setTargetGain(gainDb)
            loudnessEnhancer?.enabled = gainDb > 0
            currentGainDb = gainDb
            result.success(gainDb)
            println("EqualizerPlugin: Boost: +${gainDb}dB")
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun disableEq(result: Result) {
        try {
            loudnessEnhancer?.enabled = false
            equalizer?.enabled = false
            currentGainDb = 0
            result.success(true)
            println("EqualizerPlugin: Disabled")
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun getCurrentGain(result: Result) {
        result.success(currentGainDb)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        equalizer?.release()
        loudnessEnhancer?.release()
    }
}