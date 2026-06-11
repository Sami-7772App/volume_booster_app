
package com.example.volume_booster_fresh

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AudioFocusPlugin : FlutterPlugin, MethodCallHandler, AudioManager.OnAudioFocusChangeListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var audioManager: AudioManager
    private var audioFocusRequest: AudioFocusRequest? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.volume.booster/audio_focus")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        println("AudioFocusPlugin: Attached to engine")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "requestAudioFocus" -> requestAudioFocus(result)
            "abandonAudioFocus" -> abandonAudioFocus(result)
            else -> result.notImplemented()
        }
    }

    private fun requestAudioFocus(result: Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
                    
                audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                    .setAudioAttributes(audioAttributes)
                    .setOnAudioFocusChangeListener(this)
                    .build()
                    
                val focusResult = audioManager.requestAudioFocus(audioFocusRequest!!)
                val hasFocus = focusResult == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
                result.success(hasFocus)
                println("AudioFocusPlugin: Audio focus requested, hasFocus=$hasFocus")
            } else {
                val focusResult = audioManager.requestAudioFocus(this, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)
                val hasFocus = focusResult == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
                result.success(hasFocus)
                println("AudioFocusPlugin: Audio focus requested (legacy), hasFocus=$hasFocus")
            }
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
            println("AudioFocusPlugin: Error requesting audio focus - ${e.message}")
        }
    }

    private fun abandonAudioFocus(result: Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                audioFocusRequest?.let {
                    audioManager.abandonAudioFocusRequest(it)
                }
            } else {
                audioManager.abandonAudioFocus(this)
            }
            result.success(true)
            println("AudioFocusPlugin: Audio focus abandoned")
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    override fun onAudioFocusChange(focusChange: Int) {
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS -> {
                println("AudioFocusPlugin: Audio focus LOST - Other app playing audio (YouTube/Spotify)")
                channel.invokeMethod("onAudioFocusChange", false)
            }
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> {
                println("AudioFocusPlugin: Audio focus LOST (transient)")
                channel.invokeMethod("onAudioFocusChange", false)
            }
            AudioManager.AUDIOFOCUS_GAIN -> {
                println("AudioFocusPlugin: Audio focus GAINED - No other audio playing")
                channel.invokeMethod("onAudioFocusChange", true)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                audioFocusRequest?.let {
                    audioManager.abandonAudioFocusRequest(it)
                }
            } else {
                audioManager.abandonAudioFocus(this)
            }
        } catch (e: Exception) {
            println("Error abandoning audio focus: ${e.message}")
        }
        println("AudioFocusPlugin: Detached from engine")
    }
}