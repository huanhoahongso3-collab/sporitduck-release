.class public Lcom/spotiduck/music/XposedInit$ToastRunner;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/spotiduck/music/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ToastRunner"
.end annotation

.field private final app:Landroid/app/Application;


.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/spotiduck/music/XposedInit$ToastRunner;->app:Landroid/app/Application;

    return-void
.end method


.method public run()V
    .registers 8

    :try_start_0
    new-instance v0, Lde/robv/android/xposed/XSharedPreferences;
    const-string v1, "com.spotiduck.music"
    const-string v2, "com.spotiduck.music_preferences"
    invoke-direct {v0, v1, v2}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0}, Lde/robv/android/xposed/XSharedPreferences;->reload()V

    const-string v1, "LoggedIn"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3

    iget-object v4, p0, Lcom/spotiduck/music/XposedInit$ToastRunner;->app:Landroid/app/Application;

    if-nez v3, :cond_logged_in

    # Not logged in toast (LONG)
    const-string v5, "SpotiDuck: Not logged in — open SpotiDuck in Settings → Apps, tap Enable, then restart Spotify."
    const/4 v6, 0x1
    invoke-static {v4, v5, v6}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v5
    invoke-virtual {v5}, Landroid/widget/Toast;->show()V
    goto :goto_end

    :cond_logged_in
    # Logged in toast (SHORT)
    const-string v5, "SpotiDuck: Loaded ✓"
    const/4 v6, 0x0
    invoke-static {v4, v5, v6}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v5
    invoke-virtual {v5}, Landroid/widget/Toast;->show()V
    :try_end_0

    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_end
    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
