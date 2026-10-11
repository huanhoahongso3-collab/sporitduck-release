.class public Ldhp/vkn/tpl/sporitduck/PrefsProvider;
.super Landroid/content/ContentProvider;

# Exposes the module's own settings to other processes (Spotify) via Binder IPC.
# XSharedPreferences does a raw cross-UID file read of /data/data/<pkg>/shared_prefs,
# which is blocked on modern Android regardless of chmod (per-app SELinux isolation on
# /data/data). A ContentProvider is the OS-sanctioned way to share data across the app
# sandbox boundary, so it works reliably where the raw file read did not.


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V
    return-void
.end method


.method public onCreate()Z
    .registers 2

    const/4 v0, 0x1
    return v0
.end method


.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .registers 20

    const/4 v0, 0x6
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "ShowWebView"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "AdBlockEnabled"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "WebPlayerEnabled"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "DebugEnabled"
    aput-object v2, v0, v1
    const/4 v1, 0x4
    const-string v2, "LoggedIn"
    aput-object v2, v0, v1
    const/4 v1, 0x5
    const-string v2, "clear_count"
    aput-object v2, v0, v1

    new-instance v1, Landroid/database/MatrixCursor;
    invoke-direct {v1, v0}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;
    move-result-object v2
    if-eqz v2, :empty

    const-string v3, "dhp.vkn.tpl.sporitduck_preferences"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    const-string v3, "ShowWebView"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v5

    const-string v3, "AdBlockEnabled"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v6

    const-string v3, "WebPlayerEnabled"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v7

    const-string v3, "DebugEnabled"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v8

    const-string v3, "LoggedIn"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v9

    const-string v3, "clear_count"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v10

    const/4 v0, 0x6
    new-array v0, v0, [Ljava/lang/Object;

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    const/4 v11, 0x0
    aput-object v3, v0, v11

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    const/4 v11, 0x1
    aput-object v3, v0, v11

    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    const/4 v11, 0x2
    aput-object v3, v0, v11

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    const/4 v11, 0x3
    aput-object v3, v0, v11

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    const/4 v11, 0x4
    aput-object v3, v0, v11

    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    const/4 v11, 0x5
    aput-object v3, v0, v11

    invoke-virtual {v1, v0}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    :empty
    return-object v1
.end method


.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .registers 2

    const/4 v0, 0x0
    return-object v0
.end method


.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .registers 3

    const/4 v0, 0x0
    return-object v0
.end method


.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 4

    const/4 v0, 0x0
    return v0
.end method


.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 5

    const/4 v0, 0x0
    return v0
.end method
