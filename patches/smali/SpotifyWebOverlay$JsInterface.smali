.class public Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$JsInterface;
.super Ljava/lang/Object;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "JsInterface"
.end annotation

.field private final ctx:Landroid/content/Context;


.method public constructor <init>(Landroid/content/Context;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$JsInterface;->ctx:Landroid/content/Context;
    return-void
.end method


# Called by JS: __spd.onSessionFound(username, token)
.method public onSessionFound(Ljava/lang/String;Ljava/lang/String;)V
    .registers 8
    .annotation system Ldalvik/annotation/Throws;
        value = { Ljava/lang/Throwable; }
    .end annotation
    .annotation build Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$JsInterface;->ctx:Landroid/content/Context;
    const-string v1, "spotify_prefs"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2

    const-string v3, "web_username"
    invoke-interface {v2, v3, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    # Build "Bearer <token>"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Bearer "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3

    const-string v4, "web_access_token"
    invoke-interface {v2, v4, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v3, "logged_in"
    const/4 v4, 0x1
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Dismiss overlay
    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :done
    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method


# Called by JS to get the captured auth token
.method public getCapturedToken()Ljava/lang/String;
    .registers 5
    .annotation build Landroid/webkit/JavascriptInterface;
    .end annotation

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$JsInterface;->ctx:Landroid/content/Context;
    const-string v1, "spotify_prefs"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1

    const-string v2, "web_access_token"
    const-string v3, ""
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method


# Called by JS to show the overlay
.method public switchToWebPlayer()V
    .registers 3
    .annotation build Landroid/webkit/JavascriptInterface;
    .end annotation

    sget-object v0, Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;->sDialog:Landroid/app/Dialog;
    if-eqz v0, :return
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    :return
    return-void
.end method
