.class public Ldhp/vkn/tpl/sporitduck/DnsAdBlock;
.super Lde/robv/android/xposed/XC_MethodHook;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


.method public beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    # This hook is always registered (the module process may not have had an Activity
    # context available yet to gate it at registration time), so check AdBlockEnabled
    # here on every call instead, via PrefsProvider (Binder IPC).
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v5
    invoke-static {v5}, Ldhp/vkn/tpl/sporitduck/PrefsClient;->readAll(Landroid/content/Context;)Landroid/os/Bundle;
    move-result-object v5
    const-string v6, "AdBlockEnabled"
    const/4 v7, 0x0
    invoke-virtual {v5, v6, v7}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v5
    if-eqz v5, :return

    # String host = (String) param.args[0]
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;
    const/4 v1, 0x0
    aget-object v0, v0, v1
    if-eqz v0, :return
    check-cast v0, Ljava/lang/String;

    # Check each blocked domain
    const-string v1, "log.spotify.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "ads.spotify.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "audio2.spotify.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "analytics.spotify.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "events.spotify.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "crashlytics.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "branch.io"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "app-measurement.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "scorecardresearch.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "firebaseremoteconfig.googleapis.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "doubleclick.net"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "google-analytics.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "googletagmanager.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "googlesyndication.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "facebook.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "amplitude.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "sentry.io"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "bugsnag.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "app.adjust.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "moatads.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    const-string v1, "adnxs.com"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :block

    :return
    return-void

    :block
    # Build byte[]{127, 0, 0, 1}
    const/4 v1, 0x4
    new-array v1, v1, [B

    const/4 v2, 0x0
    const/16 v3, 0x7f
    aput-byte v3, v1, v2

    const/4 v2, 0x1
    const/4 v3, 0x0
    aput-byte v3, v1, v2

    const/4 v2, 0x2
    aput-byte v3, v1, v2

    const/4 v2, 0x3
    const/4 v3, 0x1
    aput-byte v3, v1, v2

    # InetAddress loopback = InetAddress.getByAddress(bytes)
    invoke-static {v1}, Ljava/net/InetAddress;->getByAddress([B)Ljava/net/InetAddress;
    move-result-object v1

    # InetAddress[] result = new InetAddress[]{loopback}
    const/4 v2, 0x1
    new-array v2, v2, [Ljava/net/InetAddress;
    const/4 v3, 0x0
    aput-object v1, v2, v3

    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void
.end method
