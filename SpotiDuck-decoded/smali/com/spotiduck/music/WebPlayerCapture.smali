.class public Lcom/spotiduck/music/WebPlayerCapture;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field private final app:Landroid/app/Application;


.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/spotiduck/music/WebPlayerCapture;->app:Landroid/app/Application;

    return-void
.end method


.method public run()V
    .registers 8

    :try_start_0

    # WebView wv = new WebView(app)
    new-instance v0, Landroid/webkit/WebView;
    iget-object v1, p0, Lcom/spotiduck/music/WebPlayerCapture;->app:Landroid/app/Application;
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
    new-instance v1, Lcom/spotiduck/music/WebPlayerCapture$Client;
    iget-object v2, p0, Lcom/spotiduck/music/WebPlayerCapture;->app:Landroid/app/Application;
    invoke-direct {v1, v2}, Lcom/spotiduck/music/WebPlayerCapture$Client;-><init>(Landroid/app/Application;)V
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    # wv.loadUrl("https://open.spotify.com")
    const-string v1, "https://open.spotify.com"
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
