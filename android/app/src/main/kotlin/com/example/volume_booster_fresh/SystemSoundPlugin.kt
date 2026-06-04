package com.example.volume_booster_fresh

import android.content.Context
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SystemSoundPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var mediaPlayer: MediaPlayer? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.volume.booster/sounds")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        println("SystemSoundPlugin: Attached to engine")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        println("SystemSoundPlugin: Received method call - ${call.method}")
        when (call.method) {
            "playRingtone" -> playRingtone(result)
            "playAlarm" -> playAlarm(result)
            "playNotification" -> playNotification(result)
            "stopSound" -> stopSound(result)
            else -> result.notImplemented()
        }
    }

    private fun playRingtone(result: Result) {
        try {
            stopCurrentPlayback()
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
            println("SystemSoundPlugin: Playing ringtone from URI: $uri")
            mediaPlayer = MediaPlayer().apply {
                setDataSource(context, uri)
                prepare()
                start()
                setOnCompletionListener { stopCurrentPlayback() }
            }
            result.success(true)
        } catch (e: Exception) {
            println("SystemSoundPlugin: Error playing ringtone - ${e.message}")
            result.error("PLAY_ERROR", e.message, null)
        }
    }

    private fun playAlarm(result: Result) {
        try {
            stopCurrentPlayback()
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            println("SystemSoundPlugin: Playing alarm from URI: $uri")
            mediaPlayer = MediaPlayer().apply {
                setDataSource(context, uri)
                prepare()
                start()
                setOnCompletionListener { stopCurrentPlayback() }
            }
            result.success(true)
        } catch (e: Exception) {
            println("SystemSoundPlugin: Error playing alarm - ${e.message}")
            result.error("PLAY_ERROR", e.message, null)
        }
    }

    private fun playNotification(result: Result) {
        try {
            stopCurrentPlayback()
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            println("SystemSoundPlugin: Playing notification from URI: $uri")
            mediaPlayer = MediaPlayer().apply {
                setDataSource(context, uri)
                prepare()
                start()
                setOnCompletionListener { stopCurrentPlayback() }
            }
            result.success(true)
        } catch (e: Exception) {
            println("SystemSoundPlugin: Error playing notification - ${e.message}")
            result.error("PLAY_ERROR", e.message, null)
        }
    }

    private fun stopSound(result: Result) {
        stopCurrentPlayback()
        result.success(true)
    }

    private fun stopCurrentPlayback() {
        mediaPlayer?.let {
            if (it.isPlaying) {
                it.stop()
            }
            it.release()
            mediaPlayer = null
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stopCurrentPlayback()
        println("SystemSoundPlugin: Detached from engine")
    }
}