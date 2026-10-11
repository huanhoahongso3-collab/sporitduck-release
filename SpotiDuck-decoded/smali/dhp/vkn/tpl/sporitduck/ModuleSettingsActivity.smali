.class public final Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;
.super Landroid/app/Activity;
.implements Landroid/view/View$OnClickListener;

.field private prefs:Landroid/content/SharedPreferences;
.field private btnAdBlock:Landroid/widget/Button;
.field private btnWebPlayer:Landroid/widget/Button;
.field private btnClear:Landroid/widget/Button;
.field private btnDebug:Landroid/widget/Button;
.field private btnShowWebView:Landroid/widget/Button;


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


.method protected onCreate(Landroid/os/Bundle;)V
    .registers 14

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # prefs = getSharedPreferences("dhp.vkn.tpl.sporitduck_preferences", MODE_PRIVATE)
    # MODE_WORLD_READABLE is silently ignored on Android 9+; use MODE_PRIVATE and chmod after each commit.
    const-string v0, "dhp.vkn.tpl.sporitduck_preferences"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    iput-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->prefs:Landroid/content/SharedPreferences;
    invoke-virtual {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    # Read relevant booleans
    const-string v1, "LoggedIn"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1    # v1 = loggedIn (set by SpotiDuck's own auth)

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

    # Login status (read-only, managed by SpotiDuck's own auth)
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    if-eqz v1, :status_off
    const-string v6, "SpotiDuck: Logged in ✓  —  module active"
    goto :status_set
    :status_off
    const-string v6, "SpotiDuck: Not logged in  —  log in via SpotiDuck first"
    :status_set
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000    # 16.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # --- Section: DNS Ad Blocker toggle ---
    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "\nDNS Ad Blocker"
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41800000
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v6, "Block ads, analytics & tracking domains. Restart Spotify to apply."
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v6, 0x41600000    # 14.0f
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;
    invoke-direct {v5, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    if-eqz v2, :btn_adb_enable
    const-string v6, "Disable DNS Ad Blocker"
    goto :btn_adb_set
    :btn_adb_enable
    const-string v6, "Enable DNS Ad Blocker"
    :btn_adb_set
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v5, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v5, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlock:Landroid/widget/Button;
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

    # setContentView(root)
    invoke-virtual {p0, v4}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .registers 8

    # Dispatch to the right handler by comparing button references
    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnAdBlock:Landroid/widget/Button;
    if-eq p1, v0, :handle_adblock

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnWebPlayer:Landroid/widget/Button;
    if-eq p1, v0, :handle_webplayer

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnClear:Landroid/widget/Button;
    if-eq p1, v0, :handle_clear

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnDebug:Landroid/widget/Button;
    if-eq p1, v0, :handle_debug

    iget-object v0, p0, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->btnShowWebView:Landroid/widget/Button;
    if-eq p1, v0, :handle_showwebview

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
    invoke-virtual {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    if-nez v1, :adb_was_on
    const-string v2, "DNS Ad Blocker enabled! Restart Spotify to apply."
    goto :adb_toast
    :adb_was_on
    const-string v2, "DNS Ad Blocker disabled."
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
    invoke-virtual {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

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
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "clear_count"
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    invoke-virtual {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

    const-string v1, "SpotiDuck data cleared. Restart Spotify to re-login."
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
    invoke-virtual {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

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
    invoke-virtual {p0}, Ldhp/vkn/tpl/sporitduck/ModuleSettingsActivity;->chmodPrefs()V

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


# Make the module prefs file world-readable so XSharedPreferences in Spotify's process can read it.
# MODE_WORLD_READABLE is silently ignored on Android 9+, so we chmod manually after every commit.
.method private chmodPrefs()V
    .registers 4

    :try_start_0
    # Make shared_prefs/ directory world-executable (traversable by other UIDs)
    new-instance v0, Ljava/io/File;
    const-string v1, "/data/data/dhp.vkn.tpl.sporitduck/shared_prefs"
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    const/4 v2, 0x1
    const/4 v3, 0x0
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
