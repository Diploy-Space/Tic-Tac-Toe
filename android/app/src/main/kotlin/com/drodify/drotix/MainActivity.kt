package com.drodify.drotix

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.Locale

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Country for language + currency: SIM, then mobile network, then
        // device region. No permission needed.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "drotix/region")
            .setMethodCallHandler { call, result ->
                if (call.method != "countries") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val tm = getSystemService(TELEPHONY_SERVICE) as? TelephonyManager
                fun clean(v: String?) = v?.trim()?.uppercase(Locale.ROOT)
                    ?.takeIf { it.length == 2 }
                result.success(
                    mapOf(
                        "sim" to clean(tm?.simCountryIso),
                        "network" to clean(tm?.networkCountryIso),
                        "device" to clean(Locale.getDefault().country),
                    )
                )
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "drotix/app_update")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Android 8+: user must allow "Install unknown apps" for DROTIX.
                    "canInstall" -> result.success(
                        Build.VERSION.SDK_INT < Build.VERSION_CODES.O ||
                            packageManager.canRequestPackageInstalls()
                    )
                    "openInstallSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                                    Uri.parse("package:$packageName")
                                ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            )
                        }
                        result.success(null)
                    }
                    "installApk" -> {
                        val path = call.argument<String>("path")
                        val file = path?.let { File(it) }
                        if (file == null || !file.exists()) {
                            result.error("missing", "APK file not found", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val uri = FileProvider.getUriForFile(
                                this, "$packageName.update_provider", file
                            )
                            startActivity(
                                Intent(Intent.ACTION_VIEW)
                                    .setDataAndType(uri, "application/vnd.android.package-archive")
                                    .addFlags(
                                        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                            Intent.FLAG_ACTIVITY_NEW_TASK
                                    )
                            )
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("install_failed", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
