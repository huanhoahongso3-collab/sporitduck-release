.class public Ldhp/vkn/tpl/sporitduck/DnsAdBlock;
.super Lde/robv/android/xposed/XC_MethodHook;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


.method public beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    # String host = (String) param.args[0]
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;
    const/4 v1, 0x0
    aget-object v0, v0, v1
    if-eqz v0, :return
    check-cast v0, Ljava/lang/String;

    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object v1
    invoke-static {v1, v0}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isDnsBlocked(Landroid/content/Context;Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :block

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
