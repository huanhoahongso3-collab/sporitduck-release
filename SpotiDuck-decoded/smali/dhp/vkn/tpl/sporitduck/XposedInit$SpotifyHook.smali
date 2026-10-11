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

    # WebPlayerCapture used to be started here (a second, independent hidden WebView that
    # also loaded open.spotify.com whenever WebPlayerEnabled was on). It's retired: it
    # registered its own separate "Web Player" Spotify Connect device, duplicating the one
    # SpotifyWebOverlay's own WebView already registers (that one loads open.spotify.com
    # unconditionally in the background to support login/ShowWebView, regardless of this
    # toggle) -- hence two functional "Web Player" devices showing up in Spotify Connect.
    # WebPlayerAutoSwitch's UI automation just taps whichever "Web Player" row already
    # exists in the native Connect dialog, so it never needed WebPlayerCapture's device to
    # begin with -- SpotifyWebOverlay's own WebView is sufficient.

    return-void
.end method
