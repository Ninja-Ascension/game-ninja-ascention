import faulthandler
import tempfile
import traceback

faulthandler.enable()
print('TMPDIR', tempfile.gettempdir(), flush=True)
try:
    d = tempfile.mkdtemp(prefix='._probe_')
    print('NOARG_OK', repr(d), flush=True)
except BaseException:
    traceback.print_exc()
    print('NOARG_FAIL', flush=True)
try:
    with tempfile.TemporaryDirectory(prefix='._probe_') as f:
        print('TD_OK', repr(f), flush=True)
except BaseException:
    traceback.print_exc()
    print('TD_FAIL', flush=True)
print('END', flush=True)
