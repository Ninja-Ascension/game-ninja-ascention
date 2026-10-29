// Iniciador do cliente PC: a pasta de distribuicao mostra so este .exe.
// Todo o jogo fica em "dados" (escondida na primeira execucao). Antes de abrir
// o jogo, baixa do servidor os arquivos atualizados (manifesto com SHA-256,
// ver port/server/atualizacao_cliente.py). Depois abre o executavel do jogo sem
// a janela de console e com NR_GAME_ROOT apontando para "dados". O endereco do
// servidor vem de dados\port\resources\servidor.txt.
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Threading;
using System.Web.Script.Serialization;
using System.Windows.Forms;
using System.Runtime.InteropServices;
[assembly: System.Reflection.AssemblyTitle("NinjaAscension")]
[assembly: System.Reflection.AssemblyProduct("NinjaAscension")]

static class NinjaRevolutionLauncher
{
    const string Titulo = "NinjaAscension";
    const string NomeIniciador = "NinjaAscension.exe";
    static readonly string[] Prefixos = { "port/", "01_conteudo_apk/", "build/windows-probe-native/" };
    static readonly string[] RaizPermitidos = { NomeIniciador, "Ninja Revolution.exe", "DIAGNOSTICO.cmd" };

    static string pasta, dados, registro;
    [DllImport("user32.dll")] static extern bool SetForegroundWindow(IntPtr window);
    [DllImport("user32.dll")] static extern bool ShowWindow(IntPtr window, int command);

    static bool JogoAberto(string arquivo)
    {
        foreach (var processo in Process.GetProcessesByName("NinjaResourceProbe"))
        {
            try
            {
                if (!string.Equals(processo.MainModule.FileName, arquivo, StringComparison.OrdinalIgnoreCase)) continue;
                if (processo.MainWindowHandle != IntPtr.Zero) { ShowWindow(processo.MainWindowHandle, 9); SetForegroundWindow(processo.MainWindowHandle); }
                return true;
            }
            catch (Exception) { }
            finally { processo.Dispose(); }
        }
        return false;
    }

    static void LimparNomeAntigo()
    {
        if (!string.Equals(Path.GetFileName(Application.ExecutablePath), NomeIniciador, StringComparison.OrdinalIgnoreCase)) return;
        string antigo=Path.Combine(pasta,"Ninja Revolution.exe");
        string reserva=antigo+".legacy";
        try
        {
            if (File.Exists(antigo))
            {
                AtualizarAtalhosAntigos(antigo);
                if (File.Exists(reserva)) File.Delete(reserva);
                File.Move(antigo,reserva);
                File.SetAttributes(reserva,File.GetAttributes(reserva)|FileAttributes.Hidden);
            }
        }
        catch(Exception erro) { Log("limpeza do nome antigo adiada: "+erro.Message); }
    }

