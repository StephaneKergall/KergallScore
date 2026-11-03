"""Sérialisation JSON compacte, avec `orjson` si disponible (repli standard)."""
import json
from pathlib import Path

try:
    import orjson as _orjson
except Exception:  # dépendance optionnelle
    _orjson = None


def loads(data):
    if _orjson is not None:
        return _orjson.loads(data)
    return json.loads(data)


def dumps(obj):
    if _orjson is not None:
        return _orjson.dumps(obj, option=_orjson.OPT_NON_STR_KEYS).decode("utf-8")
    return json.dumps(obj, ensure_ascii=False, separators=(",", ":"))


def load(path):
    return loads(Path(path).read_bytes())


def dump(obj, path):
    Path(path).write_text(dumps(obj))
