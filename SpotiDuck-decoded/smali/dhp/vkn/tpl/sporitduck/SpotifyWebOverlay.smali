.class public Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;
.super Ljava/lang/Object;

.field public static sDialog:Landroid/app/Dialog;
.field public static sWebView:Landroid/webkit/WebView;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# Called from XposedInit$ActivityDestroyHook when Spotify's MainActivity is destroyed.
.method public static destroy()V
    .registers 2

    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :clear

    :try_start_0
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0

    :clear
    const/4 v0, 0x0
    sput-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    sput-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sWebView:Landroid/webkit/WebView;
    return-void
.end method


# Called from XposedInit$ActivityResumeHook after Spotify's MainActivity.onResume.
# Re-shows the dialog if it was created but hidden (e.g. user backgrounded Spotify).
.method public static onResume(Landroid/app/Activity;)V
    .registers 3

    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :create_new
    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->refresh(Landroid/app/Activity;)V
    goto :done

    :create_new
    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->create(Landroid/app/Activity;)V

    :done
    return-void
.end method


# Called every onResume once the overlay already exists (process wasn't killed).
# Re-checks clear_count/ShowWebView so Clear Data and the ShowWebView toggle take
# effect immediately instead of requiring Spotify's process to be fully killed.
.method public static refresh(Landroid/app/Activity;)V
    .registers 10

    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :return
    sget-object v1, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sWebView:Landroid/webkit/WebView;
    if-eqz v1, :return

    :try_start_0
    # Read module's clear_count
    new-instance v2, Lde/robv/android/xposed/XSharedPreferences;
    const-string v3, "dhp.vkn.tpl.sporitduck"
    const-string v4, "dhp.vkn.tpl.sporitduck_preferences"
    invoke-direct {v2, v3, v4}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v2}, Lde/robv/android/xposed/XSharedPreferences;->reload()V
    const-string v3, "clear_count"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2    # v2 = module clear_count

    const-string v3, "spotiduck_overlay"
    const/4 v4, 0x0
    invoke-virtual {p0, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3    # v3 = Spotify's own spotiduck_overlay prefs
    const-string v4, "last_handled_count"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v4    # v4 = last_handled_count

    if-eq v2, v4, :check_showwebview    # no pending clear

    # Pending clear request: persist handled count, reset logged_in, wipe WebView session
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const-string v4, "last_handled_count"
    invoke-interface {v3, v4, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    const-string v4, "logged_in"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v3
    const/4 v4, 0x0
    invoke-virtual {v3, v4}, Landroid/webkit/CookieManager;->removeAllCookies(Landroid/webkit/ValueCallback;)V
    invoke-virtual {v3}, Landroid/webkit/CookieManager;->flush()V

    const/4 v3, 0x1
    invoke-virtual {v1, v3}, Landroid/webkit/WebView;->clearCache(Z)V
    invoke-virtual {v1}, Landroid/webkit/WebView;->clearFormData()V
    invoke-virtual {v1}, Landroid/webkit/WebView;->clearHistory()V

    const-string v3, "https://accounts.spotify.com/login"
    invoke-virtual {v1, v3}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V
    goto :return

    :check_showwebview
    new-instance v2, Lde/robv/android/xposed/XSharedPreferences;
    const-string v3, "dhp.vkn.tpl.sporitduck"
    const-string v4, "dhp.vkn.tpl.sporitduck_preferences"
    invoke-direct {v2, v3, v4}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v2}, Lde/robv/android/xposed/XSharedPreferences;->reload()V
    const-string v3, "ShowWebView"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    if-eqz v3, :check_hide
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V
    goto :return

    :check_hide
    # ShowWebView off: if the dialog is only showing because of a previous ShowWebView session
    # and the user is already logged in, hide it again (player keeps running in background).
    const-string v2, "spotiduck_overlay"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "logged_in"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    if-eqz v3, :return
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :return
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method


# Called from XposedInit$ActivityHook after Spotify's MainActivity.onCreate.
# Creates the WebView overlay Dialog once (guarded by sDialog null-check).
.method public static create(Landroid/app/Activity;)V
    .registers 10

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

    # Set fullscreen + hardware-accelerated window flags
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v1
    if-eqz v1, :window_done
    const v2, 0x1000400    # FLAG_HARDWARE_ACCELERATED | FLAG_FULLSCREEN
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

    # Allow mixed content (needed for Spotify CDN)
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setMixedContentMode(I)V

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

    # Attach WebChromeClient — grants DRM/EME permission requests
    new-instance v2, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$ChromeClient;
    invoke-direct {v2}, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$ChromeClient;-><init>()V
    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V

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

    # Check if user requested a data clear (clear_count in module prefs vs last_handled_count in Spotify's prefs)
    new-instance v2, Lde/robv/android/xposed/XSharedPreferences;
    const-string v3, "dhp.vkn.tpl.sporitduck"
    const-string v4, "dhp.vkn.tpl.sporitduck_preferences"
    invoke-direct {v2, v3, v4}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v2}, Lde/robv/android/xposed/XSharedPreferences;->reload()V
    const-string v3, "clear_count"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2    # v2 = module clear_count

    const-string v3, "spotiduck_overlay"
    const/4 v4, 0x0
    invoke-virtual {p0, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3    # v3 = Spotify's own spotiduck_overlay prefs
    const-string v4, "last_handled_count"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v4    # v4 = Spotify's last_handled_count

    if-eq v2, v4, :check_cookies    # counts match → no pending clear

    # New clear request: update handled count in Spotify's own prefs, clear WebView cookies
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const-string v4, "last_handled_count"
    invoke-interface {v3, v4, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    # Also reset logged_in so login overlay appears
    const-string v4, "logged_in"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v2
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/webkit/CookieManager;->removeAllCookies(Landroid/webkit/ValueCallback;)V
    goto :load_login

    :check_cookies
    # If ShowWebView is enabled, always show login overlay regardless of session
    new-instance v2, Lde/robv/android/xposed/XSharedPreferences;
    const-string v3, "dhp.vkn.tpl.sporitduck"
    const-string v4, "dhp.vkn.tpl.sporitduck_preferences"
    invoke-direct {v2, v3, v4}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v2}, Lde/robv/android/xposed/XSharedPreferences;->reload()V
    const-string v3, "ShowWebView"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    if-nez v3, :load_login

    # Check logged_in flag in Spotify's own prefs (set by JsInterface when login completes)
    const-string v2, "spotiduck_overlay"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "logged_in"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    if-eqz v3, :load_login    # not logged in → show login overlay

    # Logged in and ShowWebView=off → load player in background, no overlay
    const-string v2, "https://open.spotify.com"
    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    goto :skip_show

    :load_login
    const-string v2, "https://accounts.spotify.com/login"
    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    :skip_show

    # Toast: "Web player loading..."
    const-string v3, "SpotiDuck: Web player loading..."
    const/4 v4, 0x0
    invoke-static {p0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    # Debug toast if DebugEnabled
    new-instance v6, Lde/robv/android/xposed/XSharedPreferences;
    const-string v7, "dhp.vkn.tpl.sporitduck"
    const-string v8, "dhp.vkn.tpl.sporitduck_preferences"
    invoke-direct {v6, v7, v8}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v6}, Lde/robv/android/xposed/XSharedPreferences;->reload()V
    const-string v7, "DebugEnabled"
    const/4 v8, 0x0
    invoke-interface {v6, v7, v8}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v7
    if-eqz v7, :try_end_0
    const-string v6, "SPD DBG: Overlay shown"
    const/4 v7, 0x0
    invoke-static {p0, v6, v7}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v6
    invoke-virtual {v6}, Landroid/widget/Toast;->show()V

    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
