.class public Ldhp/vkn/tpl/sporitduck/ShowDialogRunnable;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Calling Dialog.show() synchronously inside the Activity.onCreate hook can run before
# the activity's own window is attached, so the dialog's window silently never appears
# even though show() returns without throwing. Posting it to the main Looper instead
# lets it run after the current onCreate/onResume transaction finishes.

.field private final dialog:Landroid/app/Dialog;


.method public constructor <init>(Landroid/app/Dialog;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Ldhp/vkn/tpl/sporitduck/ShowDialogRunnable;->dialog:Landroid/app/Dialog;
    return-void
.end method


.method public run()V
    .registers 2

    :try_start_0
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ShowDialogRunnable;->dialog:Landroid/app/Dialog;
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method
