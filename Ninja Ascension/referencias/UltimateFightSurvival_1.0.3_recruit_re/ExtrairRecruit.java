import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.Inflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

/** Extract only the original Recruit client sources, layouts, and referenced visual assets. */
public final class ExtrairRecruit {
    private static final String ROOT = "firecracker/";
    private static final Pattern RESOURCE = Pattern.compile(
        "(?i)(?:[\\w./-]+/)?[\\w.-]+\\.(?:png|jpg|jpeg|webp|plist|atlas|json|csb|ExportJson|fnt|ttf|mp3|ogg|wav|lua)"
    );
    private static final Set<String> VISUAL_EXT = Set.of(
        ".png", ".jpg", ".jpeg", ".webp", ".plist", ".atlas", ".json", ".csb", ".fnt", ".ttf"
    );

    private final ZipFile apk;
    private final Path output;
    private final Map<String, String> mapping = new LinkedHashMap<>();
    private final Map<String, byte[]> decoded = new LinkedHashMap<>();
    private final Set<String> unresolved = new TreeSet<>();
    private final ArrayDeque<String> queue = new ArrayDeque<>();
    private final Set<String> queued = new LinkedHashSet<>();
    private final byte[] blowfishKey;
    private final Cipher blowfish;

    private ExtrairRecruit(Path apkPath, Path output) throws Exception {
        this.apk = new ZipFile(apkPath.toFile());
        this.output = output.toAbsolutePath().normalize();
        byte[] mapBytes = apk.getInputStream(required("assets/Horrycation.txt")).readAllBytes();
        for (String line : new String(mapBytes, StandardCharsets.UTF_8).split("\\r?\\n")) {
            int equals = line.indexOf('=');
            if (equals > 0) mapping.put(line.substring(0, equals), line.substring(equals + 1));
        }
        // The game reads this key from memory during its normal asset bootstrap.
        // It is intentionally never written into the analysis folder or logs.
        blowfishKey = apk.getInputStream(required("assets/Horriblekimo.bin")).readAllBytes();
        blowfish = Cipher.getInstance("Blowfish/ECB/NoPadding");
        blowfish.init(Cipher.DECRYPT_MODE, new SecretKeySpec(blowfishKey, "Blowfish"));
    }

    private ZipEntry required(String name) throws Exception {
        ZipEntry entry = apk.getEntry(name);
        if (entry == null) throw new IllegalStateException("Entrada ausente no APK: " + name);
        return entry;
    }

    private static void add(Set<String> seeds, String logicalPath) {
        seeds.add(logicalPath.replace('\\', '/'));
    }

    private void seed() {
        Set<String> paths = new TreeSet<>();
        for (String path : mapping.keySet()) {
            if (path.startsWith(ROOT + "client/shop/recruit/")) add(paths, path);
            if (path.startsWith(ROOT + "client/shop/") && path.endsWith(".lua")) {
                String file = path.substring(path.lastIndexOf('/') + 1).toLowerCase();
                if (file.contains("recruit") || file.startsWith("herorecruitpreview")) add(paths, path);
            }
        }
        for (String path : List.of(
            "firecracker/res/cocostudio/shop/shop.csb",
            "firecracker/res/cocostudio/shop/recruit_god.csb",
            "firecracker/res/cocostudio/shop/recruit_settlement_ten.csb",
            "firecracker/res/cocostudio/shop/recruit_settlement_animation.csb",
            "firecracker/res/language/zh_TW/cocostudio/shop/shop.csb",
            "firecracker/res/language/zh_TW/cocostudio/shop/recruit_god.csb",
            "firecracker/res/language/zh_TW/cocostudio/shop/recruit_settlement_ten.csb",
            "firecracker/res/language/zh_TW/cocostudio/shop/recruit_settlement_animation.csb",
            "firecracker/res/images/ui/text/chouka_di_01.png",
            "firecracker/res/images/ui/text/chouka_di_02.png",
            "firecracker/res/images/ui/text/chouka_di_03.png",
            "firecracker/res/images/ui/text/chouka_di_04.png",
            "firecracker/res/language/zh_TW/images/ui/text/chouka_di_01.png",
            "firecracker/res/language/zh_TW/images/ui/text/chouka_di_02.png",
            "firecracker/res/language/zh_TW/images/ui/text/chouka_di_03.png",
            "firecracker/res/language/zh_TW/images/ui/text/chouka_di_04.png",
            "firecracker/res/images/ui/decorative/bg_yun_1.png",
            "firecracker/res/images/ui/bg/hy_zhaomu_bg.png",
            "firecracker/res/images/ui/bg/pve_npc_bg.png",
            "firecracker/res/sprite/sprite_zhaomubg.json",
            "firecracker/res/sprite/sprite_zhaomubg.atlas",
            "firecracker/res/sprite/sprite_zhaomubg.png",
            "firecracker/res/sprite/sprite_zhaomubg_2.json",
            "firecracker/res/sprite/sprite_zhaomubg_2.atlas",
            "firecracker/res/sprite/sprite_zhaomubg_2.png",
            "firecracker/res/data/mould/partner_bounty_param.txt"
        )) if (mapping.containsKey(path)) add(paths, path);
        for (String path : paths) enqueue(path);
    }

