package com.adipurwanto.glukotrack

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * FlutterFragmentActivity, bukan FlutterActivity: `local_auth` menampilkan
 * BiometricPrompt lewat FragmentManager (PRD F-08 AC1).
 */
class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // PRD F-08 AC3: FLAG_SECURE menyembunyikan isi layar di app switcher
        // (dan memblokir screenshot). Hanya dinyalakan saat kunci aplikasi
        // aktif, supaya pengguna tanpa kunci tetap bisa men-screenshot
        // grafik untuk ditunjukkan ke dokter.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "glukotrack/secure_screen")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setSecure" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        if (enabled) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
