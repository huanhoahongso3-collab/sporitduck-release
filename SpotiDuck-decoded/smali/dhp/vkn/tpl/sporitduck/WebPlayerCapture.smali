.class public Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field private final app:Landroid/app/Application;

# Kept so destroy() can stop playback when Spotify's task is actually removed from
# Recents — this WebView is Application-scoped and otherwise outlives the Activity
# entirely, so audio kept playing through it even after the app appeared closed.
.field public static sWebView:Landroid/webkit/WebView;


.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->app:Landroid/app/Application;

    return-void
.end method


.method public run()V
    .registers 8

    :try_start_0

    # WebView wv = new WebView(app)
    new-instance v0, Landroid/webkit/WebView;
    iget-object v1, p0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->app:Landroid/app/Application;
    invoke-direct {v0, v1}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    # wv.setVisibility(View.GONE = 8)
    const/16 v1, 0x8
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setVisibility(I)V

    # WebSettings settings = wv.getSettings()
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;
    move-result-object v1

    # settings.setJavaScriptEnabled(true)
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    # settings.setDomStorageEnabled(true)
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    # settings.setUserAgentString(desktop Chrome UA)
    const-string v2, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    # wv.setWebViewClient(new WebPlayerCapture$Client(app))
    new-instance v1, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture$Client;
    iget-object v2, p0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->app:Landroid/app/Application;
    invoke-direct {v1, v2}, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture$Client;-><init>(Landroid/app/Application;)V
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    # wv.loadUrl("https://open.spotify.com")
    const-string v1, "https://open.spotify.com"
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    sput-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->sWebView:Landroid/webkit/WebView;

    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method


# Called from XposedInit$ActivityDestroyHook when Spotify's task is actually removed, so
# the hidden Web Player device doesn't keep playing audio after the app looks closed.
.method public static destroy()V
    .registers 2

    sget-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->sWebView:Landroid/webkit/WebView;
    if-eqz v0, :clear

    :try_start_1
    const-string v1, "about:blank"
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    invoke-virtual {v0}, Landroid/webkit/WebView;->onPause()V
    invoke-virtual {v0}, Landroid/webkit/WebView;->pauseTimers()V
    invoke-virtual {v0}, Landroid/webkit/WebView;->destroy()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    :catch_1

    :clear
    const/4 v0, 0x0
    sput-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->sWebView:Landroid/webkit/WebView;
    return-void
.end method


# Called from XposedInit$ActivityHook/ActivityResumeHook on every create/resume, not just
# from Application.onCreate. Application.onCreate only runs once per process, so after
# Spotify's task is removed (which calls destroy() above) and the app is reopened from the
# launcher WITHOUT the process having been killed, Application.onCreate never fires again
# and the hidden Web Player would otherwise never come back — this makes a warm reopen
# behave the same as a cold start. No-ops if already running or WebPlayerEnabled is off.
.method public static ensureRunning(Landroid/app/Application;)V
    .registers 6

    sget-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;->sWebView:Landroid/webkit/WebView;
    if-nez v0, :return
    if-eqz p0, :return

    :try_start_2
    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/PrefsClient;->readAll(Landroid/content/Context;)Landroid/os/Bundle;
    move-result-object v1
    const-string v2, "WebPlayerEnabled"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
    if-eqz v1, :return

    new-instance v1, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v2
    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v2, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;
    invoke-direct {v2, p0}, Ldhp/vkn/tpl/sporitduck/WebPlayerCapture;-><init>(Landroid/app/Application;)V
    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    :return
    return-void

    :catch_2
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