    private void enqueue(String logical) {
        if (!mapping.containsKey(logical)) {
            unresolved.add(logical);
            return;
        }
        if (queued.add(logical)) queue.addLast(logical);
    }

    private byte[] inflate(byte[] data) throws Exception {
        Inflater inflater = new Inflater();
        inflater.setInput(data);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        byte[] chunk = new byte[32768];
        try {
            while (!inflater.finished()) {
                int n = inflater.inflate(chunk);
                if (n > 0) out.write(chunk, 0, n);
                else if (inflater.needsInput() || inflater.needsDictionary()) break;
                else throw new IllegalStateException("Fluxo zlib sem progresso: " + n);
            }
        } finally { inflater.end(); }
        return out.toByteArray();
    }

    private byte[] decode(String logical) throws Exception {
        String packedPath = "assets/" + mapping.get(logical);
        byte[] packed = apk.getInputStream(required(packedPath)).readAllBytes();
        // Cocos ships some shared TTF files in clear text even when neighboring
        // image, layout, and Lua resources use the encrypted wrapper.
        if (packed.length >= 4 && ((packed[0] == 0 && packed[1] == 1 && packed[2] == 0 && packed[3] == 0)
            || (packed[0] == 'O' && packed[1] == 'T' && packed[2] == 'T' && packed[3] == 'O')))
            return packed;
        if (packed.length < 11 || packed[0] != 0x39 || packed[1] != 0x7f || packed[2] != 0x13)
            throw new IllegalStateException("Cabeçalho desconhecido: " + logical);
        int encryptedLength = le32(packed, 3);
        int compressedLength = le32(packed, 7);
        if (encryptedLength < 8 || (encryptedLength & 7) != 0 || packed.length != encryptedLength + 11)
            throw new IllegalStateException("Tamanho criptografado inválido: " + logical);
        byte[] compressed = blowfish.doFinal(packed, 11, encryptedLength);
        if (compressedLength > compressed.length) throw new IllegalStateException("Comprimento inválido: " + logical);
        byte[] plain = inflate(Arrays.copyOf(compressed, compressedLength));
        return plain;
    }

    private static int le32(byte[] data, int offset) {
        return (data[offset] & 255) | ((data[offset + 1] & 255) << 8)
            | ((data[offset + 2] & 255) << 16) | ((data[offset + 3] & 255) << 24);
    }

    private void scanReferences(String logical, byte[] bytes) {
        String text = new String(bytes, StandardCharsets.ISO_8859_1);
        Matcher matcher = RESOURCE.matcher(text);
        while (matcher.find()) {
            String token = matcher.group().replace('\\', '/');
            String lower = token.toLowerCase();
            if (token.length() < 8 || lower.endsWith(".lua") || !isVisual(lower)) continue;
            String normalized = normalizeReference(token);
            if (normalized != null && mapping.containsKey(normalized)) enqueue(normalized);
            else resolveSuffix(token);
        }
        // Sprite atlases refer to their paired image by basename rather than full path.
        if (logical.endsWith(".atlas")) {
            String atlasText = new String(bytes, StandardCharsets.UTF_8);
            Matcher image = Pattern.compile("(?m)^([^\\r\\n]+\\.(?:png|jpg|jpeg))\\s*$", Pattern.CASE_INSENSITIVE).matcher(atlasText);
            while (image.find()) resolveSibling(logical, image.group(1).trim());
        }
    }

    private static boolean isVisual(String lower) {
        for (String ext : VISUAL_EXT) if (lower.endsWith(ext)) return true;
        return false;
    }

