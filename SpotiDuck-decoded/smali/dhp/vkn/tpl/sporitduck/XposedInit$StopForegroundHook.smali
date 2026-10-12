.class public Ldhp/vkn/tpl/sporitduck/XposedInit$StopForegroundHook;
.super Lde/robv/android/xposed/XC_MethodHook;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "StopForegroundHook"
.end annotation

# Suppresses Service.stopForeground() while our WebView session is alive.
#
# resumeTimers()/onResume() (SpotifyWebOverlay.refresh) only undo CPU-level throttling on
# an already-alive process; they can't recover from the process actually being killed.
# Spotify is only guaranteed elevated process priority while it holds an active foreground
# service + a playing MediaSession. Pausing playback typically lets Spotify's own
# foreground service relinquish that status soon after, dropping the whole process (our
# WebView along with it) to ordinary cached-background priority, where Android's
# background-process killer can and does reclaim it after a while -- exactly the "killed
# in background when no sound is playing, or just left for a while" symptom.
#
# This hooks the Android framework API directly rather than anything Spotify-internal, so
# it doesn't depend on reverse-engineering Spotify's exact playback-state-to-service
# plumbing: whichever of Spotify's own foreground services calls stopForeground() while we
# still need to survive just has that call silently dropped, keeping it (and the whole
# process) pinned at foreground priority for as long as our overlay's WebView exists.
#
# Trade-off: Spotify's playback notification stays visible/non-dismissable the whole time
# our WebView session is alive (this is the same cost every "stay alive in background" app
# pays -- there's no way to hold foreground-service priority on modern Android without a
# visible notification). It clears back to normal once the WebView is torn down
# (SpotifyWebOverlay.destroy(), e.g. on a real Recents close).


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V
    return-void
.end method


.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3
    .annotation system Ldalvik/annotation/Throws;
        value = { Ljava/lang/Throwable; }
    .end annotation

    :try_start_0
    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sWebView:Landroid/webkit/WebView;
    if-eqz v0, :allow

    # Skip the real stopForeground() call entirely (setResult() on a before-hook makes
    # Xposed treat the call as already handled).
    const/4 v1, 0x0
    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    :allow
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
