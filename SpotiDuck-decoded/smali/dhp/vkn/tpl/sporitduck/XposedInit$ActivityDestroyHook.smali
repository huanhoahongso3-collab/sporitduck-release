.class public Ldhp/vkn/tpl/sporitduck/XposedInit$ActivityDestroyHook;
.super Lde/robv/android/xposed/XC_MethodHook;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ActivityDestroyHook"
.end annotation


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V
    return-void
.end method


.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 9
    .annotation system Ldalvik/annotation/Throws;
        value = { Ljava/lang/Throwable; }
    .end annotation

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;
    check-cast v0, Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isTaskRoot()Z
    move-result v1
    if-eqz v1, :skip

    invoke-static {}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->destroy()V
    invoke-static {}, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->destroy()V

    # Optional: fully terminate the host app's own process once its task is actually
    # removed from Recents, gated by ForceStopOnRecentsClose. We're already running
    # inside that process ourselves (that's how Xposed hooks work), so
    # Process.killProcess(myPid()) ends it directly -- no hardcoded package name, works
    # whatever app this module happens to be injected into.
    invoke-virtual {v0}, Landroid/app/Activity;->getApplication()Landroid/app/Application;
    move-result-object v2
    invoke-static {v2}, Ldhp/vkn/tpl/sporitduck/PrefsClient;->readAll(Landroid/content/Context;)Landroid/os/Bundle;
    move-result-object v2
    const-string v3, "ForceStopOnRecentsClose"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    if-eqz v2, :skip

    invoke-static {}, Landroid/os/Process;->myPid()I
    move-result v2
    invoke-static {v2}, Landroid/os/Process;->killProcess(I)V

    :skip
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