    private String normalizeReference(String token) {
        String path = token.replace('\\', '/');
        while (path.startsWith("./")) path = path.substring(2);
        if (path.startsWith(ROOT)) return path;
        if (path.startsWith("res/")) return ROOT + path;
        if (path.startsWith("images/") || path.startsWith("sprite/") || path.startsWith("effect/")
            || path.startsWith("cocostudio/") || path.startsWith("data/")) return ROOT + "res/" + path;
        if (path.startsWith("shop/") || path.startsWith("icon/") || path.startsWith("utils/"))
            return ROOT + "res/cocostudio/" + path;
        return null;
    }

    private void resolveSibling(String parent, String filename) {
        String dir = parent.substring(0, parent.lastIndexOf('/') + 1);
        String exact = dir + filename;
        if (mapping.containsKey(exact)) enqueue(exact); else resolveSuffix(filename);
    }

    private void resolveSuffix(String token) {
        String suffix = token.replace('\\', '/');
        int rootAt = suffix.indexOf("res/");
        if (rootAt >= 0) suffix = suffix.substring(rootAt);
        else if (suffix.startsWith("images/") || suffix.startsWith("sprite/") || suffix.startsWith("effect/") || suffix.startsWith("cocostudio/")) suffix = "res/" + suffix;
        List<String> matches = new ArrayList<>();
        for (String candidate : mapping.keySet()) {
            if (candidate.startsWith(ROOT + "res/") && candidate.endsWith(suffix)) matches.add(candidate);
        }
        if (matches.size() == 1) enqueue(matches.get(0));
        else if (matches.size() > 1) {
            if (matches.stream().anyMatch(p -> decoded.containsKey(p) || queued.contains(p))) return;
            List<String> baseMatches = matches.stream().filter(p -> !p.contains("/language/")).toList();
            if (baseMatches.size() == 1) enqueue(baseMatches.get(0));
            else unresolved.add("ambíguo:" + token + " -> " + String.join(" | ", matches));
        }
        else unresolved.add("referência:" + token);
    }

    private static String sha256(byte[] data) throws Exception {
        byte[] hash = MessageDigest.getInstance("SHA-256").digest(data);
        StringBuilder s = new StringBuilder();
        for (byte b : hash) s.append(String.format("%02x", b));
        return s.toString();
    }

    private void extract() throws Exception {
        Files.createDirectories(output);
        seed();
        while (!queue.isEmpty()) {
            String logical = queue.removeFirst();
            byte[] data = decode(logical);
            decoded.put(logical, data);
            Path destination = output.resolve("extraido").resolve(logical).normalize();
            if (!destination.startsWith(output)) throw new SecurityException("Caminho fora da pasta de destino");
            Files.createDirectories(destination.getParent());
            Files.write(destination, data);
            String ext = logical.substring(logical.lastIndexOf('.')).toLowerCase();
            if (ext.equals(".lua") || ext.equals(".csb") || ext.equals(".json") || ext.equals(".atlas") || ext.equals(".plist"))
                scanReferences(logical, data);
        }
        List<String> files = new ArrayList<>();
        for (Map.Entry<String, byte[]> item : decoded.entrySet())
            files.add("    {\"path\":\"" + item.getKey() + "\",\"bytes\":" + item.getValue().length + ",\"sha256\":\"" + sha256(item.getValue()) + "\"}");
        String manifest = "{\n  \"source\": \"Ultimate+Fight_Survival_1.0.3_APKPure.apk\",\n  \"method\": \"Horrycation map; Blowfish/ECB/NoPadding + zlib for protected files; validated clear TTF passthrough\",\n  \"count\": " + decoded.size() + ",\n  \"files\": [\n" + String.join(",\n", files) + "\n  ],\n  \"unresolved_references\": [\n";
        List<String> unresolvedJson = new ArrayList<>();
        for (String ref : unresolved) unresolvedJson.add("    \"" + ref.replace("\\", "\\\\").replace("\"", "\\\"") + "\"");
        manifest += String.join(",\n", unresolvedJson) + "\n  ]\n}\n";
        Files.writeString(output.resolve("manifesto_recruit.json"), manifest, StandardCharsets.UTF_8);
        System.out.println("Extraídos " + decoded.size() + " arquivos do Recruit em " + output.resolve("extraido"));
        System.out.println("Referências não resolvidas/ambíguas: " + unresolved.size());
        for (String ref : unresolved) System.out.println("  " + ref);
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) throw new IllegalArgumentException("Uso: java ExtrairRecruit.java <apk> <pasta-separada>");
        try (ZipFile ignored = new ZipFile(args[0])) { }
        ExtrairRecruit extractor = new ExtrairRecruit(Path.of(args[0]), Path.of(args[1]));
        try { extractor.extract(); } finally { extractor.apk.close(); }
    }
}
