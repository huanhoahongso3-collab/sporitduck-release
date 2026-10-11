.class public final Ldhp/vkn/tpl/sporitduck/AdBlockList;
.super Ljava/lang/Object;

# Unified SpotiDuck AdBlock engine supporting all 3 upstream SpotiDuck mechanisms:
#   1. "legacy"  — Connection-Verified: blocks curated ad/tracker domains AND opens an
#                  HttpURLConnection (2000ms timeout) on candidate audio stream URLs
#                  (.net/audio/, .co/audio/, akamaized.net/audio/, scdn.co/audio/,
#                  spotifycdn.com/audio/, etc.) to inspect Content-Type; if audio/mpeg
#                  (and not podz-content / gew4-spclient), replaces with silent.mp3.
#   2. "instant" — Instant (In-Memory): immediately blocks curated Spotify & third-party
#                  ad/tracker URLs in memory, serving silent.mp3 (200/206 with Range & CORS)
#                  for media requests and 200 OK with CORS for non-media requests.
#   3. "dynamic" — Dynamic Blocklist (In-Memory): checks core Spotify ad patterns plus
#                  SpotiDuck's adblock_hosts.txt domain set (AppSingleton.Y with parent
#                  subdomain walking) and EasyList/ABP filter engine (Ln3 in AppSingleton.Z).

.field public static sInitialized:Z = false
.field public static sAdBlockEnabled:Z = false
.field public static sAdBlockMode:Ljava/lang/String; = "legacy"
.field public static sLastPrefsCheckMs:J = 0x0L


.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# Initializes AppSingleton.s (using createPackageContext("dhp.vkn.tpl.sporitduck", 0) when
# running inside com.spotify.music so SpotiDuck's assets silent.mp3 and adblock_hosts.txt
# are accessible), loads the dynamic blocklist via Lm9;->j(), and refreshes AdBlockEnabled
# and AdBlockMode from PrefsClient with a 2-second TTL cache.
.method public static ensureInitialized(Landroid/content/Context;)V
    .registers 8

    if-nez p0, :have_ctx
    invoke-static {}, Landroid/app/ActivityThread;->currentApplication()Landroid/app/Application;
    move-result-object p0
    if-nez p0, :have_ctx
    return-void

    :have_ctx
    sget-boolean v0, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sInitialized:Z
    if-nez v0, :check_prefs

    const/4 v0, 0x1
    sput-boolean v0, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sInitialized:Z

    :try_start_init
    sget-object v0, Ldhp/vkn/tpl/sporitduck/AppSingleton;->s:Landroid/content/Context;
    if-nez v0, :load_hosts

    const-string v1, "dhp.vkn.tpl.sporitduck"
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->createPackageContext(Ljava/lang/String;I)Landroid/content/Context;
    move-result-object v0
    sput-object v0, Ldhp/vkn/tpl/sporitduck/AppSingleton;->s:Landroid/content/Context;
    :try_end_init
    .catch Ljava/lang/Exception; {:try_start_init .. :try_end_init} :catch_ctx
    goto :load_hosts

    :catch_ctx
    move-exception v0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    if-nez v0, :set_fallback_ctx
    move-object v0, p0
    :set_fallback_ctx
    sput-object v0, Ldhp/vkn/tpl/sporitduck/AppSingleton;->s:Landroid/content/Context;

    :load_hosts
    :try_start_hosts
    invoke-static {}, Lm9;->j()V
    :try_end_hosts
    .catch Ljava/lang/Exception; {:try_start_hosts .. :try_end_hosts} :catch_hosts
    goto :check_prefs

    :catch_hosts
    move-exception v0
    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :check_prefs
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0
    sget-wide v2, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sLastPrefsCheckMs:J
    sub-long v4, v0, v2
    const-wide/16 v6, 0x7d0    # 2000ms cache TTL
    cmp-long v2, v4, v6
    if-ltz v2, :done

    sput-wide v0, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sLastPrefsCheckMs:J

    :try_start_prefs
    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/PrefsClient;->readAll(Landroid/content/Context;)Landroid/os/Bundle;
    move-result-object v0

    const-string v1, "AdBlockEnabled"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z
    move-result v1
    sput-boolean v1, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockEnabled:Z

    const-string v1, "AdBlockMode"
    const-string v2, "legacy"
    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-nez v1, :set_mode
    const-string v1, "legacy"
    :set_mode
    sput-object v1, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockMode:Ljava/lang/String;
    sput-object v1, Ldhp/vkn/tpl/sporitduck/AppSingleton;->X:Ljava/lang/String;
    :try_end_prefs
    .catch Ljava/lang/Exception; {:try_start_prefs .. :try_end_prefs} :catch_prefs

    :done
    return-void

    :catch_prefs
    move-exception v0
    return-void
