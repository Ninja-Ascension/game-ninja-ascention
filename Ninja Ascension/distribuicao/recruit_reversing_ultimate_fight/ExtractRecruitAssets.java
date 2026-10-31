import java.io.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.security.*;
import java.util.*;
import java.util.regex.*;
import java.util.zip.*;
import javax.crypto.*;
import javax.crypto.spec.*;

public class ExtractRecruitAssets {
  static final String APK = "distribuicao/Ultimate+Fight_Survival_1.0.3_APKPure.apk";
  static final Path OUT = Paths.get("distribuicao/recruit_reversing_ultimate_fight/decrypted").toAbsolutePath().normalize();
  static final Pattern RESOURCE = Pattern.compile("[A-Za-z0-9_./-]+\\.(?:png|jpg|jpeg|plist|atlas|json|fnt|ttf|csb|lua|mp3|wav)", Pattern.CASE_INSENSITIVE);
  static String sha(byte[] b) throws Exception { return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(b)); }
  static int le(byte[] b,int o) { return (b[o]&255)|((b[o+1]&255)<<8)|((b[o+2]&255)<<16)|(b[o+3]<<24); }
  static byte[] decode(byte[] f, byte[] key, String name) throws Exception {
    if(f.length<11 || f[0]!=0x39 || f[1]!=0x7f || f[2]!=0x13) throw new IOException("assinatura inesperada: "+name);
    int cryptLen=le(f,3), expected=le(f,7);
    if(cryptLen!=f.length-11 || cryptLen%8!=0 || expected<0) throw new IOException("cabecalho invalido: "+name+" cipher="+cryptLen+" payload="+(f.length-11));
    Cipher c=Cipher.getInstance("Blowfish/ECB/NoPadding"); c.init(Cipher.DECRYPT_MODE,new SecretKeySpec(key,"Blowfish"));
    byte[] zipped=c.doFinal(Arrays.copyOfRange(f,11,f.length));
    Inflater inf=new Inflater(); inf.setInput(zipped); ByteArrayOutputStream out=new ByteArrayOutputStream(expected); byte[] buf=new byte[8192];
    try { while(!inf.finished()) { int n=inf.inflate(buf); if(n>0) out.write(buf,0,n); else if(inf.needsInput()||inf.needsDictionary()) break; else throw new IOException("inflate sem progresso: "+name); } }
    finally { inf.end(); }
    byte[] plain=out.toByteArray(); if(plain.length!=expected) System.err.println("WARN tamanho divergente: "+name+" esperado="+expected+" obtido="+plain.length);
    return plain;
  }
  static boolean seed(String p) {
    return p.startsWith("firecracker/client/shop/recruit/") ||
      p.startsWith("firecracker/client/shop/HeroRecruitPreview") ||
      p.equals("firecracker/client/shop/ShopUserInformation.lua") || p.equals("firecracker/client/shop/RecruitInformation.lua") ||
      p.startsWith("firecracker/res/cocostudio/shop/") || p.startsWith("firecracker/res/language/zh_TW/cocostudio/shop/") ||
      p.startsWith("firecracker/res/images/ui/bg/") || p.startsWith("firecracker/res/language/zh_TW/images/ui/bg/") ||
      p.startsWith("firecracker/res/images/ui/button/") || p.startsWith("firecracker/res/language/zh_TW/images/ui/button/") ||
      p.startsWith("firecracker/res/images/ui/decorative/") || p.startsWith("firecracker/res/language/zh_TW/images/ui/decorative/");
  }
  public static void main(String[] args) throws Exception {
    try(ZipFile zip=new ZipFile(APK)) {
      byte[] key=zip.getInputStream(zip.getEntry("assets/Horriblekimo.bin")).readAllBytes();
      List<String> mapLines=new BufferedReader(new InputStreamReader(zip.getInputStream(zip.getEntry("assets/Horrycation.txt")),StandardCharsets.UTF_8)).lines().toList();
      Map<String,String> mapping=new LinkedHashMap<>(); for(String l:mapLines){int x=l.indexOf('='); if(x>0)mapping.put(l.substring(0,x),l.substring(x+1));}
      LinkedHashSet<String> chosen=new LinkedHashSet<>(); for(String p:mapping.keySet())if(seed(p))chosen.add(p);
      Map<String,byte[]> plain=new LinkedHashMap<>();
      for(String p:chosen){String enc="assets/"+mapping.get(p); ZipEntry e=zip.getEntry(enc); if(e==null)throw new IOException("asset ausente: "+enc); plain.put(p,decode(zip.getInputStream(e).readAllBytes(),key,p));}
      // Pull each image/font/atlas referenced by extracted CSBs and Lua source, in base and zh_TW resource trees.
      for(byte[] b:new ArrayList<>(plain.values())) {
        String s=new String(b,StandardCharsets.ISO_8859_1); Matcher m=RESOURCE.matcher(s);
        while(m.find()) { String r=m.group(); if(!(r.startsWith("images/")||r.startsWith("image/")||r.startsWith("effect/")||r.startsWith("font/")))continue;
          String q="firecracker/res/"+r, zh="firecracker/res/language/zh_TW/"+r;
          if(mapping.containsKey(q))chosen.add(q); if(mapping.containsKey(zh))chosen.add(zh);
        }
      }
      // Extract newly selected referenced resources after scanning all references.
      for(String p:chosen) if(!plain.containsKey(p)){String enc="assets/"+mapping.get(p); ZipEntry e=zip.getEntry(enc); if(e==null)throw new IOException("asset ausente: "+enc); plain.put(p,decode(zip.getInputStream(e).readAllBytes(),key,p));}
      Files.createDirectories(OUT); Path manifest=OUT.getParent().resolve("manifest_sha256.tsv");
      try(BufferedWriter w=Files.newBufferedWriter(manifest,StandardCharsets.UTF_8)) {
        w.write("original_path\tarchive_path\tbytes\tsha256\n");
        for(var entry:plain.entrySet()) { String p=entry.getKey(); byte[] b=entry.getValue(); Path dest=OUT.resolve(p).normalize(); if(!dest.startsWith(OUT))throw new IOException("path traversal"); Files.createDirectories(dest.getParent()); Files.write(dest,b); w.write(p+"\tassets/"+mapping.get(p)+"\t"+b.length+"\t"+sha(b)+"\n"); }
      }
      System.out.println("decoded="+plain.size()+" destination="+OUT+" manifest="+manifest+" key_sha256="+sha(key));
    }
  }
}

