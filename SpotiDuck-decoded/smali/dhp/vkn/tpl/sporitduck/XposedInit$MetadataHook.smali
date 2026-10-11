.class public Ldhp/vkn/tpl/sporitduck/XposedInit$MetadataHook;
.super Lde/robv/android/xposed/XC_MethodHook;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "MetadataHook"
.end annotation

# Hooked onto MediaSession.setMetadata: whenever the now-playing track id changes,
# triggers WebPlayerAutoSwitch to open the Devices dialog and tap the Web Player row.


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V
    return-void
.end method


.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = { Ljava/lang/Throwable; }
    .end annotation

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;
    const/4 v1, 0x0
    aget-object v0, v0, v1
    if-eqz v0, :return

    check-cast v0, Landroid/media/MediaMetadata;
    const-string v1, "android.media.metadata.MEDIA_ID"
    invoke-virtual {v0, v1}, Landroid/media/MediaMetadata;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :return

    const-string v2, "spotify:track:"
    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :store

    const/16 v3, 0xe
    invoke-virtual {v1, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v1

    :store
    # Compare old vs new track id; only switch device when the track actually changed
    sget-object v2, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->lastTrackId:Ljava/lang/String;
    sput-object v1, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->lastTrackId:Ljava/lang/String;

    if-eqz v2, :do_switch
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :return

    :do_switch
    invoke-static {}, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->switchToWebPlayer()V

    :return
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
