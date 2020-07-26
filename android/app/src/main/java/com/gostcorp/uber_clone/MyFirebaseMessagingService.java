package com.gostcorp.uber_clone;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Random;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage){
        try{
            Log.v("Messaging Service", "From: " + remoteMessage.getFrom());
            createNotificationChannel();

            // Create an Intent for the activity you want to start
            Intent resultIntent = new Intent(this, MainActivity.class);
            resultIntent.putExtra("route","chat_screen");
            TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
            stackBuilder.addNextIntentWithParentStack(resultIntent);
            PendingIntent resultPendingIntent =
                    stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);

            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,getString(R.string.message_channel))
                    .setSmallIcon(R.drawable.car)
                    .setContentTitle(remoteMessage.getData().get("title"))
                    .setContentText(remoteMessage.getData().get("body"))
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setContentIntent(resultPendingIntent)
                    .setAutoCancel(true);
            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
            Random random = new Random();
            int id = random.nextInt(1000);
            notificationManager.notify(id,builder.build());
        }catch(Exception e){
            Log.v("Messaging Service",e.getMessage());
        }
    }

    @Override
    public void onNewToken(String token) {
        Log.d("Messaging Service", "Refreshed token: " + token);
    }

    private void createNotificationChannel(){
        if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
            CharSequence name = getString(R.string.message_channel);
            String description = "default message channel";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel(getString(R.string.message_channel),name,importance);
            channel.setDescription(description);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
}
