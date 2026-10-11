.class public Ldhp/vkn/tpl/sporitduck/XposedInit$ToastRunner;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/XposedInit;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ToastRunner"
.end annotation

.field private final app:Landroid/app/Application;


.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Ldhp/vkn/tpl/sporitduck/XposedInit$ToastRunner;->app:Landroid/app/Application;

    return-void
.end method


.method public run()V
    .registers 8

    :try_start_0
    new-instance v0, Lde/robv/android/xposed/XSharedPreferences;
    const-string v1, "dhp.vkn.tpl.sporitduck"
    const-string v2, "dhp.vkn.tpl.sporitduck_preferences"
    invoke-direct {v0, v1, v2}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0}, Lde/robv/android/xposed/XSharedPreferences;->reload()V

    const-string v1, "LoggedIn"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3

    iget-object v4, p0, Ldhp/vkn/tpl/sporitduck/XposedInit$ToastRunner;->app:Landroid/app/Application;

    if-eqz v3, :goto_end

    # Logged in toast (SHORT)
    const-string v5, "SpotiDuck: Loaded ✓"
    const/4 v6, 0x0
    invoke-static {v4, v5, v6}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v5
    invoke-virtual {v5}, Landroid/widget/Toast;->show()V

    # Debug toast if DebugEnabled
    const-string v1, "DebugEnabled"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v7
    if-eqz v7, :try_end_0
    const-string v5, "SPD DBG: Application.onCreate hooked ✓"
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
