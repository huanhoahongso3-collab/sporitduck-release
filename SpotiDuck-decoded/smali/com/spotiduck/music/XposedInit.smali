.class public Lcom/spotiduck/music/XposedInit;
.super Ljava/lang/Object;
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    # if (!lpparam.packageName.equals("com.spotify.music")) return
    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;
    const-string v1, "com.spotify.music"
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :return

    # --- Always: hook Application.onCreate for toast + optional web player ---
    const/4 v0, 0x1
    new-array v0, v0, [Ljava/lang/Object;

    new-instance v1, Lcom/spotiduck/music/XposedInit$SpotifyHook;
    invoke-direct {v1}, Lcom/spotiduck/music/XposedInit$SpotifyHook;-><init>()V

    const/4 v2, 0x0
    aput-object v1, v0, v2

    sget-object v3, Landroid/app/Application;->class:Ljava/lang/Class;
    const-string v4, "onCreate"
    invoke-static {v3, v4, v0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    # --- Read prefs for optional feature flags ---
    new-instance v5, Lde/robv/android/xposed/XSharedPreferences;
    const-string v6, "com.spotiduck.music"
    const-string v7, "com.spotiduck.music_preferences"
    invoke-direct {v5, v6, v7}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v5}, Lde/robv/android/xposed/XSharedPreferences;->reload()V

    # --- If AdBlockEnabled: register DNS blocker hook ---
    const-string v6, "AdBlockEnabled"
    const/4 v7, 0x0
    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v6
    if-eqz v6, :return

    const-string v6, "java.net.InetAddress"
    const/4 v7, 0x0           # null = bootstrap ClassLoader
    const-string v8, "getAllByName"
    const-class v9, Ljava/lang/String;
    new-instance v10, Lcom/spotiduck/music/DnsAdBlock;
    invoke-direct {v10}, Lcom/spotiduck/music/DnsAdBlock;-><init>()V
    filled-new-array {v9, v10}, [Ljava/lang/Object;
    move-result-object v9
    invoke-static {v6, v7, v8, v9}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    :return
    return-void
.end method
