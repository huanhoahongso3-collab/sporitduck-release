.class public Ldhp/vkn/tpl/sporitduck/XposedInit;
.super Ljava/lang/Object;
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    # if (!lpparam.packageName.equals("com.spotify.music")) return
    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;
    const-string v1, "com.spotify.music"
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :return

    # --- Always: hook Application.onCreate for toast + optional web player ---
    const/4 v0, 0x1
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$SpotifyHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$SpotifyHook;-><init>()V

    const/4 v2, 0x0
    aput-object v1, v0, v2

    const-class v3, Landroid/app/Application;
    const-string v4, "onCreate"
    invoke-static {v3, v4, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Hook com.spotify.music.MainActivity.onCreate for WebView overlay ---
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityHook;-><init>()V

    const-class v2, Landroid/os/Bundle;
    const/4 v3, 0x0
    aput-object v2, v0, v3

    const/4 v3, 0x1
    aput-object v1, v0, v3

    const-class v4, Landroid/app/Activity;
    const-string v5, "onCreate"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Hook Activity.onResume to re-show overlay when user returns to Spotify ---
    const/4 v0, 0x1
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityResumeHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityResumeHook;-><init>()V

    const/4 v2, 0x0
    aput-object v1, v0, v2

    const-class v4, Landroid/app/Activity;
    const-string v5, "onResume"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Hook Activity.onDestroy to clean up overlay when Spotify is closed ---
    const/4 v0, 0x1
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityDestroyHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityDestroyHook;-><init>()V

    const/4 v2, 0x0
    aput-object v1, v0, v2

    const-class v4, Landroid/app/Activity;
    const-string v5, "onDestroy"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Hook MediaSession.setPlaybackState to force local device volume ---
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$MediaSessionVolumeHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$MediaSessionVolumeHook;-><init>()V

    const-class v2, Landroid/media/session/PlaybackState;
    const/4 v3, 0x0
    aput-object v2, v0, v3

    const/4 v3, 0x1
    aput-object v1, v0, v3

    const-class v4, Landroid/media/session/MediaSession;
    const-string v5, "setPlaybackState"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Hook MediaSession.setMetadata to drive the auto web-player-switch. Registered
    #     unconditionally like the DNS hook; WebPlayerAutoSwitch checks WebPlayerEnabled
    #     itself (via PrefsProvider) on every track change. ---
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$MetadataHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$MetadataHook;-><init>()V

    const-class v2, Landroid/media/MediaMetadata;
    const/4 v3, 0x0
    aput-object v2, v0, v3

    const/4 v3, 0x1
    aput-object v1, v0, v3

    const-class v4, Landroid/media/session/MediaSession;
    const-string v5, "setMetadata"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Suppress Service.stopForeground() while our WebView is alive, so whichever
    #     foreground service Spotify already runs keeps the process at elevated priority
    #     instead of downgrading on pause and letting Android kill/freeze the background
    #     process (and our WebView with it). Two overloads exist across API levels; each
    #     registered independently so a missing one on this API level doesn't stop the
    #     other from being hooked. ---
    :try_start_sfh_bool
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/Object;
    sget-object v2, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;
    const/4 v3, 0x0
    aput-object v2, v0, v3
    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$StopForegroundHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$StopForegroundHook;-><init>()V
    const/4 v3, 0x1
    aput-object v1, v0, v3
    const-class v4, Landroid/app/Service;
    const-string v5, "stopForeground"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_sfh_bool
    .catch Ljava/lang/Throwable; {:try_start_sfh_bool .. :try_end_sfh_bool} :catch_sfh_bool
    goto :sfh_int

    :catch_sfh_bool
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :sfh_int
    :try_start_sfh_int
    const/4 v0, 0x2
    new-array v0, v0, [Ljava/lang/Object;
    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
    const/4 v3, 0x0
    aput-object v2, v0, v3
    new-instance v1, Ldhp/vkn/tpl/sporitduck/XposedInit$StopForegroundHook;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/XposedInit$StopForegroundHook;-><init>()V
    const/4 v3, 0x1
    aput-object v1, v0, v3
    const-class v4, Landroid/app/Service;
    const-string v5, "stopForeground"
    invoke-static {v4, v5, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_sfh_int
    .catch Ljava/lang/Throwable; {:try_start_sfh_int .. :try_end_sfh_int} :catch_sfh_int
    goto :sfh_done

    :catch_sfh_int
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :sfh_done

    # --- Always register the DNS blocker hook; it checks AdBlockEnabled itself on every
    #     call (via PrefsProvider) since no Activity/Application context is available yet
    #     at this point to query it just once here. ---
    const-string v6, "java.net.InetAddress"
    const/4 v7, 0x0           # null = bootstrap ClassLoader
    const-string v8, "getAllByName"
    const-class v9, Ljava/lang/String;
    new-instance v10, Ldhp/vkn/tpl/sporitduck/DnsAdBlock;
    invoke-direct {v10}, Ldhp/vkn/tpl/sporitduck/DnsAdBlock;-><init>()V
    filled-new-array {v9, v10}, [Ljava/lang/Object;
    move-result-object v9
    invoke-static {v6, v7, v8, v9}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    :return
    return-void
.end method
