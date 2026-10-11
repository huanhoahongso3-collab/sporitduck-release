.class public Ldhp/vkn/tpl/sporitduck/XposedInit$SpotifyHook;
.super Lde/robv/android/xposed/XC_MethodHook;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "SpotifyHook"
.end annotation


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    # Application app = (Application) param.thisObject
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;
    check-cast v0, Landroid/app/Application;

    # Handler handler = new Handler(Looper.getMainLooper())
    new-instance v1, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    # Always: post ToastRunner
    new-instance v2, Ldhp/vkn/tpl/sporitduck/XposedInit$ToastRunner;
    invoke-direct {v2, v0}, Ldhp/vkn/tpl/sporitduck/XposedInit$ToastRunner;-><init>(Landroid/app/Application;)V
    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    # Read prefs to check WebPlayerEnabled (via PrefsProvider — XSharedPreferences can't
    # read cross-process on modern Android)
    invoke-static {v0}, Ldhp/vkn/tpl/sporitduck/PrefsClient;->readAll(Landroid/content/Context;)Landroid/os/Bundle;
    move-result-object v3

    const-string v4, "WebPlayerEnabled"
    const/4 v5, 0x0
    invoke-virtual {v3, v4, v5}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4
    if-eqz v4, :done

    # If WebPlayerEnabled: post WebPlayerCapture to start hidden WebView
    new-instance v3, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;
    invoke-direct {v3, v0}, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;-><init>(Landroid/app/Application;)V
    invoke-virtual {v1, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :done
    return-void
.end method
