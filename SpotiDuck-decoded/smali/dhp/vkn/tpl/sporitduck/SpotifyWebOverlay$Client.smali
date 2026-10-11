.class public Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;
.super Landroid/webkit/WebViewClient;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "Client"
.end annotation

.field private final activity:Landroid/app/Activity;


.method public constructor <init>(Landroid/app/Activity;)V
    .registers 2

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V
    iput-object p1, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;->activity:Landroid/app/Activity;
    return-void
.end method


# Login page detected → show full-screen dialog
.method public onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .registers 8

    invoke-super {p0, p1, p2, p3}, Landroid/webkit/WebViewClient;->onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    if-eqz p2, :return

    const-string v0, "accounts.spotify.com"
    invoke-virtual {p2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :show_login

    const-string v0, "/login"
    invoke-virtual {p2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :return

    :show_login
    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :return

    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v1
    if-eqz v1, :just_show

    const v2, 0x400
    invoke-virtual {v1, v2, v2}, Landroid/view/Window;->setFlags(II)V
    const/4 v2, -0x1
    invoke-virtual {v1, v2, v2}, Landroid/view/Window;->setLayout(II)V

    :just_show
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    :return
    return-void
.end method


# open.spotify.com loaded → dismiss overlay, persist cookies
.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .registers 9

    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    if-eqz p2, :return

    const-string v0, "https://open.spotify.com"
    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :return

    :flush
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v0
    invoke-virtual {v0}, Landroid/webkit/CookieManager;->flush()V

    # Toast: "Web player ready"
    iget-object v1, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;->activity:Landroid/app/Activity;
    const-string v2, "SpotiDuck: Web player ready"
    const/4 v0, 0x0
    invoke-static {v1, v2, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    # Mark user as logged in via our overlay in Spotify's own prefs
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;->activity:Landroid/app/Activity;
    const-string v2, "spotiduck_overlay"
    const/4 v3, 0x0
    invoke-virtual {v0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v2, "logged_in"
    const/4 v3, 0x1
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Also tell our own module (via its ContentProvider) that web login succeeded, so
    # the settings screen can show the real status instead of the unrelated native
    # SpotiDuck account flag, which may never get set in normal usage.
    :try_start_1
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$Client;->activity:Landroid/app/Activity;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v3, "content://dhp.vkn.tpl.sporitduck.prefsprovider/state"
    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v3
    new-instance v4, Landroid/content/ContentValues;
    invoke-direct {v4}, Landroid/content/ContentValues;-><init>()V
    const-string v5, "WebLoggedIn"
    const/4 v6, 0x1
    invoke-static {v6}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v6
    invoke-virtual {v4, v5, v6}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Boolean;)V
    const/4 v5, 0x0
    invoke-virtual {v0, v3, v4, v5, v5}, Landroid/content/ContentResolver;->update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    goto :weblogin_done

    :catch_1
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :weblogin_done

    # Dismiss overlay unless ShowWebView is enabled.
    # Uses the cached value create()/refresh() just computed instead of a fresh
    # XSharedPreferences read here, which was observed to disagree and dismiss
    # the dialog right after it was shown.
    sget-boolean v1, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sShowWebView:Z
    if-nez v1, :return

    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :return
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :return
    return-void
.end method


# Delegate WebView ad blocking to SpotiDuck's 3-mode AdBlock engine (legacy / instant / dynamic)
.method public shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .registers 4

    invoke-static {p1, p2}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->intercept(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    move-result-object v0
    if-eqz v0, :pass
    return-object v0

    :pass
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    move-result-object v0
    return-object v0
.end method
