package com.example.volume_booster_fresh

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MediaVolumePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var audioManager: AudioManager

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.volume.booster/media_volume")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        println("MediaVolumePlugin: Attached to engine")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getMaxVolume" -> getMaxVolume(result)
            "getCurrentVolume" -> getCurrentVolume(result)
            "setVolume" -> setVolume(call, result)
            "getStreamType" -> result.success(AudioManager.STREAM_MUSIC.toString())
            else -> result.notImplemented()
        }
    }

    private fun getMaxVolume(result: Result) {
        try {
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            println("MediaVolumePlugin: Max volume = $maxVolume")
            result.success(maxVolume)
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun getCurrentVolume(result: Result) {
        try {
            val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
            println("MediaVolumePlugin: Current volume = $currentVolume")
            result.success(currentVolume)
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun setVolume(call: MethodCall, result: Result) {
        try {
            val volume = call.argument<Int>("volume") ?: 0
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val clampedVolume = volume.coerceIn(0, maxVolume)
            
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, clampedVolume, 0)
            println("MediaVolumePlugin: Volume set to $clampedVolume / $maxVolume")
            result.success(clampedVolume)
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        println("MediaVolumePlugin: Detached from engine")
    }
}