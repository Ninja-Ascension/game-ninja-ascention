(function () {
  "use strict";
  var W = window.WIKI, C = W.c, U = C.ui, $ = function (s) { return document.querySelector(s); };
  C.events = C.events || {}; C.systems = C.systems || {}; C.faq = C.faq || [];
  var LANGS = {en:"English",es:"Español",pt_BR:"Português",fr:"Français",de:"Deutsch",id:"Indonesia",fil:"Filipino",vi:"Tiếng Việt",tr:"Türkçe",ru:"Русский",zh_CN:"简体中文",zh_TW:"繁體中文",ko:"한국어"};
  var IMG = "../img/";
  var SVG = {
    home: '<path d="M3 11l9-8 9 8v9a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/>',
    systems: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/>',
    events: '<path d="M12 2l3 6.5 7 .9-5.1 4.8 1.3 7L12 17.8 5.8 21.2l1.3-7L2 9.4l7-.9z"/>',
    calendar: '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>',
    faq: '<circle cx="12" cy="12" r="10"/><path d="M9.1 9a3 3 0 0 1 5.8 1c0 2-3 3-3 3M12 17h.01"/>',
    tier: '<path d="M4 20h4V10H4zM10 20h4V4h-4zM16 20h4v-7h-4z"/>',
    teams: '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8"/>',
    links: '<path d="M10 13a5 5 0 0 0 7.5.5l3-3a5 5 0 0 0-7-7l-1.7 1.7"/><path d="M14 11a5 5 0 0 0-7.5-.5l-3 3a5 5 0 0 0 7 7l1.7-1.7"/>',
    heroes: '<circle cx="12" cy="7" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>',
    items: '<path d="M21 8l-9-5-9 5v8l9 5 9-5z"/><path d="M3 8l9 5 9-5M12 13v8"/>',
    equip: '<path d="M14.5 2.5l7 7-11 11h-7v-7z"/>',
    search: '<circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/>',
    chat: '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
    send: '<path d="M22 2L11 13M22 2l-7 20-4-9-9-4z"/>',
    close: '<path d="M18 6L6 18M6 6l12 12"/>',
    download: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>',
    pay: '<rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/>',
    fb: '<path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>',
    group: '<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8"/>'
  };
  var WA_SVG = '<svg viewBox="0 0 32 32" width="30" height="30" fill="#fff" aria-hidden="true"><path d="M16 3a13 13 0 0 0-11.2 19.6L3 29l6.6-1.7A13 13 0 1 0 16 3zm0 23.6a10.6 10.6 0 0 1-5.4-1.5l-.4-.2-3.9 1 1-3.8-.2-.4A10.6 10.6 0 1 1 16 26.6zm5.8-7.9c-.3-.2-1.9-.9-2.2-1s-.5-.2-.7.2-.8 1-1 1.2-.4.2-.7 0a8.7 8.7 0 0 1-4.3-3.8c-.3-.6.3-.5.9-1.6.1-.2 0-.4 0-.5l-1-2.4c-.3-.6-.5-.5-.7-.5h-.6a1.2 1.2 0 0 0-.9.4 3.6 3.6 0 0 0-1.1 2.7 6.3 6.3 0 0 0 1.3 3.3 14.4 14.4 0 0 0 5.5 4.9c2 .9 2.8 1 3.9.8a3.2 3.2 0 0 0 2.1-1.5 2.6 2.6 0 0 0 .2-1.5c-.1-.1-.3-.2-.6-.4z"/></svg>';
  function ico(n, size) { return '<svg class="ic" viewBox="0 0 24 24" width="' + (size || 18) + '" height="' + (size || 18) + '" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + (SVG[n] || "") + "</svg>"; }
  var ART = W.art || {ev: {}, sys: {}};
  function head(src) { return src ? '<div class="hero-banner"><img src="' + IMG + src + '" alt="" onerror="this.parentNode.remove()"></div>' : ""; }
  var items = {}, equip = {}, heroes = {}, heroByFrag = {};
  W.items.forEach(function (x) { items[x.id] = x; });
  W.equip.forEach(function (x) { equip[x.id] = x; });
  W.heroes.forEach(function (h) { h.mf = h.f[h.m || 0] || h.f[0]; heroes[h.id] = h; h.frag.forEach(function (f) { heroByFrag[f[0]] = h.id; }); });
  // herramientas (ship_silk_bag_mould, gen/herramientas.py): Ninja Tools, Banderas, Amuletos...
  var tools = {}, TU = W.tools_ui || {}, TOOLS = W.tools || [];
  TOOLS.forEach(function (x) { tools[x.id] = x; });
  if (TOOLS.length) U.d_tools = TU.d;

  var MAXQ = Math.max.apply(null, W.heroes.map(function (h) { return h.q; }).concat([0]));
  var MINQ = Math.min.apply(null, W.heroes.map(function (h) { return h.q; }));
  var TOP = W.heroes.filter(function (h) { return h.n && h.q === MAXQ; });
  var TOPI = TOP.filter(function (h) { return h.mf.img; });
  function navIcon(s) {
    if (s === "heroes" && TOPI[0]) return '<img class="nimg" src="' + IMG + "h/" + TOPI[0].mf.img + '.webp" alt="">';
    if (s === "items") { var bx = W.items.filter(function (x) { return x.k === 4; })[0]; if (bx) return '<img class="nimg" src="' + IMG + "p/" + bx.img + '.webp" alt="">'; }
    var eqi = W.equip.filter(function (x) { return x.img; }); if (s === "equip" && eqi[0]) return '<img class="nimg" src="' + IMG + "p/" + eqi[eqi.length - 1].img + '.webp" alt="">';
    if (s === "events") { for (var t in ART.ev) if (ART.ev[t].i) return '<img class="nimg" src="' + IMG + ART.ev[t].i + '" alt="">'; }
    if (s === "tools" && TOOLS.length) { var tt = TOOLS.slice().sort(function (a, b) { return b.q - a.q || b.k - a.k; })[0]; return '<img class="nimg" src="' + IMG + "p/" + tt.img + '.webp" alt="">'; }
    return ico(s);
  }
  function esc(s) { return String(s == null ? "" : s).replace(/[&<>"]/g, function (c) { return {"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]; }); }
  function norm(s) { return String(s || "").normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase(); }
  // id 0 = el cliente no trae ese dibujo: marcador con la inicial y el color de su rareza
  var PAL = ["#7d838c", "#3fa35a", "#3a86d8", "#9354c9", "#e0832a", "#d94545", "#d9a91c"];
  function ph(alt, q, cls) { var c = Array.from(String(alt || "?").trim())[0] || "?"; return '<span class="' + (cls || "i") + ' ph" style="--phc:' + PAL[Math.max(0, Math.min(PAL.length - 1, q | 0))] + '" role="img" aria-label="' + esc(alt || "") + '">' + esc(c.toUpperCase()) + "</span>"; }
  function hq(h) { return h.q - MINQ + 2; }
  // insignia de calidad: la del cliente si la trae (W.qimg); si no, una pastilla del color de la rareza
  function qb(q, cls) { q = +q; return !W.qimg || W.qimg.indexOf(q) >= 0 ? img("q/" + q + ".webp", cls) : '<span class="' + (cls || "i") + ' qph" style="--phc:' + PAL[Math.max(0, Math.min(PAL.length - 1, q - MINQ + 2))] + '"></span>'; }
  function img(src, cls, alt, q) { if (/(^|\/)0\.webp$/.test(src)) return ph(alt, q, cls); return '<img class="' + (cls || "i") + '" loading="lazy" src="' + IMG + src + '" alt="' + esc(alt || "") + '" onerror="this.style.visibility=\'hidden\'">'; }
  function fmt(n) { return Number(n).toLocaleString(W.lang.replace("_", "-"), {maximumFractionDigits: 2}); }
  function itemDesc(it) { return esc(it.d).replace(/%[sd]/g, it.nn > 0 ? it.nn : "").replace(/\n/g, "<br>"); }

  // ---------- premios "tipo,id,cantidad|..." (fury_reward_spec)
  function reward(str) {
    return String(str || "").split("|").map(function (p) {
      var f = p.split(","), t = +f[0], id = +f[1], n = f[2];
      if (!f[0]) return "";
      if (t === 6 && items[id]) return '<a class="rw" href="#item/' + id + '">' + img("p/" + items[id].img + ".webp", "", items[id].n, items[id].q) + esc(items[id].n) + " ×" + esc(n) + "</a>";
      if (t === 7 && equip[id]) return '<a class="rw" href="#equip/' + id + '">' + img("p/" + equip[id].img + ".webp", "", equip[id].n, equip[id].q) + esc(equip[id].n) + " ×" + esc(n) + "</a>";
      if (t === 71 && tools[id]) return '<a class="rw" href="#tool/' + id + '">' + img("p/" + tools[id].img + ".webp", "", tools[id].n, tools[id].q) + esc(tools[id].n) + " ×" + esc(n) + "</a>";
      if (t === 13 && heroes[id]) return '<a class="rw" href="#hero/' + id + '">' + img("h/" + heroes[id].mf.img + ".webp", "", heroes[id].n, hq(heroes[id])) + esc(heroes[id].n) + "</a>";
      if (t === 6 || t === 7 || t === 13 || t === 71) return ""; // fuera de la wiki (relleno o personaje sin estrenar): no se nombra
      var name = W.res[t] || (U.res && U.res[t]) || (U.resource + " " + t), ic = W.resicon[t];
      return '<span class="rw">' + (ic ? img("p/" + ic + ".webp") : "") + esc(name) + " ×" + fmt(n) + "</span>";
    }).join(" ");
  }

  // ---------- eventos: edicion vigente o la siguiente
  // ---------- servidor elegido: cada uno ve el calendario desplazado (cal.js, gen/calendario.py)
  var EV = window.WIKI_EV || {srv: {}, rw: {}, ts: 0}, SRVS = Object.keys(EV.srv).sort(function (a, b) { return a - b; });
  var SKEY = "wiki_srv_" + W.game, srv = null, now;
  try { srv = localStorage.getItem(SKEY); } catch (e) {}
  if (!EV.srv[srv]) SRVS.forEach(function (n) { if (EV.srv[n].o <= Date.now() / 1000 || !srv) srv = n; }); // el mas nuevo ya abierto
  function setSrv(n) {
    var s = EV.srv[n] || {o: 0, cal: []};
    srv = n;
    now = Math.max(Date.now() / 1000, s.o); // un servidor que aun no abre se ve desde su apertura
    W.ev = {cal: s.cal, rw: EV.rw, ts: EV.ts};
  }
  setSrv(srv);
  function srvPick() {
    if (SRVS.length < 2) return SRVS.length ? "<p class='mut'>" + esc(U.srv_opens) + ": " + date(EV.srv[srv].o) + "</p>" : "";
    return "<p class='srvpick'><label>" + esc(U.server) + " <select id='srv'>" + SRVS.map(function (n) { return "<option value='" + n + "'" + (n == srv ? " selected" : "") + ">" + esc(U.server) + " " + n + "</option>"; }).join("") +
      "</select></label> <span class='mut'>" + esc(U.srv_opens) + ": " + date(EV.srv[srv].o) + "</span></p>";
  }
  function o0() { return (EV.srv[srv] || {o: 0}).o; }
  function upcoming() { return EV.srv[srv] && EV.srv[srv].o > Date.now() / 1000; }
  function editionOf(type) {
    var best = null;
    W.ev.cal.forEach(function (r) { if (r[0] == type && (!best || (r[2] <= now && r[3] > now) || (best[2] > now && r[2] < best[2]))) best = r; });
    return best;
  }
  function evName(t) { return (W.evcli[t] && W.evcli[t].n) || (C.events[t] && C.events[t].n) || (U.event + " " + t); }
  // hora del dispositivo y su UTC, p. ej. «17 oct 2026, 0:00 (UTC−5)»
  function tz(ts) { var m = -new Date(ts * 1000).getTimezoneOffset(), a = Math.abs(m); return "UTC" + (m < 0 ? "−" : "+") + Math.floor(a / 60) + (a % 60 ? ":" + ("0" + a % 60).slice(-2) : ""); }
  function date(ts) { return new Date(ts * 1000).toLocaleString(W.lang.replace("_", "-"), {dateStyle: "medium", timeStyle: "short"}) + " (" + tz(ts) + ")"; }

  // ---------- fuentes (de donde sale) a partir de premios y cofres
  // Solo la edicion que ensena la ficha del evento (edicion vigente o la siguiente del servidor
  // elegido; sin premios propios, la 0), no TODAS las ediciones: si no, el Gasto acumulado de
  // hoy (fragmento 584) salia como fuente del 1140, que da otra edicion de finales de noviembre.
  var sources = {}; // "6:id" / "13:id" -> [html]
  function addSrc(key, html) { (sources[key] = sources[key] || []).indexOf(html) < 0 && sources[key].push(html); }
  function edOf(t) { var e = editionOf(t), rw = W.ev.rw[t] || {}; return e && rw[e[1]] ? e[1] : (rw[0] ? 0 : null); }
  // Si ninguna edicion cercana lo da: la proxima edicion futura del servidor que lo de (con su
  // fecha) y, si no hay, «sale en eventos de rotacion» con los eventos de cualquier edicion
  // conocida (19-oct: el 1140 se quedo sin ninguna fuente).
  function rwKeys(rows, fn) { (rows || []).forEach(function (r) { String(r[2]).split("|").forEach(function (p) { var f = p.split(","); if (f.length > 1) fn(f[0] + ":" + f[1]); }); }); }
  function buildSources() {
    sources = {};
    var near = {}, next = {}, rot = {};
    Object.keys(W.ev.rw).forEach(function (t) {
      if (!C.events[t]) return;
      var rwt = W.ev.rw[t], ed = edOf(t);
      var link = '<a href="#event/' + t + '">' + esc(evName(t)) + "</a>";
      if (ed != null) rwKeys(rwt[ed], function (k) { near[k] = 1; addSrc(k, link); });
      W.ev.cal.forEach(function (r) {
        if (r[0] != t || r[2] <= now) return;
        rwKeys(rwt[r[1]] || rwt[0], function (k) { if (!next[k] || r[2] < next[k][0]) next[k] = [r[2], link]; });
      });
      Object.keys(rwt).forEach(function (e) { rwKeys(rwt[e], function (k) { (rot[k] = rot[k] || []).indexOf(link) < 0 && rot[k].push(link); }); });
    });
    Object.keys(rot).forEach(function (k) {
      if (near[k]) return;
      if (next[k]) addSrc(k, next[k][1] + " — " + esc(U.src_next) + ": " + date(next[k][0]));
      else addSrc(k, esc(U.src_rotation) + ": " + rot[k].join(", "));
    });
    W.items.forEach(function (it) { it.box.forEach(function (b) { if (!b[2]) addSrc("6:" + b[0], '<a href="#item/' + it.id + '">' + esc(it.n) + "</a>"); }); });
  }
  buildSources();

  // ---------- vistas
  var views = {};
  var SECTIONS = [["home", U.home], ["heroes", U.heroes], ["items", U.items], ["equip", U.equip]].concat(TOOLS.length ? [["tools", TU.t]] : []).concat([["systems", U.systems], ["events", U.events], ["calendar", U.calendar], ["tier", U.tier], ["teams", U.teams], ["faq", U.faq], ["links", U.links]]);
  var TL = (W.tl && W.tl.tier) || {}, TEAMS = (W.tl && W.tl.teams) || {};

  views.home = function () {
    var pics = TOP.concat(W.heroes.filter(function (x) { return x.n && x.q !== MAXQ; })).filter(function (x) { return x.b; }).slice(0, 14);
    var strip = pics.map(function (x) { return '<a href="#hero/' + x.id + '"><img src="' + IMG + "b/" + x.b + '.webp" alt="' + esc(x.n) + '" onerror="this.parentNode.remove()"></a>'; }).join("");
    var h = "<section class='splash'><div class='marquee'><div class='track'>" + strip + strip + "</div></div><div class='splash-txt'><h1>" + esc(W.cfg.nombre) + " <span>Wiki</span></h1><p>" + esc(U.intro) + "</p></div></section><div class='cards home-cards'>";
    SECTIONS.slice(1).forEach(function (s) { h += '<a class="card tile" href="#' + s[0] + '"><span class="tico">' + navIcon(s[0]) + "</span><span><b>" + esc(s[1]) + "</b><span class='mut'>" + esc(U["d_" + s[0]] || "") + "</span></span></a>"; });
    return h + "</div>" + views.links(true);
  };

  function heroCell(h) {
    return '<a class="cell' + (h.q === MAXQ ? " ssr" : "") + '" href="#hero/' + h.id + '">' + qb(h.q, "qb") + img("h/" + h.mf.img + ".webp", "i", h.n, hq(h)) + "<span>" + esc(h.n) + "</span></a>";
  }
  var hf = {q: null, t: null};
  views.heroes = function () {
    var qs = {}, ts = {};
    W.heroes.forEach(function (h) { if (h.n) { qs[h.q] = 1; ts[h.t] = 1; } });
    var bar = "<div class='chips'>" + Object.keys(qs).sort(function (a, b) { return b - a; }).map(function (q) { return '<button class="chip' + (hf.q == q ? " on" : "") + '" data-f="q" data-v="' + q + '">' + qb(q, "") + "</button>"; }).join("") +
      Object.keys(ts).map(function (t) { return '<button class="chip' + (hf.t == t ? " on" : "") + '" data-f="t" data-v="' + t + '">' + img("t/" + t + ".webp", "") + "</button>"; }).join("") + "</div>";
    bar = bar.split("this.style.visibility='hidden'").join("this.parentNode.style.display='none'");
    var list = W.heroes.filter(function (h) { return h.n && (hf.q == null || h.q == hf.q) && (hf.t == null || h.t == hf.t); })
      .sort(function (a, b) { return b.q - a.q || a.id - b.id; });
    return "<h1>" + esc(U.heroes) + " <span class='mut'>(" + list.length + ")</span></h1><p class='mut'>" + esc(U.heroes_help) + "</p>" + bar + "<div class='grid'>" + list.map(heroCell).join("") + "</div>";
  };
  views.hero = function (id) {
    var h = heroes[id]; if (!h) return notFound();
    var S = W.stat, f0 = h.mf;
    var stats = [[S[0], h.hp, h.ghp], [S[1], h.atk, h.gatk], [S[2], h.pdef, h.gpdef], [S[3], h.mdef, h.gmdef]].filter(function (s) { return s[1] || s[2]; });
    var pct = [[S[4], h.pct[0]], [S[5], h.pct[1]], [S[6], h.pct[2]], [S[7], h.pct[3]], [S[8], h.pct[4]], [S[9], h.pct[5]]].filter(function (s) { return s[1]; });
    var out = "<h1>" + esc(h.n) + "</h1><div class='hero-top'><div class='portrait" + (h.q === MAXQ ? " ssr" : "") + "'>" + (h.b ? img("b/" + h.b + ".webp", "big", h.n) : img("h/" + f0.img + ".webp", "big", h.n, hq(h))) + "</div>" + "<div style='flex:1;min-width:220px'>" +
      "<div class='chips'><span class='chip'>" + qb(h.q, "") + "</span><span class='chip'>" + img("t/" + h.t + ".webp", "") + "</span><span class='chip'>" + "★".repeat(h.star) + "</span>" + (f0.p ? "<span class='chip'>" + esc(f0.p) + "</span>" : "") + "</div>" +
      (TL[h.id] ? "<div class='chips'><a class='chip tierlink' href='#tier'><span class='tierbadge t" + TL[h.id].t + "'>" + TL[h.id].t + "</span> " + esc(roleName(TL[h.id].r)) + " · " + fmt(TL[h.id].s) + " %</a>" + tagChips(h.id) + "</div>" : "") +
      (f0.d ? "<p>" + esc(f0.d) + "</p>" : "") +
      "<h3>" + esc(U.base_stats) + "</h3><table><tr><th></th><th>Lv 1</th><th>+/Lv</th></tr>" + stats.map(function (s) { return "<tr><td>" + esc(s[0]) + "</td><td>" + fmt(s[1]) + "</td><td>+" + fmt(s[2]) + "</td></tr>"; }).join("") +
      pct.map(function (s) { return "<tr><td>" + esc(s[0]) + "</td><td>" + fmt(s[1]) + "%</td><td></td></tr>"; }).join("") + "</table></div></div>";
    out += "<h2>" + esc(U.skills) + "</h2>";
    h.sk.forEach(function (s, i) {
      out += "<div class='row'>" + img("s/" + s.img + ".webp", "", s.n, hq(h)) + "<div><div class='t'>" + esc(s.n) + " <span class='mut'>" + esc(i === 0 ? U.slot1 : i === 1 ? U.slot2 : U.talent + " " + (i - 1)) + "</span></div><div>" + esc(s.d) + "</div></div></div>";
    });
    var forms = [], seen = {};
    h.f.forEach(function (f) { if (!seen[f.img + f.n]) { seen[f.img + f.n] = 1; forms.push(f); } });
    if (forms.length > 1) {
      out += "<h2>" + esc(U.evolutions) + "</h2><div class='grid'>" + forms.map(function (f) { return "<div class='cell'>" + img("h/" + f.img + ".webp", "", f.n, hq(h)) + "<span>" + esc(f.n) + "</span></div>"; }).join("") + "</div>";
    }
    out += "<h2>" + esc(U.how_get) + "</h2><ul>";
    h.frag.forEach(function (fr) {
      var it = items[fr[0]]; if (!it) return;
      out += "<li>" + U.frag_rule.replace("{n}", fmt(fr[1])).replace("{item}", '<a href="#item/' + it.id + '">' + esc(it.n) + "</a>") + (sources["6:" + it.id] ? " " + esc(U.from) + " " + sources["6:" + it.id].join(", ") : "") + "</li>";
    });
    (sources["13:" + h.id] || []).forEach(function (s) { out += "<li>" + s + "</li>"; });
    out += "<li>" + esc(U.hero_more) + ' <a href="#systems/summon">' + esc(U.summon) + "</a></li></ul>";
    return out;
  };

  var LIMIT = 120;
  function pager(list, render, key) {
    var n = (pager[key] = pager[key] || LIMIT);
    return list.slice(0, n).map(render).join("") + (list.length > n ? '<button class="more" data-more="' + key + '">' + esc(U.more) + " (" + (list.length - n) + ")</button>" : "");
  }
  function itemRow(it) {
    return '<a class="row" href="#item/' + it.id + '" style="color:inherit">' + img("p/" + it.img + ".webp", "", it.n, it.q) + "<div><div class='t'>" + esc(it.n) + "</div><div class='mut'>" + itemDesc(it).slice(0, 160) + "</div></div></a>";
  }
  function cat(it) { return it.hero > 0 ? "frag" : it.k === 4 ? "box" : "other"; }
  var icat = null;
  views.items = function () {
    var list = W.items.filter(function (it) { return !icat || cat(it) === icat; }).sort(function (a, b) { return b.q - a.q || a.id - b.id; });
    var bar = "<div class='chips'>" + ["frag", "box", "other"].map(function (c) { return '<button class="chip' + (icat === c ? " on" : "") + '" data-c="' + c + '">' + esc(U["cat_" + c]) + "</button>"; }).join("") + "</div>";
    return "<h1>" + esc(U.items) + " <span class='mut'>(" + list.length + ")</span></h1>" + bar + pager(list, itemRow, "items" + icat);
  };
  views.item = function (id) {
    var it = items[id]; if (!it) return notFound();
    var out = "<h1>" + esc(it.n) + "</h1><div class='row'>" + img("p/" + it.img + ".webp", "", it.n, it.q) + "<div><p>" + itemDesc(it) + "</p>" + (it.lv > 0 ? "<p class='mut'>" + esc(U.use_level) + ": " + it.lv + "</p>" : "") + "</div></div>";
    if (heroByFrag[id]) { var h = heroes[heroByFrag[id]]; out += "<p>" + U.frag_rule.replace("{n}", fmt(it.nn)).replace("{item}", esc(it.n)) + " → <a href='#hero/" + h.id + "'>" + esc(h.n) + "</a></p>"; }
    var tb = it.box.filter(function (b) { return b[2] === 71 && tools[b[0]]; });
    if (tb.length) out += "<h2>" + esc(U.contains) + " <span class='mut'>(" + tb.length + ")</span></h2><ol>" + tb.map(function (b) { var t = tools[b[0]], h = heroes[t.hero]; return "<li>" + reward("71," + b[0] + "," + b[1]) + (h ? " → <a href='#hero/" + h.id + "'>" + esc(h.n) + "</a>" : (t.hn ? " → " + esc(t.hn) : "")) + "</li>"; }).join("") + "</ol>";
    else if (it.box.length && !it.box[0][2]) out += "<h2>" + esc(U.contains) + "</h2><p>" + reward(it.box.map(function (b) { return "6," + b[0] + "," + b[1]; }).join("|")) + "</p>";
    var s = sources["6:" + id];
    out += "<h2>" + esc(U.where) + "</h2>" + (s ? "<ul><li>" + s.join("</li><li>") + "</li></ul>" : "<p class='mut'>" + esc(U.no_source) + "</p>");
    return out;
  };
  views.equip = function () {
    var list = W.equip.slice().sort(function (a, b) { return b.q - a.q || a.id - b.id; });
    return "<h1>" + esc(U.equip) + " <span class='mut'>(" + list.length + ")</span></h1>" + pager(list, function (e) {
      return '<a class="row" href="#equip/' + e.id + '" style="color:inherit">' + img("p/" + e.img + ".webp", "", e.n, e.q) + "<div><div class='t'>" + esc(e.n) + "</div><div class='mut'>" + e.a.map(function (a) { return esc(a[0]) + " +" + esc(a[1]); }).join(" · ") + "</div></div></a>";
    }, "equip");
  };
  views.equip_one = function (id) {
    var e = equip[id]; if (!e) return notFound();
    var s = sources["7:" + id];
    return "<h1>" + esc(e.n) + "</h1><div class='row'>" + img("p/" + e.img + ".webp", "", e.n, e.q) + "<div>" + (e.d ? "<p>" + esc(e.d) + "</p>" : "") + "<p>" + e.a.map(function (a) { return esc(a[0]) + " +" + esc(a[1]); }).join("<br>") + "</p>" + (e.lv > 1 ? "<p class='mut'>" + esc(U.use_level) + ": " + e.lv + "</p>" : "") + "</div></div>" +
      "<h2>" + esc(U.where) + "</h2>" + (s ? "<ul><li>" + s.join("</li><li>") + "</li></ul>" : "<p class='mut'>" + esc(U.no_source) + "</p>");
  };
  // ---------- herramientas: tabla con icono, nombre, rareza, personaje, efecto y de donde sale
  function toolHero(t) {
    if (!t.hero) return "<span class='mut'>" + esc(TU.any) + "</span>";
    var h = heroes[t.hero];
    return h ? '<a class="rw" href="#hero/' + h.id + '">' + img("h/" + h.mf.img + ".webp", "", h.n, hq(h)) + esc(h.n) + "</a>" : esc(t.hn || "");
  }
  function toolQ(t) { return '<span class="tq" style="--phc:' + PAL[Math.max(0, Math.min(PAL.length - 1, t.q))] + '">' + esc((TU.qn || {})[t.q] || t.q) + "</span>"; }
  function toolEff(t, full) {
    var out = t.a.map(esc).join("<br>");
    (full ? t.sk : t.sk.slice(0, 1)).forEach(function (g) {
      out += "<div class='tsk'>" + (g[0] ? "<b class='mut small'>" + esc(g[0]) + "</b>" : "") + g[1].map(function (s) { return "<b>" + esc(s[0]) + "</b>" + (s[1] ? ": " + esc(full ? s[1] : s[1].slice(0, 220) + (s[1].length > 220 ? "…" : "")) : ""); }).join("<br>") + "</div>";
    });
    return out;
  }
  function toolSrc(t) {
    var s = (sources["71:" + t.id] || []).slice();
    var vistos = {};
    t.box.forEach(function (b) { if (items[b] && !vistos[items[b].n]) { vistos[items[b].n] = 1; s.push('<a href="#item/' + b + '">' + esc(items[b].n) + "</a>"); } });
    return s;
  }
  var tk = null;
  views.tools = function () {
    var kinds = {}; TOOLS.forEach(function (t) { kinds[t.k] = 1; });
    var bar = Object.keys(kinds).length > 1 ? "<div class='chips'>" + Object.keys(kinds).map(function (k) { return '<button class="chip' + (tk == k ? " on" : "") + '" data-k="' + k + '">' + esc(TU["k" + k]) + "</button>"; }).join("") + "</div>" : "";
    var list = TOOLS.filter(function (t) { return tk == null || t.k == tk; }).sort(function (a, b) { var o = {2: 0, 3: 1, 1: 2}; return b.q - a.q || o[a.k] - o[b.k] || a.id - b.id; });
    var help = (Object.keys(kinds).length > 1 ? esc(TU.help) + (TU.guard ? " " + esc(TU.help_g) : "") + " " : "") + esc(TU.help_lv);
    return "<h1>" + esc(TU.t) + " <span class='mut'>(" + list.length + ")</span></h1><p class='mut'>" + help + "</p>" + bar +
      "<div class='tblwrap'><table class='tools'><tr><th></th><th>" + [TU.name, TU.rarity, U.col_hero, TU.effect, U.where].map(esc).join("</th><th>") + "</th></tr>" +
      list.map(function (t) {
        var s = toolSrc(t);
        return "<tr><td>" + img("p/" + t.img + ".webp", "i", t.n, t.q) + "</td><td><a href='#tool/" + t.id + "'><b>" + esc(t.n) + "</b></a>" + (t.k > 1 || Object.keys(kinds).length > 1 ? "<div class='mut small'>" + esc(TU["k" + t.k]) + "</div>" : "") + "</td><td>" + toolQ(t) + "</td><td>" + toolHero(t) + "</td><td>" + toolEff(t) + "</td><td>" +
          (s.length ? "<ul class='tsrc'><li>" + s.slice(0, 3).join("</li><li>") + "</li></ul>" + (s.length > 3 ? "<a href='#tool/" + t.id + "'>+" + (s.length - 3) + "</a>" : "") : "<span class='mut'>–</span>") + "</td></tr>";
      }).join("") + "</table></div>" + "<p class='mut'>– " + esc(U.no_source) + "</p>";
  };
  views.tool = function (id) {
    var t = tools[id]; if (!t) return notFound();
    var s = toolSrc(t);
    return "<h1>" + esc(t.n) + "</h1><div class='row'>" + img("p/" + t.img + ".webp", "", t.n, t.q) + "<div><div class='chips'><span class='chip'>" + toolQ(t) + "</span><span class='chip'>" + esc(TU["k" + t.k]) + "</span></div>" +
      (t.d ? "<p>" + esc(t.d).replace(/\n/g, "<br>") + "</p>" : "") + "<p>" + esc(U.col_hero) + ": " + toolHero(t) + "</p><div>" + toolEff(t, true) + "</div><p class='mut'>" + esc(TU.help_lv) + "</p></div></div>" +
      "<h2>" + esc(U.where) + "</h2>" + (s.length ? "<ul><li>" + s.join("</li><li>") + "</li></ul>" : "<p class='mut'>" + esc(U.no_source) + "</p>") +
      "<p><a href='#tools'>← " + esc(TU.t) + "</a></p>";
  };
  var GROUPS = {hero: "formation herolevel skills curseseal talents rebirth equipment alloy summon support cultivate chronicles prohibitors artifacts helditem warsoul combo album herorank titles",
    pve: "stamina dungeons sweep towers guildcopy worldboss explore",
    pvp: "arena crossarena ninjaking ninjakingform guildwar guildwarform crossmine",
    guild: "guild",
    shop: "vip recharge premium passes flashoffers flashsale subscriptions milestones invite codes"};
  function groupOf(k) { for (var g in GROUPS) if ((" " + GROUPS[g] + " ").indexOf(" " + k + " ") >= 0) return g; return "other"; }
  views.systems = function () {
    var by = {};
    Object.keys(C.systems).forEach(function (k) { (by[groupOf(k)] = by[groupOf(k)] || []).push(k); });
    return "<h1>" + esc(U.systems) + "</h1>" + ["hero", "pve", "pvp", "guild", "shop", "other"].filter(function (g) { return by[g]; }).map(function (g) {
      return "<h2>" + esc(U["g_" + g] || g) + "</h2><div class='cards'>" + by[g].map(function (k) { return '<a class="card tile sys" href="#systems/' + k + '">' + (ART.sys[k] ? '<img class="thumb" loading="lazy" src="' + IMG + ART.sys[k] + '" alt="" onerror="this.remove()">' : "") + "<b>" + esc(C.systems[k].t) + "</b></a>"; }).join("") + "</div>";
    }).join("");
  };
  views.system = function (k) {
    var s = C.systems[k]; if (!s) return notFound();
    return head(ART.sys[k]) + "<h1>" + esc(s.t) + "</h1><div class='prose card'>" + s.b + "</div>";
  };
  views.events = function () {
    var keys = Object.keys(C.events).sort(function (a, b) { return a - b; });
    return "<h1>" + esc(U.events) + "</h1><p class='mut'>" + esc(U.events_help) + "</p>" + srvPick() + keys.map(function (t) {
      var e = editionOf(t);
      var ar = ART.ev[t] || {};
      return '<a class="row" href="#event/' + t + '" style="color:inherit">' + (ar.i || ar.h ? '<img class="i evi" loading="lazy" src="' + IMG + (ar.i || ar.h) + '" alt="" onerror="this.remove()">' : '<span class="i evi">' + ico("events", 28) + "</span>") + '<div><div class="t">' + esc(evName(t)) + "</div><div class='mut'>" + esc(C.events[t].s || "") + (e ? " · " + (e[2] <= now ? esc(upcoming() ? U.at_open : U.now_on) : esc(U.starts) + " " + date(e[2])) : "") + "</div></div></a>";
    }).join("");
  };
  // Requisito (21-oct): la columna param de activity_event_rewards segun lo que hace el servidor
  // con ella en cada catalogo (r = [hueco, param, premio, catalogo, grupo, peso]; comprobado en el
  // codigo desplegado: accumulated_tiers, recharge_tiers, daily_topup_gifts, buy_gold_rewards,
  // egg_prom, blessing_event, fortune_bag, group_buy, privilege_card, treasure_hunt,
  // christmas_romance, orders_world). Lo que no se reconoce: lista de premios con nombre o tal cual.
  function isRw(s) {
    return s && s.split(/[;|]/).every(function (q) {
      var f = q.split(","), ty = +f[0], id = +f[1];
      return f.length >= 3 && ((ty === 6 && items[id]) || (ty === 7 && equip[id]) || (ty === 71 && tools[id]) || (ty === 13 && heroes[id]) || (id === -1 && W.res[ty]));
    });
  }
  function rwList(s) { return s.split(/[;|]/).map(function (q) { return reward(q); }).join(" "); }
  function rq(k, o) {
    var s = (U.req || {})[k]; if (!s) return null;
    return esc(s).replace(/\{(\w+)\}/g, function (_m, n) { return o[n] != null ? o[n] : ""; });
  }
  function reqText(r, t) {
    var s = String(r[1] == null ? "" : r[1]), ev = r[3], g = r[4], w = r[5] || 0, f = s.split(","), n = function (i) { return fmt(+f[i] || 0); };
    var gem = esc(W.res[2] || ""), out = null, per = function (x) { return rq(+x === 1 ? "per_day" : "per_ed", {}) || ""; };
    if (ev === "accumulated_tier") out = rq(+t === 17 ? "spend_total" : "topup_total", {n: n(0), gem: gem});
    else if (ev === "recharge_tier") out = (+t === 151 || +t === 152) ? rq("topup_exact", {n: n(0), gem: gem}) : +t === 45 ? rq("topup_single", {n: n(0), gem: gem}) : +t === 119 ? null : rq("topup_total", {n: n(0), gem: gem});
    else if (ev === "daily_topup_gift") out = rq("topup_today", {n: n(0), gem: gem});
    else if (ev === "sm_buy_gold" && f.length === 1 && (+t === 110 || +t === 115)) out = rq("spend_total", {n: n(0), gem: esc(W.res[+t === 110 ? 1 : 2] || "")});
    else if (ev === "sm_buy_gold") {  // lo que mide cada tipo: cabecera de buy_gold_rewards.erl
      var SM = {95: "gear_chests", 96: "gear_chests", 102: "buy_stamina", 103: "midas", 104: "points", 105: "tower_chests",
        106: "big_order", 108: "story", 109: "elite", 138: "alloy_draws", 140: "purify", 141: "points"};
      out = SM[+t] && f.length === 1 ? rq(SM[+t], {n: n(0), gem: gem}) : f.length === 2 ? rq("goal", {n: n(1)}) : null;
    }
    else if (ev === "login_gifts") out = rq("login_days", {n: n(0)});
    else if (ev === "rank_top_reward") out = rq("rank", {n: n(0)});
    else if (ev === "rank_power_reward") out = rq("power", {n: n(0)});
    else if (ev === "jackpot_rank" && f.length === 2) out = f[0] === f[1] ? rq("rank", {n: n(0)}) : rq("rank_range", {a: n(0), b: n(1)});
    else if (ev === "jackpot_pool") out = s === "special" ? rq("rare", {}) : "";
    else if (ev === "egg_buy" || (ev === "christmas_shop" && f.length >= 2)) out = rq(+f[1] > 0 ? "buy_max" : "buy", {p: n(0), gem: ev === "egg_buy" ? gem : esc((items[(W.ppx || {}).xcoin] || {}).n || ""), c: n(1)});
    else if (ev === "egg_recharge") out = rq("per_topup", {p: n(0), gem: gem, c: n(1)});
    else if (ev === "blessing_buy") out = rq("buy_max", {p: n(2), gem: gem, c: n(0)});
    else if (ev === "blessing_box" || ev === "christmas_box") out = rq("points", {n: n(0)});
    else if (ev === "blessing_spree") out = r[0] === 0 ? rq("spree", {p: fmt(w), gem: gem, c: n(1), per: per(f[0])}) : rq("choose", {});
    else if (ev === "fortune_exchange" && isRw(s)) out = rq("exchange", {x: rwList(s), c: fmt(w)});
    else if (ev === "fortune_match") out = g === 1 ? rq("all_pairs", {}) : isRw(s) ? rq("pair", {x: rwList(s)}) : null;
    else if (ev === "fortune_pool") out = s === "special" ? rq("rare", {}) : "";
    else if (ev === "group_buy_pack") {
      var steps = f.slice(2).map(function (x) { var y = x.split("-"); return +y[1] < 100 ? rq("disc", {n: fmt(+y[0]), d: 100 - +y[1]}) : null; }).filter(Boolean).join(", ");
      out = rq("pack", {p: fmt(w), gem: gem, c: n(0), per: per(f[1])}) + (steps ? " · " + steps : "");
    } else if (ev === "group_buy_topup") out = g === 0 ? rq("order", {p: fmt(w), gem: gem, c: n(0), per: per(f[1])}) : rq("orders_srv", {n: fmt(w)});
    else if (ev === "group_buy_award") out = rq(g === 1 ? "srv_goal" : "my_buys", {n: fmt(w)});
    else if (ev === "privilege_card") out = r[0] === 1 ? rq("card", {d: n(1)}) : r[0] === 2 ? rq("card_daily", {}) : "";
    else if (ev === "treasure_item") out = isRw(s) ? rq("alt", {x: rwList(s)}) : "";
    else if (ev === "lucky_laba" && g === 1) out = rq("laba", {n: r[0]});  // hueco = carretes con el especial (lucky_laba.erl)
    else if (ev === "orders_shop" && isRw(s)) out = rq("price", {x: rwList(s), c: fmt(w)});
    if (out == null) out = isRw(s) ? rwList(s) : esc(s);
    var tot = 0;  // sorteos: probabilidad = peso / suma de pesos del mismo catalogo y grupo
    if ({egg_pool: 1, blessing_wish: 1, fortune_pool: 1}[ev] && w > 0) {
      ((W.ev.rw[t] || {})[r.ed] || []).forEach(function (x) { if (x[3] === ev && x[4] === g) tot += x[5] || 0; });
      if (tot) out += (out ? " · " : "") + rq("prob", {p: fmt(Math.round(w * 10000 / tot) / 100)});
    }
    return out;
  }
  views.event = function (t) {
    var ev = C.events[t]; if (!ev) return notFound();
    var e = editionOf(t), rw = W.ev.rw[t] || {}, ed = e && rw[e[1]] ? e[1] : (rw[0] ? 0 : null);
    var out = head((ART.ev[t] || {}).h) + "<h1>" + esc(evName(t)) + "</h1><div class='prose'>" + (W.evcli[t] && W.evcli[t].d ? "<p><i>" + esc(W.evcli[t].d) + "</i></p>" : "") + (ev.b || "<p>" + esc(ev.s || "") + "</p>") + "</div>";
    out += srvPick();
    if (e) out += "<p><b>" + esc(e[2] <= now ? (upcoming() ? U.at_open : U.now_on) : U.starts) + ":</b> " + date(Math.max(e[2], o0())) + " → " + date(e[3]) + "</p>";
    // sin las filas que no reparten nada (configuracion en param: sobre rojo 155, fin de la Navidad 181)
    var filas = ed != null ? rw[ed].map(function (r) {
      // blessing_buy no lleva premio: cada compra da f[1] fichas, el objeto 2841 (blessing_event.erl)
      if (r[3] === "blessing_buy" && !r[2] && items[2841]) { r = r.slice(); r[2] = "6,2841," + (String(r[1]).split(",")[1] || 1); }
      return r;
    }).filter(function (r) { return reward(r[2]); }) : [];
    if (filas.length) {
      out += "<h2>" + esc(U.rewards) + "</h2><table><tr><th>#</th><th>" + esc(U.requirement) + "</th><th>" + esc(U.rewards) + "</th></tr>";
      filas.forEach(function (r) { r.ed = ed; out += "<tr><td>" + r[0] + "</td><td>" + reqText(r, t) + "</td><td>" + reward(r[2]) + "</td></tr>"; });
      out += "</table><p class='mut'>" + esc(U.rewards_note) + "</p>";
    }
    return out + nextEditions(t);
  };
  // ---------- proximas ediciones de un evento (cal.js: "fut" por servidor y "pp", 20-oct).
  // Premio principal = el personaje VISIBLE de mas calidad que da la edicion (entero o por
  // fragmentos); los ocultos no estan en W.heroes y no se pintan.
  // Sin personaje (21-oct): los 3 objetos/equipos/herramientas de mas calidad que reparte la
  // edicion, con su cantidad total (los que la wiki no tiene -relleno, ocultos- no se pintan);
  // si no reparte ninguno, los 2 recursos que mas reparte (Diamantes, Oro...).
  function ppOf(t, ed) {
    var p = (EV.pp || {})[t] || {}, l = p[ed] || p[0] || [];
    if (l.length || !(W.ppx || {})[t]) return l;  // premio de tabla del cliente (gen/wiki.py premios_cliente)
    return String(W.ppx[t]).split("|").map(function (q) { var f = q.split(","); return [+f[0], +f[1], +f[2]]; });
  }
  function mainPrize(t, ed) {
    var best = null;
    ppOf(t, ed).forEach(function (x) {
      var h = heroes[x[0] === 13 ? x[1] : x[0] === 6 ? heroByFrag[x[1]] : -1];
      if (h && h.n && (!best || h.q > best.q)) best = h;
    });
    return best;
  }
  function mainItems(t, ed) {
    var src = {6: items, 7: equip, 71: tools};
    return ppOf(t, ed).filter(function (x) { return src[x[0]] && src[x[0]][x[1]]; })
      .sort(function (a, b) { return (src[b[0]][b[1]].q || 0) - (src[a[0]][a[1]].q || 0) || b[2] - a[2]; })
      .slice(0, 3).map(function (x) { return reward(x.join(",")); }).join(" ") ||
      ppOf(t, ed).filter(function (x) { return !(x[0] in src) && x[0] !== 13; })
      .sort(function (a, b) { return b[2] - a[2]; }).slice(0, 2).map(function (x) { return reward(x.join(",")); }).join(" ");
  }
  function nextEditions(t) {
    var fut = ((EV.srv[srv] || {}).fut || []).filter(function (r) { return r[0] == t && r[2] > now; }).slice(0, 5);
    if (!fut.length) return "";
    var s1 = srv != SRVS[0] && EV.srv[SRVS[0]] ? (EV.srv[SRVS[0]].fut || []).concat(EV.srv[SRVS[0]].cal) : null;
    var out = "<h2>" + esc(U.next_eds) + "</h2><p class='mut'>" + esc(String(U.next_note || "").replace("%s", srv)) + "</p><table><tr><th>" + esc(U.server) + " " + esc(srv) + "</th>" +
      (s1 ? "<th>" + esc(U.server) + " " + esc(SRVS[0]) + "</th>" : "") + "<th>" + esc(U.main_prize) + "</th></tr>";
    fut.forEach(function (r) {
      var h = mainPrize(t, r[1]), o = s1 && s1.filter(function (x) { return x[0] == t && x[1] == r[1]; })[0];
      out += "<tr><td>" + date(r[2]) + " → " + date(r[3]) + "</td>" + (s1 ? "<td class='mut'>" + (o ? date(o[2]) : "—") + "</td>" : "") +
        "<td>" + (h ? '<a class="rw" href="#hero/' + h.id + '">' + img("h/" + h.mf.img + ".webp", "", h.n, hq(h)) + esc(h.n) + "</a>" : (mainItems(t, r[1]) || "<span class='mut'>—</span>")) + "</td></tr>";
    });
    return out + "</table>";
  }
  views.calendar = function () {
    var all = W.ev.cal.filter(function (r) { return C.events[r[0]]; }).sort(function (a, b) { return a[2] - b[2]; });
    var LONG = 60 * 86400, perm = all.filter(function (r) { return r[3] - r[2] > LONG && r[2] <= now; });
    var rows = all.filter(function (r) { return !(r[3] - r[2] > LONG && r[2] <= now); });
    var on = rows.filter(function (r) { return r[2] <= now && r[3] > now; }), next = rows.filter(function (r) { return r[2] > now; });
    function li(r) { return "<li><a href='#event/" + r[0] + "'>" + esc(evName(r[0])) + "</a> <span class='mut'>" + date(Math.max(r[2], o0())) + " → " + date(r[3]) + "</span></li>"; }
    var out = "<h1>" + esc(U.calendar) + "</h1><p class='mut'>" + esc(U.cal_help) + " " + esc(U.srv_help) + " " + esc(U.updated) + ": " + date(W.ev.ts) + "</p>" + srvPick();
    var g = (W.gates || []).map(function (x) { var t = o0() + x[3] * 86400; return "<li>" + esc(x[1]) + " <span class='mut'>→ " + date(t) + (t <= Date.now() / 1000 ? " ✓" : "") + "</span></li>"; }).join("");
    if (g && o0()) out += "<h2>" + esc(U.gates) + "</h2><ul>" + g + "</ul>";
    out += "<h2>" + esc(upcoming() ? U.at_open : U.now_on) + " (" + on.length + ")</h2><ul>" + on.map(li).join("") + "</ul>";
    var byDay = {};
    next.forEach(function (r) { var d = new Date(r[2] * 1000).toLocaleDateString(W.lang.replace("_", "-"), {weekday: "long", day: "numeric", month: "long"}); (byDay[d] = byDay[d] || []).push(r); });
    out += "<h2>" + esc(U.coming) + "</h2>";
    var permHtml = perm.length ? "<h2>" + esc(U.always) + " (" + perm.length + ")</h2><ul>" + perm.map(function (r) { return "<li><a href='#event/" + r[0] + "'>" + esc(evName(r[0])) + "</a></li>"; }).join("") + "</ul>" : "";
    Object.keys(byDay).forEach(function (d) { out += "<div class='cal-day'><h3>" + esc(d) + "</h3><ul>" + byDay[d].map(li).join("") + "</ul></div>"; });
    return out + permHtml;
  };
  views.faq = function () {
    var out = "<h1>" + esc(U.faq) + "</h1><div class='prose'>";
    (C.faq || []).forEach(function (f) { out += "<h3>" + esc(f.q) + "</h3>" + f.a; });
    var g = null;
    W.faq.forEach(function (f) { if (f.g !== g) { g = f.g; out += "<h2>" + esc(g) + "</h2>"; } out += "<h3>" + esc(f.q) + "</h3><p>" + esc(f.a) + "</p>"; });
    return out + "</div>";
  };
  views.links = function (embedded) {
    var c = W.cfg, wa = c.wa || {}, l2 = W.lang.split("_")[0];
    var L = [[U.download + " · 32 bits", c.dl32, "download"], [U.download + " · 64 bits", c.dl64, "download"], [U.web_pay, c.web, "links"],
      [U.wa_community || "WhatsApp Community", c.wa_comunidad, "group"], [U.whatsapp, wa[l2] || wa.en || c.whatsapp, "group"], [U.messenger, c.messenger, "chat"], ["Facebook", c.facebook, "fb"], [U.fb_group || "Facebook group", c.fbgroup, "fb"], ["Discord", c.discord, "chat"]].filter(function (l) { return l[1]; });
    return (embedded ? "<h2>" : "<h1>") + esc(U.links) + (embedded ? "</h2>" : "</h1>") + "<div class='cards'>" + L.map(function (l) { return '<a class="card tile" target="_blank" rel="noopener" href="' + esc(l[1]) + '"><span class="tico">' + ico(l[2], 26) + "</span><span><b>" + esc(l[0]) + "</b><span class='mut'>" + esc(l[1].replace(/^https?:\/\//, "").slice(0, 60)) + "</span></span></a>"; }).join("") + "</div>" +
      (c.dl32 && c.dl64 ? "<p class='mut'>" + esc(U.dl_help) + "</p>" : "");
  };
  // ---------- tier list y equipos: simulados con el motor real (sim/tiersim.py)
  var TAGN = {dmg: U.st_dmg, taken: U.st_taken, heal: U.st_heal, buff: U.st_buff, ctrl: U.st_ctrl};
  function tagChips(id) { var t = TL[id]; return t ? t.g.map(function (g) { return "<span class='chip tag'>" + esc(TAGN[g] || g) + "</span>"; }).join("") : ""; }
  function roleName(r) { return U["r_" + r] || r; }
  function pc(v) { return v == null ? "–" : fmt(v) + " %"; }
  function tb(t) { return "<span class='tierbadge t" + t + "'>" + t + "</span>"; }
  function srcChips(id) {
    var t = TL[id]; if (!t || !t.src) return "";
    var s = t.src, out = [];
    if (s.pool) out.push(U.src_pool);
    if (s.shop) out.push(U.src_shop);
    s.ev.slice(0, 2).forEach(function (e) { if (C.events[e] || W.evcli[e]) out.push('<a href="#event/' + e + '">' + esc(evName(e)) + "</a>"); else out.push(esc(U.src_event)); });
    if (s.own) out.push(esc(U.src_own.replace("{n}", fmt(s.own)).replace("{p}", fmt(Math.round(100 * s.own_f2p / s.own)))));
    return out.length ? "<div class='mut small'>" + out.map(function (x) { return x.charAt(0) === "<" ? x : esc(x); }).join(" · ") + "</div>" : "";
  }
  views.tier = function () {
    var out = "<h1>" + esc(U.tier) + "</h1><p class='note'>" + esc(U.tier_note) + "</p>";
    var all = Object.keys(TL).filter(function (i) { return heroes[i]; }).sort(function (x, y) { return TL[y].s - TL[x].s; });
    ["dps", "tank", "support", "control"].forEach(function (r) {
      var ids = all.filter(function (i) { return TL[i].r === r; });
      if (!ids.length) return;
      out += "<h2>" + esc(roleName(r)) + "</h2>";
      ["S", "A", "B", "C", "D"].forEach(function (t) {
        var fila = ids.filter(function (i) { return TL[i].t === t; });
        if (fila.length) out += "<div class='tierrow'>" + tb(t) + "<div class='grid'>" + fila.map(function (i) { return heroCell(heroes[i]).replace("</span></a>", "</span><b class='wr'>" + fmt(TL[i].s) + " %</b></a>"); }).join("") + "</div></div>";
      });
    });
    // el porque de cada uno
    out += "<h2>" + esc(U.tier_why) + "</h2><div class='tblwrap'><table class='why'><tr><th>" + [U.col_hero, U.tier, U.col_role, "PvP", "PvE", "1v1", U.col_use, U.col_strong].map(esc).join("</th><th>") + "</th></tr>";
    all.forEach(function (i) {
      var t = TL[i], h = heroes[i];
      var modo = t.te && t.tp !== t.te ? "<div class='mut small'>PvP " + t.tp + " · PvE " + t.te + "</div>" : "";
      if (t.ts) modo += "<div class='mut small'>" + esc(U.tier_capped) + "</div>";
      var prov = t.cov < 0.6 && (t.t === "S" || t.t === "A") ? "<div class='mut small'>" + esc(U.tier_cov_low.replace("{p}", fmt(Math.round(100 * t.cov)))) + "</div>" : "";
      var uso = t.u ? fmt(Math.round(100 * t.u[0] / t.u[1])) + " % <span class='mut small'>(" + t.u[0] + "/" + t.u[1] + ")</span>" : "–";
      out += "<tr><td><a href='#hero/" + i + "'>" + esc(h.n) + "</a>" + (t.cov < 0.6 ? " <span class='mut' title='" + esc(U.tier_cov) + "'>*</span>" : "") + (t.f2p ? " <span class='chip f2p'>F2P</span>" : "") + prov + "</td><td>" + tb(t.t) + modo + "</td><td>" + esc(roleName(t.r)) + "</td><td>" + pc(t.w.six) + "</td><td>" + pc(t.w.pve) + "</td><td>" + pc(t.w.duel) + "</td><td>" + uso + "</td><td>" + t.g.map(function (g) { return esc(TAGN[g] || g); }).join(", ") + "</td></tr>";
    });
    out += "</table></div><p class='mut'>* " + esc(U.tier_cov) + "</p>" + (U.tier_use ? "<p class='mut'>" + esc(U.tier_use) + "</p>" : "");
    return out + "<p class='mut'>" + esc(U.tier_formula) + "</p>";
  };
  views.teams = function () {
    var out = "<h1>" + esc(U.teams) + "</h1><p class='note'>" + esc(U.teams_note) + "</p>";
    [["general", false], ["f2p", true], ["pvp", false], ["pve", false]].forEach(function (b) {
      var eq = TEAMS[b[0]];
      if (!eq || !eq.ids) return;
      var cell = function (i) { return heroes[i] ? "<div>" + heroCell(heroes[i]) + (b[1] ? srcChips(i) : "") + "</div>" : ""; };
      out += "<div class='card team'><h3>" + esc(U["team_" + b[0]]) + "</h3><p class='mut'>" + esc(U["team_" + b[0] + "_d"]) + "</p>" +
        "<p><b>" + esc(U.team_rate.replace("{a}", fmt(Math.round(100 * eq.pvp))).replace("{b}", fmt(Math.round(100 * eq.pve)))) + "</b></p>" +
        "<div class='rowlbl'>" + esc(U.front) + "</div><div class='grid'>" + eq.ids.slice(0, 3).map(cell).join("") + "</div>" +
        "<div class='rowlbl'>" + esc(U.back) + "</div><div class='grid'>" + eq.ids.slice(3).map(cell).join("") + "</div>";
      if (eq.alts && eq.alts.length) {
        out += "<div class='rowlbl'>" + esc(U.team_alts) + "</div><ul>" + eq.alts.filter(function (a) { return heroes[a.out] && heroes[a["in"]]; }).map(function (a) {
          return "<li>" + U.team_alt.replace("{out}", '<a href="#hero/' + a.out + '">' + esc(heroes[a.out].n) + "</a>").replace("{in}", '<a href="#hero/' + a["in"] + '">' + esc(heroes[a["in"]].n) + "</a>") + "</li>";
        }).join("") + "</ul>";
      }
      out += "</div>";
    });
    return out;
  };
  function notFound() { return "<p>" + esc(U.not_found) + "</p>"; }

  // ---------- busqueda global
  var INDEX = [];
  W.heroes.forEach(function (h) { if (h.n) INDEX.push([norm(h.n + " " + h.f.map(function (f) { return f.n; }).join(" ")), "#hero/" + h.id, h.n, "h/" + h.mf.img, U.heroes, hq(h)]); });
  W.items.forEach(function (it) { INDEX.push([norm(it.n), "#item/" + it.id, it.n, "p/" + it.img, U.items, it.q]); });
  W.equip.forEach(function (e) { INDEX.push([norm(e.n), "#equip/" + e.id, e.n, "p/" + e.img, U.equip, e.q]); });
  TOOLS.forEach(function (t) { INDEX.push([norm(t.n + " " + (t.hero && heroes[t.hero] ? heroes[t.hero].n : t.hn || "")), "#tool/" + t.id, t.n, "p/" + t.img, TU.t, t.q]); });
  Object.keys(C.systems).forEach(function (k) { INDEX.push([norm(C.systems[k].t + " " + C.systems[k].b.replace(/<[^>]+>/g, " ")), "#systems/" + k, C.systems[k].t, null, U.systems]); });
  Object.keys(C.events).forEach(function (t) { INDEX.push([norm(evName(t) + " " + C.events[t].n + " " + (C.events[t].s || "")), "#event/" + t, evName(t), null, U.events]); });
  views.search = function (q) {
    var words = norm(q).split(/\s+/).filter(Boolean);
    var hits = INDEX.filter(function (x) { return words.every(function (w) { return x[0].indexOf(w) >= 0; }); })
      .sort(function (a, b) { return (norm(a[2]).indexOf(words[0]) === 0 ? 0 : 1) - (norm(b[2]).indexOf(words[0]) === 0 ? 0 : 1); });
    return "<h1>" + esc(U.search) + ": " + esc(q) + " <span class='mut'>(" + hits.length + ")</span></h1>" + hits.slice(0, 200).map(function (x) {
      return '<a class="row" href="' + x[1] + '" style="color:inherit">' + (x[3] ? img(x[3] + ".webp", "", x[2], x[5]) : "") + "<div><div class='t'>" + esc(x[2]) + "</div><div class='mut'>" + esc(x[4]) + "</div></div></a>";
    }).join("");
  };

  // ---------- router
  function route() {
    var h = decodeURIComponent(location.hash.slice(1)), p = h.split("/"), html, sec = p[0] || "home";
    if (p[0] === "search") html = views.search(p.slice(1).join("/"));
    else if (p[0] === "hero" && p[1]) { html = views.hero(+p[1]); sec = "heroes"; }
    else if (p[0] === "item" && p[1]) { html = views.item(+p[1]); sec = "items"; }
    else if (p[0] === "equip" && p[1]) { html = views.equip_one(+p[1]); sec = "equip"; }
    else if (p[0] === "systems" && p[1]) html = views.system(p[1]);
    else if (p[0] === "event" && p[1]) { html = views.event(p[1]); sec = "events"; }
    else if (p[0] === "tool" && p[1]) { html = views.tool(+p[1]); sec = "tools"; }
    else html = (views[p[0]] || views.home)();
    $("#main").innerHTML = html;
    [].forEach.call(document.querySelectorAll("#nav a"), function (a) { a.className = a.getAttribute("href") === "#" + sec ? "on" : ""; });
    if (p[0] !== "search") window.scrollTo(0, 0);
    reveal();
  }
  var io = ("IntersectionObserver" in window) ? new IntersectionObserver(function (es) {
    es.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); } });
  }, {rootMargin: "0px 0px -8% 0px"}) : null;
  function reveal() {
    [].forEach.call(document.querySelectorAll("#main .card, #main .row, #main .cell, #main .hero-banner"), function (el, i) {
      if (!io) { el.classList.add("in"); return; }
      el.style.transitionDelay = Math.min(i % 12, 11) * 25 + "ms";
      io.observe(el);
    });
  }
  $("#main").addEventListener("change", function (e) {
    if (e.target.id !== "srv") return;
    setSrv(e.target.value);
    buildSources();
    try { localStorage.setItem(SKEY, srv); } catch (x) {}
    route();
  });
  $("#main").addEventListener("click", function (e) {
    var b = e.target.closest("button"); if (!b) return;
    if (b.dataset.k) { tk = tk == b.dataset.k ? null : b.dataset.k; route(); }
    if (b.dataset.c) { icat = icat === b.dataset.c ? null : b.dataset.c; route(); }
    if (b.dataset.f) { hf[b.dataset.f] = hf[b.dataset.f] == b.dataset.v ? null : b.dataset.v; route(); }
    if (b.dataset.more) { pager[b.dataset.more] = (pager[b.dataset.more] || LIMIT) + 400; var y = window.scrollY; route(); window.scrollTo(0, y); }
  });
  var tq;
  $("#q").placeholder = U.search_ph;
  $("#q").addEventListener("input", function () {
    clearTimeout(tq); var v = this.value.trim();
    tq = setTimeout(function () { if (v.length >= 2) history.replaceState(null, "", "#search/" + encodeURIComponent(v)); else if (!v) history.replaceState(null, "", "#"); route(); }, 200);
  });
  $(".brand").textContent = W.cfg.nombre;
  $("#nav").innerHTML = SECTIONS.map(function (s) { return '<a href="#' + s[0] + '">' + navIcon(s[0]) + "<span>" + esc(s[1]) + "</span></a>"; }).join("");
  $("#lang").innerHTML = Object.keys(LANGS).map(function (l) { return "<option value='" + l + "'" + (l === W.lang ? " selected" : "") + ">" + LANGS[l] + "</option>"; }).join("");
  $("#lang").addEventListener("change", function () { try { localStorage.setItem("wiki_lang", this.value); } catch (e) {} location.href = "../" + this.value + "/index.html" + location.hash; });
  // ---------- asistente (bot) dentro de la wiki; si el servidor no contesta, Messenger
  var chatBox = document.createElement("div");
  chatBox.id = "chat";
  chatBox.innerHTML = '<button class="fab bot-fab" aria-label="' + esc(U.chat_title) + '">' + ico("chat", 26) + '<span>' + esc(U.bot) + '</span></button>' +
    '<div class="panel" hidden><div class="phead">' + ico("chat") + '<b>' + esc(U.chat_title) + '</b><button class="x" aria-label="close">' + ico("close") + '</button></div>' +
    '<div class="msgs"><div class="m bot">' + esc(U.chat_hello) + '</div></div>' +
    '<form><input maxlength="500" autocomplete="off" placeholder="' + esc(U.chat_ph) + '"><button aria-label="' + esc(U.chat_send) + '">' + ico("send") + '</button></form></div>';
  document.body.appendChild(chatBox);
  var panel = chatBox.querySelector(".panel"), msgs = chatBox.querySelector(".msgs"), sid = "";
  function addMsg(t, who, html) { var d = document.createElement("div"); d.className = "m " + who; if (html) d.innerHTML = t; else d.textContent = t; msgs.appendChild(d); msgs.scrollTop = msgs.scrollHeight; return d; }
  chatBox.querySelector(".bot-fab").onclick = function () { panel.hidden = !panel.hidden; if (!panel.hidden) chatBox.querySelector("input").focus(); };
  chatBox.querySelector(".x").onclick = function () { panel.hidden = true; };
  chatBox.querySelector("form").onsubmit = function (e) {
    e.preventDefault();
    var inp = this.querySelector("input"), q = inp.value.trim();
    if (!q) return;
    inp.value = ""; addMsg(q, "me");
    var wait = addMsg("…", "bot");
    var fallo = function () { wait.innerHTML = esc(U.chat_fail) + (W.cfg.messenger ? ' <a target="_blank" rel="noopener" href="' + esc(W.cfg.messenger) + '">Messenger</a>' : ""); };
    if (!window.fetch || location.protocol === "file:") return fallo();
    fetch("/wiki/chat", {method: "POST", headers: {"Content-Type": "application/json"}, body: JSON.stringify({game: W.game, lang: W.lang, q: q, sid: sid})})
      .then(function (r) { if (!r.ok) throw r; return r.json(); })
      .then(function (j) { if (j && j.sid) sid = j.sid; if (j && j.answer) wait.textContent = j.answer; else fallo(); })
      .catch(fallo);
  };
  // ---------- WhatsApp: enlaces directos, sin menu que abrir (en el movil el menu fallaba)
  var waGroup = (W.cfg.wa || {})[W.lang.split("_")[0]] || (W.cfg.wa || {}).en || W.cfg.whatsapp;  // 22-oct: idioma sin grupo propio -> el de ingles, como la web
  if (waGroup || W.support_wa) {
    var wa = document.createElement("div");
    wa.id = "wa";
    wa.innerHTML = (W.support_wa ? '<a class="wa-pill" target="_blank" rel="noopener" href="https://wa.me/' + encodeURIComponent(W.support_wa) + '">' + WA_SVG + "<span>" + esc(U.wa_support) + "</span></a>" : "") +
      (waGroup ? '<a class="wa-pill wa-main" target="_blank" rel="noopener" href="' + esc(waGroup) + '">' + WA_SVG + "<span>" + esc(U.wa_group) + "</span></a>" : "");
    document.body.appendChild(wa);
  }
  $("#foot").textContent = U.footer + " · " + W.built;
  document.documentElement.lang = W.lang.replace("_", "-");
  window.addEventListener("hashchange", route);
  route();
})();
