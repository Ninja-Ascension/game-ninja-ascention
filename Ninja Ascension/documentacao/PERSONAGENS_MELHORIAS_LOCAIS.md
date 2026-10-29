# Melhorias de personagens — 26/10/2026

Conta preservada: ItachiBR, ID interno 61.

## Materiais

Reposição mínima de 1.000.000 por tipo para 277 tipos de materiais. Backup automático anterior à reposição: build/contas-before-character-materials-20261026-151633.sqlite3. Relação: build/character-materials-grant.csv.

## Operações

- Avanço por materiais: ship_grow_up (já existente).
- Nível/EXP: ship_escalate (já existente).
- Promote/estrelas: ship_awaken, exigências originais de awaken_requirement, fragmentos e Ryo; não ultrapassa sete estrelas. Requisitos de equipamento sem implementação retornam erro explícito.
- Skill: ship_skill_level_up e ship_skill_level_up_one_key, custo original de talent_level_requirement, níveis limitados pelo nível do ninja. A conta local recebe saldo inicial de teste de 1.000.000 pontos de habilidade, descontados a cada melhoria.
- Cursed Seal: ship_soul_level_up, materiais/EXP e limites originais dos selos (até nível 20). O avanço do ninja continua sendo exigido para desbloquear cada selo.

Melhorias persistidas em local_hero_development e local_hero_skill_points. Pedidos possuem recibos para evitar consumo repetido. Login devolve habilidades, estrelas e quatro slots de selo completos. Potencial começa com três valores válidos, sem o valor incompleto que travava a aba.

## Poder e idioma

O cliente recalcula hero_fight pela fórmula original calPowerForNotOwn após receber dados do servidor; o total soma os personagens da formação. Não existe multiplicador artificial apenas para exibir poder maior. Nível atualiza atributos base; habilidades e desbloqueios passam a participar da fórmula. O balanceamento completo de bônus de todas as evoluções/equipamentos continua dependendo dos respectivos dados e sistemas implementados.

O dicionário de textos do desktop respeita current_language: português para pt/BR/Português, mantendo outros pacotes originais. Foram acrescentados termos de personagens e lojas. Textos desenhados dentro de imagens e descrições ainda não presentes no dicionário não foram traduzidos; isto não é uma tradução integral de todos os assets.

## Testes

- tools/test_hero_development_local.py: promoção, habilidade individual/automática, selo, repetição de pedido e dados persistidos.
- tools/test_hero_development_native.py: abertura das três abas reais, dados de login, poder estável e alternância pt-BR/inglês.
- Regressão de nível: tools/test_hero_level_local.py e tools/test_hero_level_native.py.
