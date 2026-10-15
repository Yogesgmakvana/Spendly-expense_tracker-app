package com.spendly.app.spendly

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.spendly.app/biometrics"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openFile" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        try {
                            val file = File(filePath)
                            if (file.exists()) {
                                val uri: Uri = FileProvider.getUriForFile(
                                    this,
                                    "${applicationContext.packageName}.fileprovider",
                                    file
                                )
                                val mimeType = when {
                                    filePath.endsWith(".pdf", ignoreCase = true) -> "application/pdf"
                                    filePath.endsWith(".csv", ignoreCase = true) -> "text/csv"
                                    filePath.endsWith(".json", ignoreCase = true) -> "application/json"
                                    else -> "*/*"
                                }
                                val intent = Intent(Intent.ACTION_VIEW).apply {
                                    setDataAndType(uri, mimeType)
                                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }
                                val chooser = Intent.createChooser(intent, "Open File With...")
                                chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(chooser)
                                result.success(true)
                            } else {
                                result.error("FILE_NOT_FOUND", "File does not exist: $filePath", null)
                            }
                        } catch (e: Exception) {
                            result.error("OPEN_FAILED", e.message, null)
                        }
                    } else {
                        result.error("INVALID_PATH", "Path is null", null)
                    }
                }
                "canAuthenticate" -> {
                    val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
                    val canAuth = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        keyguardManager.isDeviceSecure
                    } else {
                        true
                    }
                    result.success(canAuth)
                }
                "authenticate" -> {
                    val title = call.argument<String>("title") ?: "Spendly Security Lock"
                    val subtitle = call.argument<String>("subtitle") ?: "Scan Fingerprint or Face ID to unlock"

                    val executor = ContextCompat.getMainExecutor(this)
                    val biometricPrompt = BiometricPrompt(this, executor,
                        object : BiometricPrompt.AuthenticationCallback() {
                            override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                                super.onAuthenticationSucceeded(authResult)
                                result.success(true)
                            }

                            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                                super.onAuthenticationError(errorCode, errString)
                                result.success(false)
                            }

                            override fun onAuthenticationFailed() {
                                super.onAuthenticationFailed()
                                result.success(false)
                            }
                        })

                    val promptInfo = BiometricPrompt.PromptInfo.Builder()
                        .setTitle(title)
                        .setSubtitle(subtitle)
                        .setNegativeButtonText("Use 4-Digit PIN")
                        .build()

                    biometricPrompt.authenticate(promptInfo)
                }
                else -> result.notImplemented()
            }
        }
    }
}
