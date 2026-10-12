.class public final Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;
.super Landroid/app/Activity;
.implements Landroid/view/View$OnClickListener;

.field private prefs:Landroid/content/SharedPreferences;
.field private btnAdBlock:Landroid/widget/Button;
.field private btnAdBlockMode:Landroid/widget/Button;
.field private btnWebPlayer:Landroid/widget/Button;
.field private btnClear:Landroid/widget/Button;
.field private btnDebug:Landroid/widget/Button;
.field private btnShowWebView:Landroid/widget/Button;
.field private btnForceStop:Landroid/widget/Button;
.field private btnForceStopOnClose:Landroid/widget/Button;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


.method protected onCreate(Landroid/os/Bundle;)V
    .locals 11

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # prefs = getSharedPreferences("dhp.vkn.tpl.sporitduck_preferences", MODE_PRIVATE)
    # MODE_WORLD_READABLE is silently ignored on Android 9+; use MODE_PRIVATE and chmod after each commit.
    const-string v0, "dhp.vkn.tpl.sporitduck_preferences"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    iput-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->requestBatteryExemption()V

    # Read relevant booleans & AdBlockMode
    const-string v1, "WebLoggedIn"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1    # v1 = loggedIn

    const-string v2, "AdBlockEnabled"
    const/4 v3, 0x0
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2    # v2 = adBlockEnabled

    const-string v3, "WebPlayerEnabled"
    const/4 v4, 0x0
    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3    # v3 = webPlayerEnabled

    const-string v7, "DebugEnabled"
    const/4 v8, 0x0
    invoke-interface {v0, v7, v8}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v7    # v7 = debugEnabled

    const-string v8, "ShowWebView"
    const/4 v9, 0x0
    invoke-interface {v0, v8, v9}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v8    # v8 = showWebView

    const-string v9, "AdBlockMode"
    const-string v10, "legacy"
    invoke-interface {v0, v9, v10}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9    # v9 = adBlockMode ("legacy" | "instant" | "dynamic")

    const-string v10, "ForceStopOnRecentsClose"
    const/4 v6, 0x0
    invoke-interface {v0, v10, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v10    # v10 = forceStopOnRecentsClose

    # root = new LinearLayout(this); VERTICAL; setPadding(64,80,64,64)
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v5, 0x1
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v5, 0x40
    const/16 v6, 0x50
    invoke-virtual {v4, v5, v6, v5, v5}, Landroid/view/View;->setPadding(IIII)V

    # Title: "dhpOS Sporitduck"
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "dhpOS Sporitduck"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41C00000    # 24.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # Login status (read-only; reflects whether the Spotify web overlay has actually
    # authenticated — see WebLoggedIn above)
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    if-eqz v1, :status_off
    const-string v6, "SpotiDuck: Logged in ✓  —  module active"
    goto :status_set
    :status_off
    const-string v6, "SpotiDuck: Not logged in  —  open Spotify to log in"
    :status_set
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000    # 16.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Section: Ad Blocker toggle & 3-Mode selector ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "\nAd Blocker (WebView & DNS)"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "Block audio/video ads (silent.mp3 replacement), analytics & tracking across WebViews and DNS."
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41600000    # 14.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    if-eqz v2, :btn_adb_enable
    const-string v6, "Disable Ad Blocker"
    goto :btn_adb_set
    :btn_adb_enable
    const-string v6, "Enable Ad Blocker"
    :btn_adb_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlock:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Subsection: Ad Blocker Mode (3 SpotiDuck Mechanisms) ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "AdBlock Mechanism:\n• Legacy (Connection-Verified): Inspects audio stream Content-Type + curated list\n• Instant (In-Memory): Fast in-memory Spotify & ad domain blocking\n• Dynamic Blocklist (In-Memory): Full adblock_hosts.txt + EasyList/ABP rules"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41500000    # 13.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v6, "instant"
    invoke-virtual {v6, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v6
    if-nez v6, :mode_btn_instant
    const-string v6, "dynamic"
    invoke-virtual {v6, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v6
    if-nez v6, :mode_btn_dynamic
    const-string v6, "Mode: Legacy (Connection-Verified)  [Tap to switch]"
    goto :mode_btn_set
    :mode_btn_instant
    const-string v6, "Mode: Instant (In-Memory)  [Tap to switch]"
    goto :mode_btn_set
    :mode_btn_dynamic
    const-string v6, "Mode: Dynamic Blocklist (In-Memory)  [Tap to switch]"
    :mode_btn_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlockMode:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Section: Web Player toggle ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "\nWeb Player Connect"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "Auto-navigate to web player device in Spotify Connect. Restart Spotify to apply."
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41600000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    if-eqz v3, :btn_wp_enable
    const-string v6, "Disable Web Player"
    goto :btn_wp_set
    :btn_wp_enable
    const-string v6, "Enable Web Player"
    :btn_wp_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnWebPlayer:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Section: Debug Toasts toggle ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "\nDebug Toasts"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    if-eqz v7, :btn_dbg_enable
    const-string v6, "Disable Debug Toasts"
    goto :btn_dbg_set
    :btn_dbg_enable
    const-string v6, "Enable Debug Toasts"
    :btn_dbg_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnDebug:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Section: Show WebView toggle ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "\nShow WebView"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "Always show Spotify web player overlay on screen. Restart Spotify to apply."
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41600000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    if-eqz v8, :btn_swv_enable
    const-string v6, "Disable Show WebView"
    goto :btn_swv_set
    :btn_swv_enable
    const-string v6, "Enable Show WebView"
    :btn_swv_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnShowWebView:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Section: Clear Data button ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "\nData"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v6, "Clear SpotiDuck Data"
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnClear:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "Force-stopping Spotify fully resets its process (hidden Web Player included). Opens Spotify\'s own App info; tap Force stop there."
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41600000    # 14.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v6, "Force Stop Spotify (open settings)"
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnForceStop:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "Fully stops the app (not hardcoded to Spotify -- works whatever app this module is injected into, closing its WebView along with it) as soon as it\'s swiped away from Recents."
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41600000    # 14.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    if-eqz v10, :btn_fsoc_enable
    const-string v6, "Disable Force-Stop On Recents Close"
    goto :btn_fsoc_set
    :btn_fsoc_enable
    const-string v6, "Enable Force-Stop On Recents Close"
    :btn_fsoc_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnForceStopOnClose:Landroid/widget/Button;
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # Wrap LinearLayout in ScrollView so all buttons are accessible on smaller screens
    new-instance v5, Landroid/widget/ScrollView;
    invoke-direct {v5, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v5, v4}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    # setContentView(scrollView)
    invoke-virtual {p0, v5}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 6

    # Dispatch to the right handler by comparing button references
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlock:Landroid/widget/Button;
    if-eq p1, v0, :handle_adblock

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlockMode:Landroid/widget/Button;
    if-eq p1, v0, :handle_adblock_mode

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnWebPlayer:Landroid/widget/Button;
    if-eq p1, v0, :handle_webplayer

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnClear:Landroid/widget/Button;
    if-eq p1, v0, :handle_clear

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnDebug:Landroid/widget/Button;
    if-eq p1, v0, :handle_debug

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnShowWebView:Landroid/widget/Button;
    if-eq p1, v0, :handle_showwebview

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnForceStop:Landroid/widget/Button;
    if-eq p1, v0, :handle_forcestop

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnForceStopOnClose:Landroid/widget/Button;
    if-eq p1, v0, :handle_forcestoponclose

    return-void

    # ---- Toggle ForceStopOnRecentsClose ----
    :handle_forcestoponclose
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "ForceStopOnRecentsClose"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1

    if-nez v1, :fsoc_toggle_false
    const/4 v4, 0x1
    goto :fsoc_toggle_done
    :fsoc_toggle_false
    const/4 v4, 0x0
    :fsoc_toggle_done

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "ForceStopOnRecentsClose"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    if-nez v1, :fsoc_was_on
    const-string v2, "Force-Stop On Recents Close enabled."
    goto :fsoc_toast
    :fsoc_was_on
    const-string v2, "Force-Stop On Recents Close disabled."
    :fsoc_toast
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void

    # ---- Show AlertDialog to choose AdBlockMode (Legacy / Instant / Dynamic) ----
    :handle_adblock_mode
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "AdBlockMode"
    const-string v2, "legacy"
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    const/4 v2, 0x0
    const-string v3, "instant"
    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :checked_instant

    const-string v3, "dynamic"
    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :checked_dynamic
    goto :build_dialog

    :checked_instant
    const/4 v2, 0x1
    goto :build_dialog

    :checked_dynamic
    const/4 v2, 0x2

    :build_dialog
    const/4 v3, 0x3
    new-array v3, v3, [Ljava/lang/CharSequence;
    const/4 v4, 0x0
    const-string v1, "Legacy (Connection-Verified)"
    aput-object v1, v3, v4
    const/4 v4, 0x1
    const-string v1, "Instant (In-Memory)"
    aput-object v1, v3, v4
    const/4 v4, 0x2
    const-string v1, "Dynamic Blocklist (In-Memory)"
    aput-object v1, v3, v4

    new-instance v0, Landroid/app/AlertDialog$Builder;
    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v1, "Select Ad-Block Mechanism"
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    new-instance v4, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity$ModeDialogListener;
    invoke-direct {v4, p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity$ModeDialogListener;-><init>(Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;)V
    invoke-virtual {v0, v3, v2, v4}, Landroid/app/AlertDialog$Builder;->setSingleChoiceItems([Ljava/lang/CharSequence;ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v1, "Cancel"
    const/4 v4, 0x0
    invoke-virtual {v0, v1, v4}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void

    # ---- Open Spotify's own App info screen so the user can tap Force stop there ----
    :handle_forcestop
    new-instance v0, Landroid/content/Intent;
    const-string v1, "android.settings.APPLICATION_DETAILS_SETTINGS"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "package:com.spotify.music"
    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;
    move-result-object v0

    const/high16 v1, 0x10000000    # FLAG_ACTIVITY_NEW_TASK
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    return-void

    # ---- Toggle AdBlockEnabled ----
    :handle_adblock
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "AdBlockEnabled"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1

    if-nez v1, :adb_toggle_false
    const/4 v4, 0x1
    goto :adb_toggle_done
    :adb_toggle_false
    const/4 v4, 0x0
    :adb_toggle_done

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "AdBlockEnabled"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    sput-boolean v4, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockEnabled:Z
    sput-boolean v4, Ldhp/vkn/tpl/sporitduck/AppSingleton;->W:Z

    if-nez v1, :adb_was_on
    const-string v2, "Ad Blocker enabled!"
    goto :adb_toast
    :adb_was_on
    const-string v2, "Ad Blocker disabled."
    :adb_toast
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void

    # ---- Toggle WebPlayerEnabled ----
    :handle_webplayer
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "WebPlayerEnabled"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1

    if-nez v1, :wp_toggle_false
    const/4 v4, 0x1
    goto :wp_toggle_done
    :wp_toggle_false
    const/4 v4, 0x0
    :wp_toggle_done

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "WebPlayerEnabled"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    if-nez v1, :wp_was_on
    const-string v2, "Web Player enabled! Restart Spotify to apply."
    goto :wp_toast
    :wp_was_on
    const-string v2, "Web Player disabled."
    :wp_toast
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void

    # ---- Clear all SpotiDuck data ----
    :handle_clear
    # Read current clear_count before wiping, then increment and put it back
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "clear_count"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v2    # v2 = old count
    add-int/lit8 v2, v2, 0x1    # v2 = new count

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "clear_count"
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "LoggedIn"
    const/4 v3, 0x0
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "WebLoggedIn"
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    const-string v1, "SpotiDuck data cleared."
    const/4 v2, 0x0
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void

    # ---- Toggle DebugEnabled ----
    :handle_debug
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "DebugEnabled"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1

    if-nez v1, :dbg_toggle_false
    const/4 v4, 0x1
    goto :dbg_toggle_done
    :dbg_toggle_false
    const/4 v4, 0x0
    :dbg_toggle_done

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "DebugEnabled"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    if-nez v1, :dbg_was_on
    const-string v2, "Debug toasts enabled! Restart Spotify."
    goto :dbg_toast
    :dbg_was_on
    const-string v2, "Debug toasts disabled."
    :dbg_toast
    const/4 v3, 0x0
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void

    # ---- Toggle ShowWebView ----
    :handle_showwebview
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    const-string v1, "ShowWebView"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1

    if-nez v1, :swv_toggle_false
    const/4 v4, 0x1
    goto :swv_toggle_done
    :swv_toggle_false
    const/4 v4, 0x0
    :swv_toggle_done

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "ShowWebView"
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    if-nez v1, :swv_was_on
    const-string v2, "Show WebView enabled! Restart Spotify to apply."
    goto :swv_toast
    :swv_was_on
    const-string v2, "Show WebView disabled."
    :swv_toast
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V
    return-void
.end method


# Prompts for standard Android battery-optimization exemption if not already granted
# (does nothing if already exempted -- only shows the system dialog once, the user still
# has to tap Allow). REQUEST_IGNORE_BATTERY_OPTIMIZATIONS is already in the manifest but
# holding the permission alone does nothing; the exemption has to actually be requested.
#
# NOTE: this only reaches standard Android Doze/App Standby. OEM-specific background
# killers (e.g. Samsung's own "Freecess" app-freezing, seen freezing this very app's
# process in logcat) are a separate restriction list with no public API to exempt from
# programmatically -- the user has to allow it manually (Settings > Apps > dhpOS
# Sporitduck > Battery > Unrestricted, or equivalent "put to sleep"/deep-sleep exclusion
# on Samsung). This app's own process hosts PrefsProvider, which Spotify's process calls
# into synchronously on every resume -- if Samsung freezes it, that Binder call stalls,
# which can make the whole module (and the WebView depending on it) feel dead.
.method private requestBatteryExemption()V
    .registers 6

    :try_start_0
    const-string v0, "power"
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Landroid/os/PowerManager;

    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/PowerManager;->isIgnoringBatteryOptimizations(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :return

    new-instance v2, Landroid/content/Intent;
    const-string v3, "android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"
    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "package:"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;
    move-result-object v2

    invoke-virtual {p0, v2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :return
    return-void

    :catch_0
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V
    return-void
.end method


# Make the module prefs file world-readable so XSharedPreferences in Spotify's process can read it.
# MODE_WORLD_READABLE is silently ignored on Android 9+, so we chmod manually after every commit.
.method private chmodPrefs()V
    .registers 4

    :try_start_0
    # Make the app home dir world-executable. Linux requires execute permission on every
    # directory in the path to traverse into it, and this dir defaults to 0700 (no "other"
    # bit) on modern Android, which alone was blocking Spotify's process from ever reaching
    # shared_prefs/ regardless of that subdir's or the xml file's own permissions.
    new-instance v0, Ljava/io/File;
    const-string v1, "/data/data/dhp.vkn.tpl.sporitduck"
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    const/4 v2, 0x1
    const/4 v3, 0x0
    invoke-virtual {v0, v2, v3}, Ljava/io/File;->setExecutable(ZZ)Z

    # Make shared_prefs/ directory world-executable (traversable by other UIDs)
    new-instance v0, Ljava/io/File;
    const-string v1, "/data/data/dhp.vkn.tpl.sporitduck/shared_prefs"
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0, v2, v3}, Ljava/io/File;->setExecutable(ZZ)Z

    # Make the prefs XML file world-readable
    new-instance v0, Ljava/io/File;
    const-string v1, "/data/data/dhp.vkn.tpl.sporitduck/shared_prefs/dhp.vkn.tpl.sporitduck_preferences.xml"
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0, v2, v3}, Ljava/io/File;->setReadable(ZZ)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0
    return-void
.end method


# Callback invoked by ModuleSettingsActivity$ModeDialogListener when user picks an AdBlock mode
.method public onAdBlockModeSelected(I)V
    .locals 5

    const/4 v0, 0x1
    if-eq p1, v0, :sel_instant

    const/4 v0, 0x2
    if-eq p1, v0, :sel_dynamic

    const-string v1, "legacy"
    const-string v2, "Mode: Legacy (Connection-Verified)  [Tap to switch]"
    const-string v3, "AdBlock Mode: Legacy (Connection-Verified)"
    goto :save_sel

    :sel_instant
    const-string v1, "instant"
    const-string v2, "Mode: Instant (In-Memory)  [Tap to switch]"
    const-string v3, "AdBlock Mode: Instant (In-Memory)"
    goto :save_sel

    :sel_dynamic
    const-string v1, "dynamic"
    const-string v2, "Mode: Dynamic Blocklist (In-Memory)  [Tap to switch]"
    const-string v3, "AdBlock Mode: Dynamic Blocklist (In-Memory)"

    :save_sel
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v4, "AdBlockMode"
    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-direct {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    sput-object v1, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockMode:Ljava/lang/String;
    sput-object v1, Ldhp/vkn/tpl/sporitduck/AppSingleton;->X:Ljava/lang/String;

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlockMode:Landroid/widget/Button;
    if-eqz v0, :toast_sel
    invoke-virtual {v0, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    :toast_sel
    const/4 v0, 0x0
    invoke-static {p0, v3, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method
