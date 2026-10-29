# Diagnóstico da Fase 2 — lê port/server/server.log e diz em que passo do
# fluxo a sessão parou. Rodar de qualquer diretório:
#   powershell -File tools\diag_fase2.ps1
# (opcional: -Log caminho-do-log)
param(
    [string]$Log,
    [int]$Ultimas = 300
)
if (-not $Log) {
    $raiz = Split-Path -Parent $PSScriptRoot   # tools\.. = raiz do workspace
    $Log = Join-Path $raiz 'port\server\server.log'
}
if (-not (Test-Path -LiteralPath $Log)) {
    Write-Output "[diag] server.log nao encontrado em: $Log"
    exit 1
}
$linhas = Get-Content -LiteralPath $Log -Tail $Ultimas -Encoding UTF8
$comandos = @{}
$avisos = @()
$seqMax = -1
foreach ($l in $linhas) {
    if ($l -match 'cmd=([A-Za-z0-9_]+) seq=(\d+)') {
        $c = $Matches[1]
        if (-not $comandos.ContainsKey($c)) { $comandos[$c] = 0 }
        $comandos[$c] = $comandos[$c] + 1
        $n = [int]$Matches[2]
        if ($c -ne 'record_crash' -and $n -gt $seqMax) { $seqMax = $n }
    }
    if ($l -match '\[AVISO\]') { $avisos += $l }
}
Write-Output "[diag] comandos vistos (contagem):"
$comandos.GetEnumerator() | Sort-Object Name | ForEach-Object {
    Write-Output ("  {0,-28} x{1}" -f $_.Key, $_.Value)
}
Write-Output ("[diag] maior seq util (sem record_crash): {0}" -f $seqMax)
if ($avisos.Count -gt 0) {
    Write-Output "[diag] AVISOS (comandos sem resposta real ainda):"
    $avisos | Select-Object -Unique | Select-Object -First 8 | ForEach-Object { Write-Output ("  " + $_) }
}
# Passo alcancado segundo o fluxo principal login->menu do acervo
# (58 -> 57 -> 3 -> 1602); comandos da conta propria ficam como amostra.
$passos = @(
    @{ nome = 'new_get_server_list'; cela = '1. lista de servidores servida' },
    @{ nome = 'vali_register';       cela = '2. identidade aceita (57)' },
    @{ nome = 'login_init';          cela = '3. login_init (96 tokens) -> tela carrega' },
    @{ nome = 'user_create_time';    cela = '4. ecos do menu servidos (1602+) -> tela inicial' }
)
$alcancou = $null
foreach ($p in $passos) { if ($comandos.ContainsKey($p.nome)) { $alcancou = $p.cela } }
if ($alcancou) {
    Write-Output ("[diag] passo mais avancado do fluxo alcancado: {0}" -f $alcancou)
} else {
    Write-Output "[diag] nenhum comando do fluxo principal visto ainda (so o jogo abrindo / testes)"
}
$conta = @('search_user_platform','platform_user_login','platform_user_register') | Where-Object { $comandos.ContainsKey($_) }
if ($conta) {
    Write-Output ("[diag] sistema de conta propria usado: {0}" -f ($conta -join ', '))
}
Write-Output "[diag] lembrete: record_crash e espuma normal do boot (ACK neutro)."
