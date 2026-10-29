"""Simula a condicao de SP_ANIMATION_COMPLETE do Spine 2.1 para loop.

AnimationState.c:179 (caso current->loop):
    FMOD(current->lastTime, current->endTime) > FMOD(time, current->endTime)

lastTime e atualizado ao fim de cada _update (linha 192). Se o passo por
quadro for grande o suficiente para pular um ciclo inteiro, a comparacao de
restos nunca detecta a volta e COMPLETE nao dispara.

Este script mede, para a duracao real de "animation2", quantos passos de
1/60 s cabem por ciclo e se algum passo "atravessa" a fronteira.
"""
import math

DURACAO = 1.1665999889374   # medida pelo teste no binario
DT = 1.0 / 60.0


def fmod(a, m):
    return a - m * math.floor(a / m)


def simular(dt, rotulo):
    passos = math.ceil((DURACAO + 0.02) / dt)
    t = 0.0
    last = -1.0
    disparos = []
    for i in range(1, passos + 1):
        t += dt
        if fmod(last, DURACAO) > fmod(t, DURACAO):
            disparos.append((i, t))
        last = t
    print("%-22s dt=%.8f passos=%3d tempo_final=%.6f disparos=%d %s"
          % (rotulo, dt, passos, t, len(disparos),
             ("nos passos " + str([d[0] for d in disparos])) if disparos else ""))
    return disparos


print("duracao=%.10f  ciclos_por_passo=%.4f" % (DURACAO, DT / DURACAO))
print("passos_por_ciclo=%.4f" % (DURACAO / DT))
print()
simular(DT, "1/60 (teste)")
simular(1.0 / 30.0, "1/30")
simular(DURACAO / 2, "meio ciclo")
simular(DURACAO, "um ciclo inteiro")
simular(DURACAO * 3, "tres ciclos")
simular(0.001, "0,001 s (fino)")

print()
print("Conclusao:")
print("Com dt=1/60 e duracao=%.4f, cada quadro avanca %.2f%% do ciclo."
      % (DURACAO, 100 * DT / DURACAO))
print("A fronteira do primeiro ciclo cai em t=%.4f, entre os quadros %d e %d."
      % (DURACAO, math.floor(DURACAO / DT), math.ceil(DURACAO / DT)))
