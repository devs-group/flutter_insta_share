package com.devsgroup.instashare;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.StrictMode;

import androidx.annotation.NonNull;

import java.io.File;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class InstasharePlugin implements FlutterPlugin, MethodCallHandler {
    private static final String INSTAGRAM_PACKAGE_NAME = "com.instagram.android";
    private MethodChannel channel;
    private Context context;

    private int resultDone = 0;
    private int errorWritingFile = 1; // Unused here
    private int errorSavingToPhotoAlbum = 2; // Unused here
    private int errorInstagramNotInstalled = 3;
    private int errorAccessingPhotos = 4; // Unused here

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        setupChannels(flutterPluginBinding.getFlutterEngine().getDartExecutor(), flutterPluginBinding.getApplicationContext());
    }

    // Old API Support
    public static void registerWith(Registrar registrar) {
        InstasharePlugin instasharePlugin = new InstasharePlugin();
        instasharePlugin.setupChannels(registrar.messenger(), registrar.context());
    }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        this.context = context;
        channel = new MethodChannel(messenger, "instashare");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("shareToFeedInstagram")) {
            PackageManager pm = context.getPackageManager();
            try {
                StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
                StrictMode.setVmPolicy(builder.build());
                pm.getPackageInfo(INSTAGRAM_PACKAGE_NAME, PackageManager.GET_ACTIVITIES);
                instagramShare(call.<String>argument("type"), call.<String>argument("path"));
                result.success(resultDone);
            } catch (PackageManager.NameNotFoundException e) {
                result.success(errorInstagramNotInstalled);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void openPlayStore() {
        try {
            final Uri playStoreUri = Uri.parse("market://details?id=" + InstasharePlugin.INSTAGRAM_PACKAGE_NAME);
            final Intent intent = new Intent(Intent.ACTION_VIEW, playStoreUri);
            context.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            final Uri playStoreUri = Uri.parse("https://play.google.com/store/apps/details?id=" + InstasharePlugin.INSTAGRAM_PACKAGE_NAME);
            final Intent intent = new Intent(Intent.ACTION_VIEW, playStoreUri);
            context.startActivity(intent);
        }
    }

    private void instagramShare(String type, String imagePath) {
        final File image = new File(imagePath);
        final Uri uri = Uri.fromFile(image);
        final Intent share = new Intent(Intent.ACTION_SEND);
        share.setType(type);
        share.setPackage(INSTAGRAM_PACKAGE_NAME);
        share.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        share.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        share.putExtra(Intent.EXTRA_STREAM, uri);
        context.startActivity(share);
    }
}