    static void AtualizarAtalhosAntigos(string antigo)
    {
        Type tipo=Type.GetTypeFromProgID("WScript.Shell");
        if(tipo==null)return;
        dynamic shell=Activator.CreateInstance(tipo);
        foreach(string area in new [] {Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory),Environment.GetFolderPath(Environment.SpecialFolder.CommonDesktopDirectory)})
        {
            if(!Directory.Exists(area))continue;
            foreach(string arquivo in Directory.GetFiles(area,"*.lnk"))
            {
                dynamic atalho=shell.CreateShortcut(arquivo);
                if(!string.Equals((string)atalho.TargetPath,antigo,StringComparison.OrdinalIgnoreCase))continue;
                atalho.TargetPath=Path.Combine(pasta,NomeIniciador);
                atalho.IconLocation=Path.Combine(pasta,NomeIniciador)+",0";
                atalho.Description=Titulo;atalho.Save();
                string novo=Path.Combine(area,"NinjaAscension.lnk");
                if(Path.GetFileNameWithoutExtension(arquivo)=="Ninja Revolution" && !File.Exists(novo))File.Move(arquivo,novo);
            }
        }
    }

    [STAThread]
    static int Main()
    {
        Mutex trava=null;
        bool dono=false;
        try
        {
            pasta = AppDomain.CurrentDomain.BaseDirectory;
            dados = Path.Combine(pasta, "dados");
            registro = Path.Combine(dados, "atualizacao.log");
            string jogo = Path.Combine(dados, @"build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe");
            string identidade;
            using(var sha=SHA256.Create()) identidade=BitConverter.ToString(sha.ComputeHash(System.Text.Encoding.UTF8.GetBytes(pasta.ToUpperInvariant()))).Replace("-", "");
            trava=new Mutex(false,@"Local\NinjaAscension-"+identidade);
            try { dono=trava.WaitOne(0); } catch(AbandonedMutexException) { dono=true; }
            if(!dono) { JogoAberto(jogo); return 0; }
            if(JogoAberto(jogo)) return 0;
            LimparNomeAntigo();
            if (!File.Exists(jogo))
            {
                MessageBox.Show("Arquivos do jogo nao encontrados.\nExtraia o pacote inteiro, mantendo a pasta \"dados\" ao lado deste programa.", Titulo, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 1;
            }
            try { File.Delete(Path.Combine(pasta, NomeIniciador + ".old")); } catch (Exception) { }

            bool iniciadorTrocado = Atualizar();
            if (iniciadorTrocado || (Path.GetFileName(Application.ExecutablePath) != NomeIniciador && File.Exists(Path.Combine(pasta,NomeIniciador))))
            {
                // O iniciador novo assume (ele confere de novo e abre o jogo).
                trava.ReleaseMutex();dono=false;
                Process.Start(new ProcessStartInfo(Path.Combine(pasta, NomeIniciador)) { WorkingDirectory = pasta });
                return 0;
            }
            if (Environment.GetEnvironmentVariable("NR_LAUNCHER_SOMENTE_ATUALIZAR") == "1") return 0;

            var info = new DirectoryInfo(dados);
            if ((info.Attributes & FileAttributes.Hidden) == 0) info.Attributes |= FileAttributes.Hidden;
            Juncao(Path.Combine(dados, "res"), Path.Combine(dados, @"01_conteudo_apk\assets\res"));
            Juncao(Path.Combine(dados, "src"), Path.Combine(dados, @"01_conteudo_apk\assets\src"));

            var inicio = new ProcessStartInfo(jogo)
            {
                // Axmol resolves relative search paths ("res", "src") from the
                // working directory: it must be the game root, where they live.
                WorkingDirectory = dados,
                UseShellExecute = false,
                CreateNoWindow = true
            };
            foreach (string chave in new ArrayList(inicio.EnvironmentVariables.Keys))
                if (chave.StartsWith("NR_", StringComparison.OrdinalIgnoreCase)) inicio.EnvironmentVariables.Remove(chave);
            inicio.EnvironmentVariables["NR_GAME_ROOT"] = dados.TrimEnd('\\');
            inicio.EnvironmentVariables["NR_ENABLE_TUTORIAL"] = "0";
            using(var processo=Process.Start(inicio))
            {
                Log("jogo iniciado pid="+processo.Id);
                processo.WaitForExit();
                Log("jogo encerrou codigo="+processo.ExitCode);
                return processo.ExitCode;
            }
        }
        catch (Exception erro)
        {
            MessageBox.Show("Nao foi possivel iniciar o jogo:\n" + erro.Message, Titulo, MessageBoxButtons.OK, MessageBoxIcon.Error);
            return 1;
        }
        finally { if(dono && trava!=null) trava.ReleaseMutex(); if(trava!=null) trava.Dispose(); }
    }

    // ------------------------------------------------------------ atualizacao --

    static void Log(string texto)
    {
        try { File.AppendAllText(registro, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " " + texto + Environment.NewLine); } catch (Exception) { }
    }

    static string BaseServidor()
    {
        string arquivo = Path.Combine(dados, @"port\resources\servidor.txt");
        if (!File.Exists(arquivo)) return null;
        string linha = File.ReadAllText(arquivo).Trim();
        Uri uri;
        if (!Uri.TryCreate(linha, UriKind.Absolute, out uri) || (uri.Scheme != "http" && uri.Scheme != "https")) return null;
        return uri.Scheme + "://" + uri.Authority;
    }

    static bool CaminhoValido(string rel)
    {
        if (string.IsNullOrEmpty(rel) || rel.Contains("\\") || rel.StartsWith("/") || rel.Contains(":")) return false;
        foreach (string parte in rel.Split('/'))
            if (parte == "" || parte == "." || parte == "..") return false;
        if (Array.IndexOf(RaizPermitidos, rel) >= 0) return true;
        foreach (string p in Prefixos) if (rel.StartsWith(p, StringComparison.Ordinal)) return true;
        return false;
    }

    static string Sha256(string arquivo)
    {
        if (!File.Exists(arquivo)) return null;
        using (var sha = SHA256.Create())
        using (var f = File.OpenRead(arquivo))
            return BitConverter.ToString(sha.ComputeHash(f)).Replace("-", "").ToLowerInvariant();
    }

    // Devolve true quando o proprio iniciador foi substituido.
    static bool Atualizar()
    {
        string baseUrl = BaseServidor();
        if (baseUrl == null) { Log("sem servidor.txt valido; atualizacao ignorada"); return false; }

        bool trocado = false;
        string erroFinal = null;
        var janela = new Form
        {
            Text = Titulo, Icon = System.Drawing.Icon.ExtractAssociatedIcon(Application.ExecutablePath), Width = 420, Height = 130, FormBorderStyle = FormBorderStyle.FixedDialog,
            StartPosition = FormStartPosition.CenterScreen, MaximizeBox = false, MinimizeBox = false, ControlBox = false
        };
        var rotulo = new Label { Text = "Verificando atualizacoes...", Left = 12, Top = 12, Width = 380 };
        var barra = new ProgressBar { Left = 12, Top = 40, Width = 380, Height = 22 };
        janela.Controls.Add(rotulo); janela.Controls.Add(barra);
        Action<string, int> mostrar = (texto, valor) =>
        {
            if (!janela.IsHandleCreated) return;
            janela.BeginInvoke((Action)(() => { rotulo.Text = texto; barra.Value = Math.Max(0, Math.Min(100, valor)); }));
        };

        var trabalho = new Thread(() =>
        {
            try { trocado = Baixar(baseUrl, mostrar); }
            catch (Exception e) { erroFinal = e.Message; Log("falha na atualizacao: " + e); }
            finally
            {
                while (!janela.IsHandleCreated) Thread.Sleep(20);
                janela.BeginInvoke((Action)janela.Close);
            }
        }) { IsBackground = true };
        janela.Shown += (s, e) => trabalho.Start();
        Application.EnableVisualStyles();
        Application.Run(janela);
        trabalho.Join(2000);
        if (erroFinal != null)
            MessageBox.Show("Nao foi possivel atualizar agora (" + erroFinal + ").\nO jogo vai abrir com os arquivos atuais.", Titulo, MessageBoxButtons.OK, MessageBoxIcon.Warning);
        return trocado;
    }

    static bool Baixar(string baseUrl, Action<string, int> mostrar)
    {
        var cliente = new WebClient();
        cliente.Headers[HttpRequestHeader.CacheControl] = "no-cache";
        string texto = cliente.DownloadString(baseUrl + "/atualizacao/manifesto.json");
        var manifesto = new JavaScriptSerializer().Deserialize<Dictionary<string, object>>(texto);
        var lista = (ArrayList)manifesto["arquivos"];
        var pendentes = new List<Dictionary<string, object>>();
        int n = 0;
        foreach (Dictionary<string, object> item in lista)
        {
            n++;
            mostrar("Verificando arquivos (" + n + "/" + lista.Count + ")...", n * 30 / Math.Max(1, lista.Count));
            string rel = (string)item["caminho"];
            if (rel=="Ninja Revolution.exe" && Path.GetFileName(Application.ExecutablePath)!=rel) continue;
            if (!CaminhoValido(rel)) { Log("caminho recusado: " + rel); continue; }
            if (Sha256(Local(rel)) != (string)item["sha256"]) pendentes.Add(item);
        }
        Log("manifesto " + manifesto["versao"] + ": " + lista.Count + " arquivo(s), " + pendentes.Count + " para baixar");
        bool trocado = false;
        for (int i = 0; i < pendentes.Count; i++)
        {
            var item = pendentes[i];
            string rel = (string)item["caminho"];
            mostrar("Baixando atualizacao (" + (i + 1) + "/" + pendentes.Count + "): " + Path.GetFileName(rel), 30 + (i + 1) * 70 / pendentes.Count);
            string destino = Local(rel);
            string temp = destino + ".download";
            Directory.CreateDirectory(Path.GetDirectoryName(destino));
            cliente.DownloadFile(baseUrl + "/atualizacao/arquivos/" + Uri.EscapeUriString(rel), temp);
            if (Sha256(temp) != (string)item["sha256"]) { File.Delete(temp); throw new IOException("arquivo corrompido no download: " + rel); }
            if (string.Equals(rel, Path.GetFileName(Application.ExecutablePath), StringComparison.OrdinalIgnoreCase))
            {
                // Windows permite renomear o .exe em uso; o novo assume em seguida.
                string antigo = destino + ".old";
                if (File.Exists(antigo)) File.Delete(antigo);
                File.Move(destino, antigo);
                File.Move(temp, destino);
                trocado = true;
            }
            else
            {
                if (File.Exists(destino)) File.Delete(destino);
                File.Move(temp, destino);
            }
            Log("atualizado: " + rel);
        }
        mostrar("Pronto.", 100);
        return trocado;
    }

    static string Local(string rel)
    {
        string relWin = rel.Replace('/', Path.DirectorySeparatorChar);
        return Array.IndexOf(RaizPermitidos, rel) >= 0 ? Path.Combine(pasta, relWin) : Path.Combine(dados, relWin);
    }

    // Os scripts do jogo esperam "res" e "src" na raiz; sao atalhos (juncoes)
    // para 01_conteudo_apk\assets, criados uma vez, sem precisar de administrador.
    static void Juncao(string link, string alvo)
    {
        // Junctions keep an absolute target: after the folder is moved they
        // still exist but point nowhere. Check through the link and rebuild it.
        if (Directory.Exists(link))
        {
            bool atalho = (File.GetAttributes(link) & FileAttributes.ReparsePoint) != 0;
            bool valido = false;
            try { valido = Directory.GetFileSystemEntries(link).Length > 0; } catch (IOException) { } catch (UnauthorizedAccessException) { }
            if (valido || !atalho) return;
            Directory.Delete(link, false); // removes only the junction itself
        }
        var cmd = new ProcessStartInfo("cmd.exe", "/c mklink /J \"" + link + "\" \"" + alvo + "\"")
        {
            UseShellExecute = false,
            CreateNoWindow = true
        };
        using (var p = Process.Start(cmd)) p.WaitForExit(10000);
        if (!Directory.Exists(link)) throw new IOException("Nao foi possivel criar o atalho interno " + Path.GetFileName(link));
    }
}
