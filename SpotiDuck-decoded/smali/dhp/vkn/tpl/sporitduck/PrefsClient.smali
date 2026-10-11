.class public Ldhp/vkn/tpl/sporitduck/PrefsClient;
.super Ljava/lang/Object;

# Reads SpotiDuck's settings from inside Spotify's process via PrefsProvider (Binder IPC),
# instead of XSharedPreferences' raw cross-UID file read which modern Android blocks.


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# Returns a Bundle with ShowWebView/AdBlockEnabled/WebPlayerEnabled/DebugEnabled/LoggedIn
# (booleans) and clear_count (int). Falls back to all-false/0 defaults if the provider
# can't be reached for any reason.
.method public static readAll(Landroid/content/Context;)Landroid/os/Bundle;
    .registers 14

    new-instance v0, Landroid/os/Bundle;
    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const/4 v1, 0x0
    const-string v2, "ShowWebView"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    const-string v2, "AdBlockEnabled"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    const-string v2, "WebPlayerEnabled"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    const-string v2, "DebugEnabled"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    const-string v2, "LoggedIn"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V
    const-string v2, "clear_count"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    if-eqz p0, :return

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v2

    const-string v4, "content://dhp.vkn.tpl.sporitduck.prefsprovider/state"
    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v3

    const/4 v4, 0x0
    const/4 v5, 0x0
    const/4 v6, 0x0
    const/4 v7, 0x0
    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    move-result-object v5
    if-eqz v5, :return

    invoke-interface {v5}, Landroid/database/Cursor;->moveToFirst()Z
    move-result v6
    if-eqz v6, :do_close

    const-string v7, "ShowWebView"
    invoke-interface {v5, v7}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v8
    invoke-interface {v5, v8}, Landroid/database/Cursor;->getInt(I)I
    move-result v8
    invoke-virtual {v0, v7, v8}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v7, "AdBlockEnabled"
    invoke-interface {v5, v7}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v8
    invoke-interface {v5, v8}, Landroid/database/Cursor;->getInt(I)I
    move-result v8
    invoke-virtual {v0, v7, v8}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v7, "WebPlayerEnabled"
    invoke-interface {v5, v7}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v8
    invoke-interface {v5, v8}, Landroid/database/Cursor;->getInt(I)I
    move-result v8
    invoke-virtual {v0, v7, v8}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v7, "DebugEnabled"
    invoke-interface {v5, v7}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v8
    invoke-interface {v5, v8}, Landroid/database/Cursor;->getInt(I)I
    move-result v8
    invoke-virtual {v0, v7, v8}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v7, "LoggedIn"
    invoke-interface {v5, v7}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v8
    invoke-interface {v5, v8}, Landroid/database/Cursor;->getInt(I)I
    move-result v8
    invoke-virtual {v0, v7, v8}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v7, "clear_count"
    invoke-interface {v5, v7}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v8
    invoke-interface {v5, v8}, Landroid/database/Cursor;->getInt(I)I
    move-result v8
    invoke-virtual {v0, v7, v8}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    :do_close
    invoke-interface {v5}, Landroid/database/Cursor;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :return
    return-object v0

    :catch_0
    move-exception v1
    invoke-static {v1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-object v0
.end method
