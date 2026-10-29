"""Shared local gameplay configuration; tutorial opt-in only for legacy tests."""
import json,os
from pathlib import Path
CONFIG=json.loads((Path(__file__).resolve().parents[1]/'gameplay.json').read_text(encoding='utf8'))
def tutorial_enabled():
    if not os.environ.get('NR_ACCOUNTS_DIR'):return False
    override=os.environ.get('NR_ENABLE_TUTORIAL')
    return override=='1' if override is not None else bool(CONFIG['tutorial_enabled'])
STARTERS=tuple(CONFIG['starter_moulds'])
