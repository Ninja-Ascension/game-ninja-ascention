"""Power parity with EnvironmentDatas.lua:calPowerForNotOwn.

Uses persisted effective attributes and the original fight/skill tables.
Power is derived; no account data or cached attribute increments are written.
"""
import math
from functools import lru_cache
from pathlib import Path
import dados_batalha as data


@lru_cache(maxsize=1)
def config():
    folder=Path(data.MOULD).parent/'configs'
    def rows(name):
        return {r[0]:r[3] for r in (line.split('\t') for line in
                (folder/name).read_text(encoding='utf-8').splitlines()) if len(r)>3}
    coefficients=rows('fight_config.txt')
    demands=tuple(map(int,rows('ship_config.txt')['2'].split(',')))
    return tuple(float(coefficients[str(i)]) for i in range(12,19)),demands


def character(db,account,ship,mould,attributes=None):
    import hero_stats_local as stats,hero_development_local as development
    e=attributes if attributes is not None else stats.effective(db,account,ship,mould)
    state=development.state(db,account,ship,mould)
    r=data.tabela('ship_mould.txt')[str(mould)]
    (a,b,c,d,fifth,f,g),demands=config()
    base=e['courage']*a+e['intellect']*a+e['health']*b
    multiplier=(1+float(r[16])*c+float(r[18])*d+float(r[17])*fifth
                +float(r[20])*c+float(r[19])*fifth+float(r[21])*d
                +float(r[9])*f+float(r[10])*f)
    skills=sum(level for i,level in enumerate(state['skills'])
               if level!=1 or state['star']>=demands[i])
    return math.ceil(base*multiplier+skills*g)


def formation(db,account):
    import recruitment_local as heroes
    with db._lock:
        slots=set(heroes._slots_locked(db,account))
        return sum(character(db,account,ship,mould) for ship,mould in heroes.all_owned(db,account)
                   if str(ship) in slots)
