.class public Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;
.super Ljava/lang/Object;

.field public static sDialog:Landroid/app/Dialog;
.field public static sWebView:Landroid/webkit/WebView;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# Called from XposedInit$ActivityHook after Spotify's MainActivity.onCreate.
# Creates the WebView overlay Dialog once (guarded by sDialog null-check).
.method public static create(Landroid/app/Activity;)V
    .registers 6

    # Guard: only create once
    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :do_create
    return-void

    :do_create
    :try_start_0

    # v0 = new Dialog(activity)
    new-instance v0, Landroid/app/Dialog;
    invoke-direct {v0, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    # Request no-title
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    # Set fullscreen window flag
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v1
    if-eqz v1, :window_done
    const v2, 0x400
    invoke-virtual {v1, v2, v2}, Landroid/view/Window;->setFlags(II)V
    :window_done

    # v1 = new WebView(activity)
    new-instance v1, Landroid/webkit/WebView;
    invoke-direct {v1, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    # Configure WebSettings
    invoke-virtual {v1}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;
    move-result-object v2

    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    const-string v3, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V

    # Accept third-party cookies (API 21+)
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v3, 0x15
    if-lt v2, v3, :skip_cookies
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v2
    const/4 v3, 0x1
    invoke-virtual {v2, v1, v3}, Landroid/webkit/CookieManager;->setAcceptThirdPartyCookies(Landroid/webkit/WebView;Z)V
    :skip_cookies

    # Attach WebViewClient
    new-instance v2, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;
    invoke-direct {v2, p0}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;-><init>(Landroid/app/Activity;)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    # Attach JS interface "__spd"
    new-instance v2, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$JsInterface;
    invoke-direct {v2, p0}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$JsInterface;-><init>(Landroid/content/Context;)V
    const-string v3, "__spd"
    invoke-virtual {v1, v2, v3}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    # dialog.setContentView(webView)
    invoke-virtual {v0, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    # Set MATCH_PARENT layout
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v2
    if-eqz v2, :layout_done
    const/4 v3, -0x1
    invoke-virtual {v2, v3, v3}, Landroid/view/Window;->setLayout(II)V
    :layout_done

    # Store statics
    sput-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    sput-object v1, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sWebView:Landroid/webkit/WebView;

    # Decide URL: check CookieManager for existing session
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v2
    const-string v3, "https://open.spotify.com"
    invoke-virtual {v2, v3}, Landroid/webkit/CookieManager;->getCookie(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2

    if-eqz v2, :load_login
    const-string v3, ""
    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :load_login

    # Has cookies → load player directly
    const-string v2, "https://open.spotify.com"
    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    goto :show_dialog

    :load_login
    const-string v2, "https://accounts.spotify.com/login"
    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    :show_dialog
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
