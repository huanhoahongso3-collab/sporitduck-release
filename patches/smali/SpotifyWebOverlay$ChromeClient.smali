.class public Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay$ChromeClient;
.super Landroid/webkit/WebChromeClient;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/SpotifyWebOverlay;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ChromeClient"
.end annotation


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/webkit/WebChromeClient;-><init>()V
    return-void
.end method


# Grant all permission requests (DRM/EME, audio capture, video capture)
.method public onPermissionRequest(Landroid/webkit/PermissionRequest;)V
    .registers 3

    invoke-virtual {p1}, Landroid/webkit/PermissionRequest;->getResources()[Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p1, v0}, Landroid/webkit/PermissionRequest;->grant([Ljava/lang/String;)V
    return-void
.end method
