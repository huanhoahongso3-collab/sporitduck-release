.class public final Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;
.super Ljava/lang/Object;

# Ported from the reference Spotify-web-player-switch implementation: when the
# now-playing track changes, open the native "Connect to a device" dialog and tap the
# Web Player row, so the module actually does what WebPlayerEnabled's label promises
# instead of only silently capturing a device ID in the background.

.field public static activity:Landroid/app/Activity;

.field public static lastTrackId:Ljava/lang/String;

.field public static lastSwitchMs:J


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public static switchToWebPlayer()V
    .registers 8

    sget-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->activity:Landroid/app/Activity;
    if-eqz v0, :return

    :try_start_0
    invoke-static {v0}, Ldhp/vkn/tpl/sporitduck/PrefsClient;->readAll(Landroid/content/Context;)Landroid/os/Bundle;
    move-result-object v1
    const-string v2, "WebPlayerEnabled"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
    if-eqz v1, :return

    # Cooldown: skip if the last switch was less than 15 seconds ago
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v1
    sget-wide v3, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->lastSwitchMs:J
    sub-long/2addr v1, v3
    const-wide/16 v3, 0x3a98
    cmp-long v5, v1, v3
    if-ltz v5, :return

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v1
    sput-wide v1, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->lastSwitchMs:J

    new-instance v1, Ldhp/vkn/tpl/sporitduck/ClickDevicesButtonRunnable;
    invoke-direct {v1}, Ldhp/vkn/tpl/sporitduck/ClickDevicesButtonRunnable;-><init>()V
    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    const-string v1, "[SPD] switchToWebPlayer queued"
    invoke-static {v1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :return
    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
