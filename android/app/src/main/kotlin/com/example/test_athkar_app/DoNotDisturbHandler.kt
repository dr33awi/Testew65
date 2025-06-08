package com.example.test_athkar_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Handler for Do Not Disturb related operations on Android
 */
class DoNotDisturbHandler(private val context: Context) : MethodChannel.MethodCallHandler {
    
    private var dndReceiver: BroadcastReceiver? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isDoNotDisturbEnabled" -> {
                result.success(isInDoNotDisturbMode())
            }
            "requestDoNotDisturbPermission" -> {
                result.success(requestNotificationPolicyAccess())
            }
            "canBypassDoNotDisturb" -> {
                result.success(canBypassDoNotDisturb())
            }
            "configureNotificationChannelsForDoNotDisturb" -> {
                configureNotificationChannelsForDoNotDisturb()
                result.success(true)
            }
            "isInDoNotDisturbMode" -> { // Add compatibility with existing code
                result.success(isInDoNotDisturbMode())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * Check if the device is currently in Do Not Disturb mode
     */
    private fun isInDoNotDisturbMode(): Boolean {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            notificationManager.currentInterruptionFilter != NotificationManager.INTERRUPTION_FILTER_ALL
        } else {
            try {
                val zenMode = Settings.Global.getInt(context.contentResolver, "zen_mode")
                zenMode != 0
            } catch (e: Exception) {
                false
            }
        }
    }

    /**
     * Check if the app has permission to bypass Do Not Disturb
     */
    private fun canBypassDoNotDisturb(): Boolean {
        // For Android O and above, check if any notification channel can bypass DND
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channels = notificationManager.notificationChannels

            for (channel in channels) {
                if (channel.canBypassDnd()) {
                    return true
                }
            }
            return false
        } else {
            // For earlier versions, check if notification policy access is granted
            val notificationManager = NotificationManagerCompat.from(context)
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                notificationManager.areNotificationsEnabled() && 
                        (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).isNotificationPolicyAccessGranted
            } else {
                notificationManager.areNotificationsEnabled()
            }
        }
    }
    
    /**
     * Request permission to access notification policy (required for DND access)
     */
    private fun requestNotificationPolicyAccess(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            // Check if already granted
            if (notificationManager.isNotificationPolicyAccessGranted) {
                return true
            }
            
            // Request permission
            try {
                val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
                return true
            } catch (e: Exception) {
                return false
            }
        }
        return false
    }

    /**
     * Configure notification channels to bypass Do Not Disturb
     */
    fun configureNotificationChannelsForDoNotDisturb() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            // Configure main channel
            configureChannelForDoNotDisturb(
                notificationManager,
                "athkar_app_channel",
                "أذكار",
                "تنبيهات الأذكار",
                NotificationManager.IMPORTANCE_HIGH,
                true
            )
            
            // Configure morning athkar channel
            configureChannelForDoNotDisturb(
                notificationManager,
                "athkar_app_channel_morning",
                "أذكار الصباح",
                "تنبيهات أذكار الصباح",
                NotificationManager.IMPORTANCE_HIGH,
                true
            )
            
            // Configure evening athkar channel
            configureChannelForDoNotDisturb(
                notificationManager,
                "athkar_app_channel_evening",
                "أذكار المساء",
                "تنبيهات أذكار المساء",
                NotificationManager.IMPORTANCE_HIGH,
                true
            )
            
            // Configure sleep athkar channel
            configureChannelForDoNotDisturb(
                notificationManager,
                "athkar_app_channel_sleep",
                "أذكار النوم",
                "تنبيهات أذكار النوم",
                NotificationManager.IMPORTANCE_DEFAULT,
                false // Sleep notifications should respect DND
            )
            
            // Configure prayer channels
            val prayerNames = arrayOf("fajr", "dhuhr", "asr", "maghrib", "isha")
            val prayerArabicNames = arrayOf("الفجر", "الظهر", "العصر", "المغرب", "العشاء")
            
            for (i in prayerNames.indices) {
                configureChannelForDoNotDisturb(
                    notificationManager,
                    "athkar_app_channel_${prayerNames[i]}",
                    "صلاة ${prayerArabicNames[i]}",
                    "تنبيهات صلاة ${prayerArabicNames[i]}",
                    NotificationManager.IMPORTANCE_HIGH,
                    true
                )
            }
            
            // Configure test channel
            configureChannelForDoNotDisturb(
                notificationManager,
                "athkar_app_channel_test",
                "اختبار الأذكار",
                "قناة اختبار إشعارات الأذكار",
                NotificationManager.IMPORTANCE_HIGH,
                false
            )
        }
    }
    
    /**
     * Configure a specific notification channel for bypassing Do Not Disturb
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun configureChannelForDoNotDisturb(
        notificationManager: NotificationManager,
        channelId: String,
        channelName: String,
        channelDescription: String,
        importance: Int,
        bypassDnd: Boolean
    ) {
        var channel = notificationManager.getNotificationChannel(channelId)
        
        // Create channel if it doesn't exist
        if (channel == null) {
            channel = NotificationChannel(channelId, channelName, importance)
            channel.description = channelDescription
        } else {
            // Update existing channel
            channel.importance = importance
        }
        
        // Configure bypass DND
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            channel.setAllowBubbles(true)
        }
        channel.setBypassDnd(bypassDnd)
        channel.enableVibration(true)
        channel.enableLights(true)
        
        // Save the channel
        notificationManager.createNotificationChannel(channel)
    }
    
    /**
     * Get a StreamHandler for receiving Do Not Disturb status changes
     */
    fun getDndStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                registerDndReceiver()
                
                // Send initial state
                events?.success(isInDoNotDisturbMode())
            }
            
            override fun onCancel(arguments: Any?) {
                unregisterDndReceiver()
                eventSink = null
            }
        }
    }
    
    /**
     * Register a broadcast receiver for DND status changes
     */
    private fun registerDndReceiver() {
        if (dndReceiver != null) {
            return
        }
        
        dndReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                eventSink?.success(isInDoNotDisturbMode())
            }
        }
        
        val filter = IntentFilter(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED)
        context.registerReceiver(dndReceiver, filter)
    }
    
    /**
     * Unregister the DND broadcast receiver
     */
    private fun unregisterDndReceiver() {
        if (dndReceiver != null) {
            try {
                context.unregisterReceiver(dndReceiver)
            } catch (e: Exception) {
                // Ignore if receiver wasn't registered
            }
            dndReceiver = null
        }
    }
    
    /**
     * Notify current DND status to listeners
     */
    fun notifyDndStatusChange() {
        eventSink?.success(isInDoNotDisturbMode())
    }
    
    /**
     * Clean up resources when no longer needed
     */
    fun dispose() {
        unregisterDndReceiver()
        eventSink = null
    }
}