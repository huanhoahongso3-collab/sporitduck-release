.class public final Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity$ModeDialogListener;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "ModeDialogListener"
.end annotation

.field private final activity:Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;


.method public constructor <init>(Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity$ModeDialogListener;->activity:Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;
    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity$ModeDialogListener;->activity:Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;
    if-eqz v0, :dismiss
    invoke-virtual {v0, p2}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->onAdBlockModeSelected(I)V

    :dismiss
    if-eqz p1, :done
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    :done
    return-void
.end method
