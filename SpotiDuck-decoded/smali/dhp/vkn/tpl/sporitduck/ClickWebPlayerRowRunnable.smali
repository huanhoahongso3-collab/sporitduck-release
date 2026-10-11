.class public final Ldhp/vkn/tpl/sporitduck/ClickWebPlayerRowRunnable;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Step 2 of the auto web-player-switch: the devices dialog is rendered entirely inside a
# single Jetpack Compose canvas (compose_view) with no per-row View, and no accessibility
# node tree either — AccessibilityNodeInfo.setQueryFromAppProcessEnabled(), the public API
# meant for exactly this in-process case, is hidden-API blocked on this device/Android
# build (NoSuchMethodError even though the class has the method). So this locates the
# dialog window via reflection on WindowManagerGlobal.mViews, finds its compose_view, and
# dispatches a synthetic tap at a fixed offset below it — the Web Player device, once
# captured, is always the second row (right after "This phone"). The offset is stored in
# dp and scaled by the live display density so it lands correctly on any screen size/DPI;
# it was measured directly via `adb shell uiautomator dump` against the real dialog on a
# 450dpi (density 2.8125) device: compose_view top=787px, Web Player row center=1228px,
# giving (1228-787)/2.8125 = 156.8dp.


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public final run()V
    .locals 16

    :try_start
    # --- WindowManagerGlobal.getInstance() ---
    const-string v0, "android.view.WindowManagerGlobal"
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
    move-result-object v0

    const-string v1, "getInstance"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    move-result-object v1

    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    const/4 v2, 0x0
    invoke-virtual {v1, v2, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v7

    # --- mViews field ---
    const-string v1, "mViews"
    invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    move-result-object v1

    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V
    invoke-virtual {v1, v7}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/util/List;
    # v0 = List<View> allRoots

    sget-object v1, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->activity:Landroid/app/Activity;
    if-eqz v1, :no_activity

    invoke-virtual {v1}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v7
    const-string v2, "compose_view"
    const-string v3, "id"
    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v7, v2, v3, v4}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v2
    # v2 = composeViewId (0 if not found)
    if-eqz v2, :no_compose

    # --- Loop through all windows to find one containing compose_view ---
    invoke-interface {v0}, Ljava/util/List;->size()I
    move-result v3
    const/4 v4, 0x0

    :win_loop
    if-ge v4, v3, :no_compose
    invoke-interface {v0, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Landroid/view/View;
    invoke-virtual {v5, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v6
    if-nez v6, :found_compose
    add-int/lit8 v4, v4, 0x1
    goto :win_loop

    # v5 = dialog root view, v6 = compose_view
    :found_compose
    const/4 v7, 0x2
    new-array v7, v7, [I
    invoke-virtual {v6, v7}, Landroid/view/View;->getLocationOnScreen([I)V

    # tapScreenY = composeScreenY + (int)(156.8dp * displayDensity) — see header comment
    # for how this offset to the Web Player row's center was measured.
    const/4 v1, 0x1
    aget v1, v7, v1

    sget-object v0, Ldhp/vkn/tpl/sporitduck/WebPlayerAutoSwitch;->activity:Landroid/app/Activity;
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    const v2, 156.8f
    mul-float/2addr v0, v2
    float-to-int v0, v0
    add-int v14, v1, v0

    # tapScreenX = composeScreenX + composeWidth/2
    const/4 v0, 0x0
    aget v0, v7, v0
    invoke-virtual {v6}, Landroid/view/View;->getWidth()I
    move-result v1
    shr-int/lit8 v1, v1, 0x1
    add-int v13, v0, v1

    # Convert to dialog-root-local coordinates
    const/4 v7, 0x2
    new-array v7, v7, [I
    invoke-virtual {v5, v7}, Landroid/view/View;->getLocationOnScreen([I)V

    const/4 v0, 0x0
    aget v0, v7, v0
    sub-int/2addr v13, v0

    const/4 v0, 0x1
    aget v0, v7, v0
    sub-int/2addr v14, v0
    # v13 = localX (int), v14 = localY (int)

    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "[SPD] switchToWebPlayer: tap "
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    const-string v1, ","
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    int-to-float v13, v13
    int-to-float v14, v14

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v8

    move-wide v10, v8
    const/4 v12, 0x0
    const/4 v15, 0x0
    invoke-static/range {v8 .. v15}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;
    move-result-object v0
    invoke-virtual {v5, v0}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    invoke-virtual {v0}, Landroid/view/MotionEvent;->recycle()V

    const-wide/16 v0, 0x32
    add-long v10, v8, v0
    const/4 v12, 0x1
    invoke-static/range {v8 .. v15}, Landroid/view/MotionEvent;->obtain(JJIFFI)Landroid/view/MotionEvent;
    move-result-object v0
    invoke-virtual {v5, v0}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    invoke-virtual {v0}, Landroid/view/MotionEvent;->recycle()V

    const-string v0, "[SPD] switchToWebPlayer: web player row tapped"
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    goto :end

    :no_compose
    const-string v0, "[SPD] switchToWebPlayer: compose_view not found"
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    goto :end

    :no_activity
    const-string v0, "[SPD] switchToWebPlayer: no activity"
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    goto :end
    :try_end

    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err

    :catch_err
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :end
    return-void
.end method