.end method


# Static UI asset check matching c91.smali lines 4832-4954
.method public static isStaticAsset(Ljava/lang/String;)Z
    .registers 3

    const-string v0, ".jpg"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".jpeg"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".png"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".js"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".css"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".svg"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".json"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".woff2"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const-string v0, ".woff"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :yes

    const/4 v0, 0x0
    return v0

    :yes
    const/4 v0, 0x1
    return v0
.end method


# Media request detection matching c91.smali lines 4956-5156
# Returns true if Accept/Sec-Fetch-Dest has audio/video, Range header is present,
# or URL contains .mp3, .mp4, .m4a, .aac, /mp3-ad/, or scdn.co/mp3-ad/.
.method public static isMediaRequest(Ljava/lang/String;Ljava/util/Map;)Z
    .registers 5

    if-eqz p1, :check_url

    const-string v0, "Accept"
    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    if-nez v0, :have_accept
    const-string v0, "accept"
    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    :have_accept
    if-eqz v0, :check_sec_dest
    const-string v1, "audio"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_media
    const-string v1, "video"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_media

    :check_sec_dest
    const-string v0, "Sec-Fetch-Dest"
    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    if-nez v0, :have_sec_dest
    const-string v0, "sec-fetch-dest"
    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    :have_sec_dest
    if-eqz v0, :check_range
    const-string v1, "audio"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_media
    const-string v1, "video"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_media

    :check_range
    const-string v0, "Range"
    invoke-interface {p1, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :is_media
    const-string v0, "range"
    invoke-interface {p1, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :is_media

    :check_url
    const-string v0, ".mp3"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :is_media

    const-string v0, ".mp4"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :is_media

    const-string v0, ".m4a"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :is_media

    const-string v0, ".aac"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :is_media

    const-string v0, "/mp3-ad/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :is_media

    const-string v0, "scdn.co/mp3-ad/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :is_media

    const/4 v0, 0x0
    return v0

    :is_media
    const/4 v0, 0x1
    return v0
.end method


# Empty 200 OK response with CORS header matching c91.smali lines 5721-5767
.method public static createEmpty200Response()Landroid/webkit/WebResourceResponse;
    .registers 8

    new-instance v5, Ljava/util/HashMap;
    invoke-direct {v5}, Ljava/util/HashMap;-><init>()V
    const-string v0, "Access-Control-Allow-Origin"
    const-string v1, "*"
    invoke-virtual {v5, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v0, 0x0
    new-array v0, v0, [B
    new-instance v6, Ljava/io/ByteArrayInputStream;
    invoke-direct {v6, v0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    new-instance v0, Landroid/webkit/WebResourceResponse;
    const-string v1, "text/plain"
    const-string v2, "utf-8"
    const/16 v3, 0xc8
    const-string v4, "OK"
    invoke-direct/range {v0 .. v6}, Landroid/webkit/WebResourceResponse;-><init>(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;Ljava/util/Map;Ljava/io/InputStream;)V
    return-object v0
.end method


# Core 16 Spotify ad patterns checked first in "dynamic" mode (c91.smali lines 5229-5394)
.method public static isCoreSpotifyAdUrl(Ljava/lang/String;)Z
    .registers 3

    const-string v0, "/mp3-ad/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "scdn.co/mp3-ad/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "amillionads.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "mp3ad.scdn.co"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "audio-ads.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "ads-akp.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "ads-fa.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "adeventtracker.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "pixel-static.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "pixel.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "adstudio.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "ads.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "aet.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "t.6sc.co"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "tracker.samplicio.us"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const-string v0, "adsrvr.org"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :matched

    const/4 v0, 0x0
    return v0

    :matched
    const/4 v0, 0x1
    return v0
.end method


# Curated in-memory ad/tracker check matching c91.smali "instant" & "legacy" lists
# (lines 5773-6015 & 6147-6389) plus analytics/tracker patterns.
.method public static isBlocked(Ljava/lang/String;)Z
    .registers 4

    if-eqz p0, :not_blocked

    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isCoreSpotifyAdUrl(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :blocked

    const-string v1, "doubleclick.net"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "googlesyndication.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "fastly-insights.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "sentry.io"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "2mdn.net"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "adxcel.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "adstudio-assets.scdn.co"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "log.spotify.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "analytics.spotify.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "events.spotify.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "crashlytics.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "branch.io"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "app-measurement.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "scorecardresearch.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "firebaseremoteconfig.googleapis.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "google-analytics.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "googletagmanager.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "facebook.net"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "amplitude.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "bugsnag.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "app.adjust.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "moatads.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "adnxs.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "amazon-adsystem.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "pubads"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "optimizely.com"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "partnerad"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "adserver"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "ads-sdk"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "ad-logic"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "ad-engine"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    const-string v1, "googleads"
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :blocked

    :not_blocked
    const/4 v0, 0x0
    return v0

    :blocked
    const/4 v0, 0x1
    return v0
.end method


# Dynamic blocklist check matching c91.smali lines 5229-5684:
# 1. Core Spotify ad URLs
# 2. AppSingleton.Y domain set (walking subdomains a.b.c.com -> b.c.com -> c.com)
# 3. AppSingleton.Z (Ln3 EasyList/ABP filter matcher)
.method public static isDynamicBlocked(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 7

    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isCoreSpotifyAdUrl(Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :blocked

    if-eqz p1, :check_abp
    invoke-virtual {p1}, Ljava/lang/String;->length()I
    move-result v0
    if-eqz v0, :check_abp

    sget-object v0, Ldhp/vkn/tpl/sporitduck/AppSingleton;->Y:Ljava/util/concurrent/ConcurrentHashMap$KeySetView;
    if-eqz v0, :check_abp

    move-object v1, p1

    :host_loop
    invoke-virtual {v0, v1}, Ljava/util/concurrent/ConcurrentHashMap$KeySetView;->contains(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :blocked

    const/16 v2, 0x2e    # '.'
    invoke-virtual {v1, v2}, Ljava/lang/String;->indexOf(I)I
    move-result v3
    const/4 v4, -0x1
    if-eq v3, v4, :check_abp

    add-int/lit8 v3, v3, 0x1
    invoke-virtual {v1, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v1, v2}, Ljava/lang/String;->indexOf(I)I
    move-result v2
    if-eq v2, v4, :check_abp
    goto :host_loop

    :check_abp
    sget-object v0, Ldhp/vkn/tpl/sporitduck/AppSingleton;->Z:Ln3;
    if-eqz v0, :not_blocked
    if-nez p1, :have_host
    const-string p1, ""
    :have_host
    invoke-virtual {v0, p0, p1}, Ln3;->e(Ljava/lang/String;Ljava/lang/String;)Z
    move-result v0
    if-nez v0, :blocked

    :not_blocked
    const/4 v0, 0x0
    return v0

    :blocked
    const/4 v0, 0x1
    return v0
.end method


# Candidate audio stream URL check for "legacy" mode (c91.smali lines 6447-6622)
.method public static isAudioStreamCandidate(Ljava/lang/String;)Z
    .registers 3

    const-string v0, ".net/audio/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, ".co/audio/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "/mp3-ad/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "scdn.co/mp3-ad/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "amillionads.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "adxcel.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "2mdn.net"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "akamaized.net/audio/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "scdn.co/audio/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "spotifycdn.com/audio/"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "adstudio-assets.scdn.co"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "mp3ad.scdn.co"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "audio-ads.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "ads-akp.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const-string v0, "ads-fa.spotify.com"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :candidate

    const/4 v0, 0x0
    return v0

    :candidate
    const/4 v0, 0x1
    return v0
.end method


# Legacy Connection-Verified audio ad check matching c91.smali lines 6624-7238:
# Opens an HttpURLConnection (2000ms timeout) with the request's method and headers,
# inspects Content-Type, and returns true if it starts with "audio/mpeg" (and URL
# does not contain "podz-content" or "gew4-spclient").
.method public static verifyLegacyAudioAd(Ljava/lang/String;Ljava/lang/String;Landroid/webkit/WebResourceRequest;)Z
    .registers 9

    const/4 v0, 0x0

    :try_start_conn
    new-instance v1, Ljava/net/URL;
    invoke-direct {v1, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v1
    check-cast v1, Ljava/net/HttpURLConnection;

    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getMethod()Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :headers_copy
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    :headers_copy
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getRequestHeaders()Ljava/util/Map;
    move-result-object v2
    if-eqz v2, :set_timeouts
    invoke-interface {v2}, Ljava/util/Map;->entrySet()Ljava/util/Set;
    move-result-object v2
    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object v2

    :header_loop
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z
    move-result v3
    if-eqz v3, :set_timeouts
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Ljava/util/Map$Entry;
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Ljava/lang/String;
    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Ljava/lang/String;
    if-eqz v4, :header_loop
    if-eqz v3, :header_loop
    invoke-virtual {v1, v4, v3}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    goto :header_loop

    :set_timeouts
    const/16 v2, 0x7d0    # 2000ms
    invoke-virtual {v1, v2}, Ljava/net/URLConnection;->setConnectTimeout(I)V
    invoke-virtual {v1, v2}, Ljava/net/URLConnection;->setReadTimeout(I)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V
    invoke-virtual {v1}, Ljava/net/URLConnection;->connect()V

    invoke-virtual {v1}, Ljava/net/URLConnection;->getContentType()Ljava/lang/String;
    move-result-object v3
    if-eqz v3, :disconnect_false

    sget-object v4, Ljava/util/Locale;->ROOT:Ljava/util/Locale;
    invoke-virtual {v3, v4}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v3

    const-string v4, "audio/mpeg"
    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :disconnect_false

    const-string v3, "podz-content"
    invoke-virtual {p1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v3
    if-nez v3, :disconnect_false

    const-string v3, "gew4-spclient"
    invoke-virtual {p1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v3
    if-nez v3, :disconnect_false

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    return v2

    :disconnect_false
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_conn
    .catch Ljava/lang/Exception; {:try_start_conn .. :try_end_conn} :catch_conn

    return v0

    :catch_conn
    move-exception v1
    return v0
.end method


# Main WebView interception entry point for both SpotifyWebOverlay$Client and
# WebPlayerCapture$Client. Implements all 3 original SpotiDuck AdBlock modes:
# "legacy", "instant", and "dynamic".
# Returns null when the request should be allowed to proceed normally.
.method public static intercept(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .registers 10

    const/4 v0, 0x0
    if-eqz p0, :return_null
    if-eqz p1, :return_null

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v1
    invoke-static {v1}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->ensureInitialized(Landroid/content/Context;)V

    sget-boolean v1, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockEnabled:Z
    if-eqz v1, :return_null

    invoke-interface {p1}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;
    move-result-object v1
    if-eqz v1, :return_null

    invoke-virtual {v1}, Landroid/net/Uri;->toString()Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :return_null

    sget-object v3, Ljava/util/Locale;->ROOT:Ljava/util/Locale;
    invoke-virtual {v2, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v4

    # Skip static UI assets (.jpg, .png, .js, .css, .woff2, etc.)
    invoke-static {v4}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isStaticAsset(Ljava/lang/String;)Z
    move-result v5
    if-eqz v5, :check_headers
    return-object v0

    :check_headers
    invoke-interface {p1}, Landroid/webkit/WebResourceRequest;->getRequestHeaders()Ljava/util/Map;
    move-result-object v5
    if-nez v5, :have_headers
    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;
    move-result-object v5
    :have_headers

    invoke-static {v4, v5}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isMediaRequest(Ljava/lang/String;Ljava/util/Map;)Z
    move-result v6

    sget-object v7, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockMode:Ljava/lang/String;

    # --- Mode 3: "dynamic" (Dynamic Blocklist In-Memory) ---
    const-string v8, "dynamic"
    invoke-virtual {v8, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :check_instant

    invoke-virtual {v1}, Landroid/net/Uri;->getHost()Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :dyn_no_host
    invoke-virtual {v1, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v1
    goto :dyn_check
    :dyn_no_host
    const-string v1, ""
    :dyn_check
    invoke-static {v4, v1}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isDynamicBlocked(Ljava/lang/String;Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :return_null
    goto :block_request

    # --- Mode 2: "instant" (Instant In-Memory) ---
    :check_instant
    const-string v8, "instant"
    invoke-virtual {v8, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :mode_legacy

    invoke-static {v4}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isBlocked(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :return_null
    goto :block_request

    # --- Mode 1: "legacy" (Connection-Verified + Curated Blocklist) ---
    :mode_legacy
    invoke-static {v4}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isBlocked(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :block_request

    invoke-static {v4}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isAudioStreamCandidate(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :return_null

    invoke-static {v2, v4, p1}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->verifyLegacyAudioAd(Ljava/lang/String;Ljava/lang/String;Landroid/webkit/WebResourceRequest;)Z
    move-result v1
    if-eqz v1, :return_null

    # Confirmed audio/mpeg ad stream via HttpURLConnection -> return silent.mp3!
    invoke-static {p0, v5}, Lc91;->a(Landroid/webkit/WebView;Ljava/util/Map;)Landroid/webkit/WebResourceResponse;
    move-result-object v0
    return-object v0

    :block_request
    if-eqz v6, :block_non_media
    invoke-static {p0, v5}, Lc91;->a(Landroid/webkit/WebView;Ljava/util/Map;)Landroid/webkit/WebResourceResponse;
    move-result-object v0
    return-object v0

    :block_non_media
    invoke-static {}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->createEmpty200Response()Landroid/webkit/WebResourceResponse;
    move-result-object v0
    return-object v0

    :return_null
    return-object v0
.end method


# DNS-level domain check used by DnsAdBlock (InetAddress.getAllByName hook).
# Respects AdBlockEnabled and AdBlockMode (including dynamic hostlist lookup),
# while safeguarding shared Spotify/CDN hosts that also serve normal music/UI.
.method public static isDnsBlocked(Landroid/content/Context;Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0
    if-eqz p1, :return_false

    invoke-static {p0}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->ensureInitialized(Landroid/content/Context;)V

    sget-boolean v1, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockEnabled:Z
    if-eqz v1, :return_false

    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;
    invoke-virtual {p1, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v1

    # Never DNS-block core Spotify playback/login/CDN hosts
    const-string v2, "open.spotify.com"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "accounts.spotify.com"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "spclient"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "dealer"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "audio-ak"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "audio4-ak"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "heads-fa"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-nez v2, :return_false

    const-string v2, "Dynamic"
    sget-object v2, Ldhp/vkn/tpl/sporitduck/AdBlockList;->sAdBlockMode:Ljava/lang/String;
    const-string v3, "dynamic"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :check_curated

    invoke-static {v1, v1}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isDynamicBlocked(Ljava/lang/String;Ljava/lang/String;)Z
    move-result v2
    if-nez v2, :return_true

    :check_curated
    invoke-static {v1}, Ldhp/vkn/tpl/sporitduck/AdBlockList;->isBlocked(Ljava/lang/String;)Z
    move-result v0
    return v0

    :return_true
    const/4 v0, 0x1
    return v0

    :return_false
    return v0
.end method
