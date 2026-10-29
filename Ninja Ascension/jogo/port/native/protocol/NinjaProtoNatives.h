// Fase 1b — natives de protocolo reconstruídos do libjts.so
//
// SEMÂNTICA EXTRAÍDA DO ORIGINAL (evidências nos golds):
//  - cc.DBytes: transporte de bytes sobre buffer próprio (new/getBytes/
//    getSize/copy/release); Data::encrypt do build é stub (2 bytes)
//  - cc.CBlowFish: wrapper Blowfish; o wrapper LUA (0x3a2d24) chama o
//    overload in-place Encrypt(Ph,int,uint) com mode=0
//  - mode=0 (branch 0x648322): NÃO cifra — troca as metades de cada bloco
//    de 8 bytes (swap 2x u32, "45670123" <- "01234567") + padding de
//    ZEROS até múltiplo de 8; Decrypt igual (involutivo)
//  - cc.deflateMemory/cc.inflateMemory: zlib padrão (level 9 na ida)
//  - chave Blowfish de app.lua:174 ("K(7a!ykjTD&DAp0!") — usada só nos
//    modos 1/2 (não usados pelo jogo; mantidos por fidelidade)
// Tabelas: port/native/protocol/blowfish_tables.h (extraídas do .so)
#pragma once
#include <cstdint>
#include <cstddef>
#include <vector>

struct lua_State;

namespace nrproto {

// Blowfish fiel ao CBlowFish do jogo: tabelas do .so (P=pi, S custom),
// schedule padrão (XOR da chave + 5216 blocks), modos:
//   0 = swap-halves (o modo usado pelo wrapper do jogo)
//   1 = CBC com IV this+8/0xc (feedforward) [não usado pelo jogo]
//   2 = CBC-variante [não usado pelo jogo]
class GameBlowfish {
public:
    GameBlowfish();
    void setKey(const uint8_t* key, uint32_t len);
    // in-place, como o overload Encrypt(Ph,int,uint) called by the lua wrapper
    void encrypt(uint8_t* data, int len, uint32_t mode);
    void decrypt(uint8_t* data, int len, uint32_t mode);
    // (src,dst) overload, para os modos 1/2
    void encrypt(const uint8_t* src, uint8_t* dst, int len, uint32_t mode);
    void decrypt(const uint8_t* src, uint8_t* dst, int len, uint32_t mode);
private:
    uint32_t P_[18];
    uint32_t S_[1024];
    uint32_t iv_[2];
public:
    void encryptBlock(uint32_t& xl, uint32_t& xr);
    void decryptBlock(uint32_t& xl, uint32_t& xr);
};

// ---- helpers de protocolo (o que o wrapper do jogo faz) ----
// zero-pad até múltiplo de 8 + swap-halves por bloco (mode 0, involutivo)
void cipherMode0(uint8_t* data, int len);

// defla/infla padrão zlib
std::vector<uint8_t> deflateZlib(const uint8_t* data, size_t n);
std::vector<uint8_t> inflateZlib(const uint8_t* data, size_t n);

// ---- registro Lua (nomes/semântica do acervo) ----
// registra cc.DBytes, cc.CBlowFish, cc.deflateMemory, cc.inflateMemory
int registerAll(lua_State* L);

// chave do acervo (app.lua:174) para o self-test
static const char* kArchiveKey = "K(7a!ykjTD&DAp0!";

} // namespace nrproto
