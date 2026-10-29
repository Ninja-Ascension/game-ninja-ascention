// Fase 1b — natives de protocolo (fidelidade libjts.so) — versão PLAIN-C nos
// userdata (sem STL: allocator CRT do engine difere; ver Porto note).
#include "NinjaProtoNatives.h"
#include "blowfish_tables.h"

extern "C" {
#include "lua.h"
#include "lauxlib.h"
}

#include "zlib.h"
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <map>

// Fase 1b-2: XHR nativo (axmol HttpClient)
#include "network/HttpClient.h"
#include "base/Director.h"
#include "lua-bindings/manual/LuaEngine.h"

namespace nrproto {

// ============================ GameBlowfish ================================
GameBlowfish::GameBlowfish() {
    memcpy(P_, GAME_P, sizeof(P_));
    memcpy(S_, GAME_S, sizeof(S_));
    iv_[0] = iv_[1] = 0;
}

static inline uint32_t loadLE(const uint8_t* p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static inline void storeLE(uint8_t* p, uint32_t v) {
    p[0] = uint8_t(v); p[1] = uint8_t(v >> 8);
    p[2] = uint8_t(v >> 16); p[3] = uint8_t(v >> 24);
}

static inline uint32_t bfF(const uint32_t* S, uint32_t x) {
    uint32_t a = (x >> 24) & 0xFF, b = (x >> 16) & 0xFF;
    uint32_t c = (x >> 8) & 0xFF, d = x & 0xFF;
    return ((S[a] + S[256 + b]) ^ S[512 + c]) + S[768 + d];
}

void GameBlowfish::encryptBlock(uint32_t& xl, uint32_t& xr) {
    for (int i = 0; i < 16; i += 2) {
        xl ^= P_[i];      xr ^= bfF(S_, xl);
        xr ^= P_[i + 1];  xl ^= bfF(S_, xr);
    }
    uint32_t t = xl; xl = xr; xr = t;
    xr ^= P_[16]; xl ^= P_[17];
}

void GameBlowfish::decryptBlock(uint32_t& xl, uint32_t& xr) {
    for (int i = 16; i > 0; i -= 2) {
        xl ^= P_[i + 1];  xr ^= bfF(S_, xl);
        xr ^= P_[i];      xl ^= bfF(S_, xr);
    }
    uint32_t t = xl; xl = xr; xr = t;
    xr ^= P_[0]; xl ^= P_[1];
}

void GameBlowfish::setKey(const uint8_t* key, uint32_t len) {
    if (!key || len == 0) return;
    if (len > 56) len = 56;
    memcpy(P_, GAME_P, sizeof(P_));
    memcpy(S_, GAME_S, sizeof(S_));
    {
        uint32_t j = 0;
        for (int i = 0; i < 18; ++i) {
            uint32_t acc = 0;
            for (int k = 0; k < 4; ++k) {
                acc = (acc << 8) | key[j];
                j = (j + 1) % len;
            }
            P_[i] ^= acc;
        }
    }
    uint32_t xl = 0, xr = 0;
    for (int i = 0; i < 18; i += 2) { encryptBlock(xl, xr); P_[i] = xl; P_[i + 1] = xr; }
    for (int i = 0; i < 1024; i += 2) { encryptBlock(xl, xr); S_[i] = xl; S_[i + 1] = xr; }
}

static void mode0(uint8_t* p) {
    uint8_t t;
    for (int i = 0; i < 4; ++i) { t = p[i]; p[i] = p[4 + i]; p[4 + i] = t; }
}

static void runBlocks(uint8_t* d, int len, GameBlowfish* self, bool enc) {
    for (int o = 0; o < len; o += 8) {
        uint32_t l = loadLE(d + o), r = loadLE(d + o + 4);
        if (enc) self->encryptBlock(l, r); else self->decryptBlock(l, r);
        storeLE(d + o, l); storeLE(d + o + 4, r);
    }
}

void GameBlowfish::encrypt(uint8_t* data, int len, uint32_t mode) {
    if (len <= 0 || (len & 7)) return;
    if (mode == 0) { for (int o = 0; o < len; o += 8) mode0(data + o); return; }
    runBlocks(data, len, this, true);
}

void GameBlowfish::decrypt(uint8_t* data, int len, uint32_t mode) {
    if (len <= 0 || (len & 7)) return;
    if (mode == 0) { for (int o = 0; o < len; o += 8) mode0(data + o); return; }
    runBlocks(data, len, this, false);
}

void GameBlowfish::encrypt(const uint8_t* src, uint8_t* dst, int len, uint32_t mode) {
    memcpy(dst, src, len); encrypt(dst, len, mode);
}
void GameBlowfish::decrypt(const uint8_t* src, uint8_t* dst, int len, uint32_t mode) {
    memcpy(dst, src, len); decrypt(dst, len, mode);
}

// ============================ helpers =====================================
void cipherMode0(uint8_t* data, int len) {
    if (len <= 0) return;
    for (int o = 0; o + 8 <= len; o += 8) mode0(data + o);
}

std::vector<uint8_t> deflateZlib(const uint8_t* data, size_t n) {
    std::vector<uint8_t> out;
    if (!n) return out;
    z_stream zs; memset(&zs, 0, sizeof(zs));
    if (deflateInit(&zs, 9) != Z_OK) return out;      // level 9 (original)
    zs.next_in = const_cast<uint8_t*>(data);
    zs.avail_in = (uInt)n;
    out.resize(n + 64);
    zs.next_out = out.data(); zs.avail_out = (uInt)out.size();
    int r = deflate(&zs, Z_FINISH);
    if (r == Z_STREAM_END) out.resize(zs.total_out);
    else out.clear();
    deflateEnd(&zs);
    return out;
}

std::vector<uint8_t> inflateZlib(const uint8_t* data, size_t n) {
    std::vector<uint8_t> out;
    if (!n) return out;
    z_stream zs; memset(&zs, 0, sizeof(zs));
    if (inflateInit(&zs) != Z_OK) return out;
    zs.next_in = const_cast<uint8_t*>(data);
    zs.avail_in = (uInt)n;
    // Compressed size does not bound decompressed size (scene vectors exceed
    // the previous 8x assumption). Grow until a complete stream is decoded.
    const size_t limit = 64u * 1024u * 1024u;
    out.resize(4096);
    for (;;) {
        const size_t used = static_cast<size_t>(zs.total_out);
        zs.next_out = out.data() + used;
        zs.avail_out = static_cast<uInt>(out.size() - used);
        const uLong before = zs.total_out;
        const int r = inflate(&zs, Z_NO_FLUSH);
        if (r == Z_STREAM_END) { out.resize(zs.total_out); break; }
        if ((r != Z_OK && r != Z_BUF_ERROR) ||
            (zs.total_out == before && zs.avail_out != 0)) { out.clear(); break; }
        if (zs.avail_out == 0) {
            if (out.size() >= limit) { out.clear(); break; }
            out.resize(out.size() * 2);
        } else if (zs.avail_in == 0) { out.clear(); break; }
    }
    inflateEnd(&zs);
    return out;
}

// ====================== Lua: DBytes (plain malloc) ========================
struct LBytes { uint8_t* p; size_t n; };

static LBytes* lb_self(lua_State* L, int i) {
    return (LBytes*)luaL_checkudata(L, i, "cc.DBytes");
}
static LBytes* lb_alloc(lua_State* L, size_t n) {
    LBytes* b = (LBytes*)lua_newuserdata(L, sizeof(LBytes));
    b->n = n;
    b->p = (uint8_t*)malloc(n ? n : 1);
    memset(b->p, 0, n ? n : 1);
    luaL_getmetatable(L, "cc.DBytes");
    lua_setmetatable(L, -2);
    return b;
}
static int dbytes_new(lua_State* L) {
    size_t n = 0;
    const char* s = (lua_type(L, 1) == LUA_TSTRING) ? lua_tolstring(L, 1, &n) : nullptr;
    LBytes* b = lb_alloc(L, n);
    if (n && s) memcpy(b->p, s, n);
    return 1;
}
static int dbytes_getBytes(lua_State* L) {
    LBytes* b = lb_self(L, 1);
    lua_pushlstring(L, (const char*)b->p, b->n);
    return 1;
}
static int dbytes_getSize(lua_State* L) {
    LBytes* b = lb_self(L, 1);
    lua_pushinteger(L, (lua_Integer)b->n);
    return 1;
}
static int dbytes_copy(lua_State* L) {
    LBytes* b = lb_self(L, 1);
    LBytes* o = lb_alloc(L, b->n);
    if (b->n) memcpy(o->p, b->p, b->n);
    return 1;
}
static int dbytes_release(lua_State* L) { (void)L; return 0; }
static int dbytes_gc(lua_State* L) {
    LBytes* b = lb_self(L, 1);
    if (b->p) { free(b->p); b->p = nullptr; }
    b->n = 0;
    return 0;
}
static int dbytes_newcall(lua_State* L) {
    lua_remove(L, 1);
    return dbytes_new(L);
}

// ====================== Lua: CBlowFish (plain) ============================
struct LBF { GameBlowfish* bf; };
static LBF* bf_self(lua_State* L, int i) {
    return (LBF*)luaL_checkudata(L, i, "cc.CBlowFish");
}
static int cbf_new(lua_State* L) {
    size_t n = 0;
    const char* k = (lua_type(L, 1) == LUA_TSTRING) ? lua_tolstring(L, 1, &n) : nullptr;
    LBF* w = (LBF*)lua_newuserdata(L, sizeof(LBF));
    w->bf = (GameBlowfish*)malloc(sizeof(GameBlowfish));
    memset(w->bf, 0, sizeof(GameBlowfish));
    *w->bf = GameBlowfish();                     // POD-ish (arrays only)
    if (k && n) w->bf->setKey((const uint8_t*)k, (uint32_t)n);
    luaL_getmetatable(L, "cc.CBlowFish");
    lua_setmetatable(L, -2);
    return 1;
}
static int cbf_newcall(lua_State* L) {
    lua_remove(L, 1);
    return cbf_new(L);
}
static int cbf_setKey(lua_State* L) {
    LBF* w = bf_self(L, 1);
    size_t n = 0;
    const char* k = (lua_type(L, 2) == LUA_TSTRING) ? lua_tolstring(L, 2, &n) : nullptr;
    if (k && n) w->bf->setKey((const uint8_t*)k, (uint32_t)n);
    return 0;
}
static int cbf_gc(lua_State* L) {
    LBF* w = (LBF*)luaL_checkudata(L, 1, "cc.CBlowFish");
    if (w->bf) { free(w->bf); w->bf = nullptr; }
    return 0;
}
// wrapper original (0x3a2d24): zero-pad + modo 0, substituindo o conteúdo
static int cbf_wrap(lua_State* L, bool enc) {
    LBF* w = bf_self(L, 1);
    LBytes* b = lb_self(L, 2);
    size_t n = b->n;
    size_t padded = (n % 8) ? (n + 8 - (n % 8)) : n;
    uint8_t* tmp = (uint8_t*)malloc(padded);
    memset(tmp, 0, padded);
    if (n) memcpy(tmp, b->p, n);
    if (enc) w->bf->encrypt(tmp, (int)padded, 0);
    else     w->bf->decrypt(tmp, (int)padded, 0);
    if (b->p) free(b->p);
    b->p = tmp; b->n = padded;
    lua_settop(L, 2);
    return 1;
}
static int cbf_encrypt(lua_State* L) { return cbf_wrap(L, true); }
static int cbf_decrypt(lua_State* L) { return cbf_wrap(L, false); }

static int cc_deflate(lua_State* L) {
    LBytes* b = lb_self(L, 1);
    std::vector<uint8_t> out = deflateZlib(b->p, b->n);
    if (out.empty()) { lua_pushboolean(L, 0); return 1; }
    if (b->p) free(b->p);
    b->n = out.size();
    b->p = (uint8_t*)malloc(b->n);
    memcpy(b->p, out.data(), b->n);
    lua_pushboolean(L, 1);
    return 1;
}
static int cc_inflate(lua_State* L) {
    LBytes* b = lb_self(L, 1);
    std::vector<uint8_t> out = inflateZlib(b->p, b->n);
    if (out.empty()) { lua_pushboolean(L, 0); return 1; }
    if (b->p) free(b->p);
    b->n = out.size();
    b->p = (uint8_t*)malloc(b->n);
    memcpy(b->p, out.data(), b->n);
    lua_pushboolean(L, 1);
    return 1;
}

// ====================== Lua: XHR (plain) ==================================
// Uso no acervo (NetworkAdaptor.lua 549-646); readyState 0..4 (DONE=4).
struct LXHR {
    ax::network::HttpRequest* request;   // propriedade do HttpClient em voo
    int handlerRef;
    int selfRef;
    int readyState;
    int status;
    int responseType;
    double timeout;
    uint8_t* body;
    size_t bodyN;
    bool sent;
};

static LXHR* xhr_self(lua_State* L, int i) {
    return (LXHR*)luaL_checkudata(L, i, "cc.XMLHttpRequest");
}

static int xhr_gc(lua_State* L) {
    LXHR* x = (LXHR*)luaL_checkudata(L, 1, "cc.XMLHttpRequest");
    if (x->handlerRef != -1) { luaL_unref(L, LUA_REGISTRYINDEX, x->handlerRef); x->handlerRef = -1; }
    if (x->selfRef != -1) { luaL_unref(L, LUA_REGISTRYINDEX, x->selfRef); x->selfRef = -1; }
    if (x->body) { free(x->body); x->body = nullptr; }
    x->bodyN = 0;
    return 0;
}

static int xhr_newcall(lua_State* L) {
    lua_remove(L, 1);
    LXHR* x = (LXHR*)lua_newuserdata(L, sizeof(LXHR));
    memset(x, 0, sizeof(LXHR));
    x->handlerRef = -1; x->selfRef = -1;
    x->readyState = 0; x->status = 0; x->responseType = 2;
    x->timeout = 30.0;
    luaL_getmetatable(L, "cc.XMLHttpRequest");
    lua_setmetatable(L, -2);
    return 1;
}

static int xhr_registerHandler(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    luaL_checktype(L, 2, LUA_TFUNCTION);
    if (x->handlerRef != -1) luaL_unref(L, LUA_REGISTRYINDEX, x->handlerRef);
    lua_pushvalue(L, 2);
    x->handlerRef = luaL_ref(L, LUA_REGISTRYINDEX);
    if (x->selfRef == -1) {
        lua_pushvalue(L, 1);
        x->selfRef = luaL_ref(L, LUA_REGISTRYINDEX);
    }
    return 0;
}

static int xhr_open(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    size_t ml = 0, ul = 0;
    const char* m = luaL_checklstring(L, 2, &ml);
    const char* u = luaL_checklstring(L, 3, &ul);
    if (!x->request) x->request = new ax::network::HttpRequest();
    x->request->setUrl(u);
    x->request->setRequestType(
        (ml >= 4 && (m[0] == 'G' || m[0] == 'g')) ? ax::network::HttpRequest::Type::GET
                                                  : ax::network::HttpRequest::Type::POST);
    x->readyState = 1;
    return 0;
}

static int xhr_setHeader(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    const char* k = luaL_checkstring(L, 2);
    const char* v = luaL_checkstring(L, 3);
    if (x->request) x->request->setHeaders({std::string(k) + ": " + std::string(v)});
    return 0;
}

static int xhr_data(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    LBytes* b = lb_self(L, 2);
    if (b->p) free(b->p);
    b->n = x->bodyN;
    b->p = (uint8_t*)malloc(b->n ? b->n : 1);
    if (b->n) memcpy(b->p, x->body, b->n);
    return 0;
}

static int xhr_abort(lua_State* L) {
    (void)xhr_self(L, 1);
    return 0;
}

// O corpo do callback roda na GL thread (marshal via performFunctionInCocosThread)
static int xhr_sendBlob(lua_State* L, LXHR* x, const uint8_t* payload, size_t n) {
    if (!x->request)
        return luaL_error(L, "cc.XMLHttpRequest:open() missing before send");
    if (x->sent)
        return luaL_error(L, "cc.XMLHttpRequest: already sent");
    x->sent = true;
    int selfRef = x->selfRef; x->selfRef = -1;       // posse passa ao callback
    int handlerRef = x->handlerRef; x->handlerRef = -1;

    x->request->setRequestData((const char*)payload, n);
    // axmol 2.11 não expõe timeout por request (nota de fidelidade)
    fprintf(stderr, "HOST_XHR_ATTEMPT url=%s bytes=%d timeout=%.1f\n",
        x->request->getUrl().data(), (int)n, x->timeout);
    fflush(stderr);

    // captura por valor (refs da registry ficam válidas mesmo se o Lua GC)
    x->request->setResponseCallback([selfRef, handlerRef](ax::network::HttpClient*,
                                                          ax::network::HttpResponse* resp) {
        int status = 0;
        uint8_t* dataP = nullptr; size_t dataN = 0;
        if (resp && resp->isSucceed()) {
            status = resp->getResponseCode();
            auto* rd = resp->getResponseData();
            if (rd && !rd->empty()) {
                dataN = rd->size();
                dataP = (uint8_t*)malloc(dataN);
                memcpy(dataP, rd->data(), dataN);
            }
        }
        ax::Director::getInstance()->getScheduler()->performFunctionInCocosThread(
            [selfRef, handlerRef, status, dataP, dataN]() {
                lua_State* L = ax::LuaEngine::getInstance()->getLuaStack()->getLuaState();
                if (!L) { if (dataP) free(dataP); return; }
                lua_rawgeti(L, LUA_REGISTRYINDEX, selfRef);
                if (lua_isnil(L, -1)) { lua_pop(L, 1); if (dataP) free(dataP); return; }
                LXHR* x = (LXHR*)lua_touserdata(L, -1);
                if (x->body) free(x->body);
                x->body = dataP; x->bodyN = dataN;
                x->status = status;
                x->readyState = 4;                   // DONE
                fprintf(stderr, "HOST_XHR_DONE status=%d bytes=%d\n", status, (int)dataN);
                fflush(stderr);
                if (handlerRef != -1) {
                    lua_rawgeti(L, LUA_REGISTRYINDEX, handlerRef);
                    int ok = lua_pcall(L, 0, 0, 0);  // nunca derruba o jogo
                    if (ok != 0) {
                        fprintf(stderr, "HOST_XHR_HANDLER_ERROR %s\n", lua_tostring(L, -1));
                        lua_pop(L, 1);
                    }
                    luaL_unref(L, LUA_REGISTRYINDEX, handlerRef);
                }
                if (selfRef != -1) luaL_unref(L, LUA_REGISTRYINDEX, selfRef);
            });
    });
    ax::network::HttpClient::getInstance()->send(x->request);
    x->readyState = 3;                                // LOADING
    return 0;
}

static int xhr_send_d(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    LBytes* b = lb_self(L, 2);
    return xhr_sendBlob(L, x, b->p, b->n);
}
static int xhr_send(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    size_t n = 0;
    const char* s = lua_tolstring(L, 2, &n);
    return xhr_sendBlob(L, x, (const uint8_t*)s, n);
}

static int xhr_index(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    const char* k = luaL_checkstring(L, 2);
    if (!strcmp(k, "readyState"))      lua_pushinteger(L, x->readyState);
    else if (!strcmp(k, "status"))     lua_pushinteger(L, x->status);
    else if (!strcmp(k, "responseType")) lua_pushinteger(L, x->responseType);
    else if (!strcmp(k, "timeout"))    lua_pushnumber(L, x->timeout);
    else {
        lua_getmetatable(L, 1);
        lua_getfield(L, -1, "__methods");
        lua_getfield(L, -1, k);
        lua_replace(L, -3);
        lua_pop(L, 1);
        if (lua_isnil(L, -1) && !strcmp(k, "send_d")) {
            lua_pop(L, 1);
            lua_pushcfunction(L, xhr_send_d);
        } else if (lua_isnil(L, -1) && !strcmp(k, "send")) {
            lua_pop(L, 1);
            lua_pushcfunction(L, xhr_send);
        }
    }
    return 1;
}
static int xhr_newindex(lua_State* L) {
    LXHR* x = xhr_self(L, 1);
    const char* k = luaL_checkstring(L, 2);
    if (!strcmp(k, "responseType")) x->responseType = (int)luaL_checkinteger(L, 3);
    else if (!strcmp(k, "timeout")) x->timeout = luaL_checknumber(L, 3);
    else if (!strcmp(k, "readyState")) x->readyState = (int)luaL_checkinteger(L, 3);
    else if (!strcmp(k, "status")) x->status = (int)luaL_checkinteger(L, 3);
    return 0;
}

// ============================ registro ====================================
static void regMeta(lua_State* L, const char* name, lua_CFunction gc,
                    lua_CFunction index, lua_CFunction newindex, int methodsIdx) {
    luaL_newmetatable(L, name);
    if (gc) { lua_pushcfunction(L, gc); lua_setfield(L, -2, "__gc"); }
    if (index) {
        lua_pushcfunction(L, index);
        lua_setfield(L, -2, "__index");
    } else if (methodsIdx != -1) {
        lua_pushvalue(L, methodsIdx);          // métodos servem de __index
        lua_setfield(L, -2, "__index");
    }
    if (newindex) { lua_pushcfunction(L, newindex); lua_setfield(L, -2, "__newindex"); }
    if (methodsIdx != -1) {
        lua_pushvalue(L, methodsIdx);
        lua_setfield(L, -2, "__methods");
    }
    lua_pop(L, 1);
}

int registerAll(lua_State* L) {
    {   // cc.DBytes
        lua_newtable(L);
        lua_pushcfunction(L, dbytes_getBytes); lua_setfield(L, -2, "getBytes");
        lua_pushcfunction(L, dbytes_getSize);  lua_setfield(L, -2, "getSize");
        lua_pushcfunction(L, dbytes_copy);     lua_setfield(L, -2, "copy");
        lua_pushcfunction(L, dbytes_release);  lua_setfield(L, -2, "release");
        int m = lua_gettop(L);
        regMeta(L, "cc.DBytes", dbytes_gc, nullptr, nullptr, m);
        lua_pop(L, 1);
    }
    {   // cc.CBlowFish
        lua_newtable(L);
        lua_pushcfunction(L, cbf_setKey);  lua_setfield(L, -2, "setKey");
        lua_pushcfunction(L, cbf_encrypt); lua_setfield(L, -2, "Encrypt");
        lua_pushcfunction(L, cbf_decrypt); lua_setfield(L, -2, "Decrypt");
        int m = lua_gettop(L);
        regMeta(L, "cc.CBlowFish", cbf_gc, nullptr, nullptr, m);
        lua_pop(L, 1);
    }
    {   // cc.XMLHttpRequest
        lua_newtable(L);
        lua_pushcfunction(L, xhr_registerHandler); lua_setfield(L, -2, "registerScriptHandler");
        lua_pushcfunction(L, xhr_open);            lua_setfield(L, -2, "open");
        lua_pushcfunction(L, xhr_setHeader);       lua_setfield(L, -2, "setRequestHeader");
        lua_pushcfunction(L, xhr_send_d);          lua_setfield(L, -2, "send_d");
        lua_pushcfunction(L, xhr_send);            lua_setfield(L, -2, "send");
        lua_pushcfunction(L, xhr_data);            lua_setfield(L, -2, "data");
        lua_pushcfunction(L, xhr_abort);           lua_setfield(L, -2, "abort");
        int m = lua_gettop(L);
        regMeta(L, "cc.XMLHttpRequest", xhr_gc, xhr_index, xhr_newindex, m);
        lua_pop(L, 1);
    }

    //_____ global cc + construtores (após compatibility: cc == ax aqui) _____
    lua_getglobal(L, "cc");
    if (!lua_istable(L, -1)) {
        lua_pop(L, 1);
        lua_newtable(L);
        lua_pushvalue(L, -1);
        lua_setglobal(L, "cc");
    }
    lua_newtable(L); lua_pushcfunction(L, dbytes_newcall); lua_setfield(L, -2, "new");
    lua_setfield(L, -2, "DBytes");
    lua_newtable(L); lua_pushcfunction(L, cbf_newcall);    lua_setfield(L, -2, "new");
    lua_setfield(L, -2, "CBlowFish");
    lua_newtable(L); lua_pushcfunction(L, xhr_newcall);    lua_setfield(L, -2, "new");
    lua_setfield(L, -2, "XMLHttpRequest");
    lua_pushinteger(L, 2);
    lua_setfield(L, -2, "XMLHTTPREQUEST_RESPONSE_STRING");
    // funções globais do acervo (NetworkAdaptor.lua 545/572)
    lua_pushcfunction(L, cc_deflate);   lua_setfield(L, -2, "deflateMemory");
    lua_pushcfunction(L, cc_inflate);   lua_setfield(L, -2, "inflateMemory");
    lua_pop(L, 1);
    return 0;
}

} // namespace nrproto
