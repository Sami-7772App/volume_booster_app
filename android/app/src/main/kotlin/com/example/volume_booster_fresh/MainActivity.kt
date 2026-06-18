package com.FutureDialLabs.Volume.Booster.Sound

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(MediaVolumePlugin())
        flutterEngine.plugins.add(SystemSoundPlugin())
        flutterEngine.plugins.add(EqualizerPlugin())
         flutterEngine.plugins.add(AudioFocusPlugin())
    }
}