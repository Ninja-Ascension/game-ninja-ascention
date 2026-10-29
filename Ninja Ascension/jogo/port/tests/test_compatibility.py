import importlib.util, json, unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('probe',ROOT/'tools/probe_compatibility.py')
probe=importlib.util.module_from_spec(spec);spec.loader.exec_module(probe)

class CompatibilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.manifest,cls.results=probe.inspect()
    def test_engine_pins(self): self.assertEqual(self.results['axmol']['revision'],probe.AX_REV)
    def test_csb_binary_decodes_identically(self): self.assertTrue(self.results['csb_decode_matches_prior'])
    def test_spine_mismatch_is_not_hidden(self): self.assertFalse(self.results['direct_spine_compatible'])
    def test_legacy_parser_present(self): self.assertTrue(self.results['legacy']['old_json_parser_present'])
    def test_selected_files_hashes(self):
        for row in self.manifest['files']: self.assertEqual(probe.record(probe.RES/row['path']),row)
    def test_original_branch_27(self):
        config=json.loads(probe.read(probe.RES/'configs/app.config'))
        self.assertEqual(config['ReleaseProject'],'27')
        text=probe.read(ROOT/'01_conteudo_apk/assets/src/client/operation/Config.lua')
        self.assertRegex(text,r'__lua_project_l_naruto\s*=\s*27')
    def test_selected_animation_exists(self): self.assertIn(self.manifest['animation'],self.manifest['animations'])
    def test_original_config_coordinates(self):
        config=json.loads(probe.read(probe.RES/'configs/app.config'))
        self.assertEqual(config['designSize'],{'width':960,'height':640})
        self.assertEqual(config['ResolutionPolicy'],'FIXED_HEIGHT')
        self.assertEqual(config['fps'],60)
if __name__=='__main__': unittest.main(verbosity=2)
