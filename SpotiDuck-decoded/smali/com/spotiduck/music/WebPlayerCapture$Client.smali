.class public Lcom/spotiduck/music/WebPlayerCapture$Client;
.super Landroid/webkit/WebViewClient;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/spotiduck/music/WebPlayerCapture;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "Client"
.end annotation

.field private final app:Landroid/app/Application;


.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V
    iput-object p1, p0, Lcom/spotiduck/music/WebPlayerCapture$Client;->app:Landroid/app/Application;

    return-void
.end method


# API < 21 variant — on API 21+ the default WebViewClient calls this from the newer overload
.method public shouldInterceptRequest(Landroid/webkit/WebView;Ljava/lang/String;)Landroid/webkit/WebResourceResponse;
    .registers 12

    if-eqz p2, :super

    # Check for connect-state device ID URL
    const-string v0, "/connect-state/v1/devices/hobs_"
    invoke-virtual {p2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :check_auth

    :try_start_device
    # Split on "/hobs_" → take part[1]
    const-string v0, "/hobs_"
    invoke-virtual {p2, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x1
    aget-object v0, v0, v1

    # Split on "?" → take part[0]
    const-string v1, "\\?"
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x0
    aget-object v0, v0, v1

    # Split on "/" → take part[0] (raw device ID)
    const-string v1, "/"
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0
    aget-object v0, v0, v1

    # Build "hobs_<id>"
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "hobs_"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1    # v1 = "hobs_<id>"

    # prefs = app.getSharedPreferences("spotify_prefs", 0)
    iget-object v2, p0, Lcom/spotiduck/music/WebPlayerCapture$Client;->app:Landroid/app/Application;
    const-string v3, "spotify_prefs"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2

    const-string v3, "web_device_id"
    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v3, "enable_web_playback"
    const/4 v4, 0x1
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_device
    .catch Ljava/lang/Exception; {:try_start_device .. :try_end_device} :catch_0

    goto :super

    :check_auth
    # If URL has Authorization: Bearer header (not interceptable here), fall through
    # Future: capture bearer token from network level

    :super
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->shouldInterceptRequest(Landroid/webkit/WebView;Ljava/lang/String;)Landroid/webkit/WebResourceResponse;
    move-result-object v0
    return-object v0

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    goto :super
.end method
