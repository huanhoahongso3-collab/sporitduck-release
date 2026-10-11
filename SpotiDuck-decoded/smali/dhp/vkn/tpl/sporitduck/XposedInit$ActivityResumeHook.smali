.class public Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityResumeHook;
.super Lde/robv/android/xposed/XC_MethodHook;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ActivityResumeHook"
.end annotation


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V
    return-void
.end method


.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = { Ljava/lang/Throwable; }
    .end annotation

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;
    check-cast v0, Landroid/app/Activity;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v1
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v1
    const-string v2, "com.spotify.music.MainActivity"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :skip

    sput-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->activity:Landroid/app/Activity;
    invoke-static {v0}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->onResume(Landroid/app/Activity;)V

    # Trigger the Connect auto-switch on every resume of the main activity — not just on a
    # track change — so it works right away on a plain launcher open (no playback yet) and
    # after a warm reopen (process survived a Recents close). It only needs
    # SpotifyWebOverlay's own WebView (already loading open.spotify.com in the background
    # regardless of this) to have registered a "Web Player" device to tap -- WebPlayerCapture,
    # a second independent WebView that used to also be re-armed here, is retired: it
    # registered its own separate "Web Player" device, which was the actual cause of two
    # functional "Web Player" entries showing up in Spotify Connect.
    invoke-static {}, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->switchToWebPlayer()V

    :skip
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
