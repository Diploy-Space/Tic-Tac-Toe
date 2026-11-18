#!/usr/bin/env python3
"""Merge translation batches into the ARB files.

    python3 tool/l10n_merge.py batch.json [batch2.json ...]

A batch is {"keyName": {"en": "...", "hi": "...", ...}, ...}.
- English goes to app_en.arb (the template) with @key metadata; any
  {placeholder} becomes a String placeholder.
- Every other language goes to app_<lang>.arb. Missing languages simply
  fall back to English at runtime (listed in build/l10n_untranslated.json).
"""
import json, os, re, sys
from collections import OrderedDict

ARB_DIR = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n', 'arb')
LANGS = ['en', 'hi', 'bn', 'or', 'ta', 'te', 'gu', 'mr', 'kn', 'ml', 'pa',
         'ur', 'es', 'fr', 'de', 'ar', 'pt', 'zh', 'ja', 'ko', 'ru', 'it']
KEY_RE = re.compile(r'^[a-z][A-Za-z0-9]*$')
PH_RE = re.compile(r'\{([A-Za-z][A-Za-z0-9]*)\}')


def load(lang):
    path = os.path.join(ARB_DIR, f'app_{lang}.arb')
    if os.path.exists(path):
        with open(path, encoding='utf-8') as f:
            return json.load(f, object_pairs_hook=OrderedDict)
    return OrderedDict([('@@locale', lang)])


def save(lang, data):
    head = OrderedDict([('@@locale', lang)])
    keys = sorted(k for k in data if not k.startswith('@'))
    for k in keys:
        head[k] = data[k]
        if f'@{k}' in data:
            head[f'@{k}'] = data[f'@{k}']
    with open(os.path.join(ARB_DIR, f'app_{lang}.arb'), 'w',
              encoding='utf-8') as f:
        json.dump(head, f, ensure_ascii=False, indent=2)
        f.write('\n')


def main(paths):
    arbs = {l: load(l) for l in LANGS}
    errors = []
    for p in paths:
        with open(p, encoding='utf-8') as f:
            batch = json.load(f)
        for key, tr in batch.items():
            if not KEY_RE.match(key):
                errors.append(f'{p}: bad key {key!r}')
                continue
            en = tr.get('en')
            if en is None:
                errors.append(f'{p}: {key} has no English')
                continue
            phs = PH_RE.findall(en)
            arbs['en'][key] = en
            meta = OrderedDict()
            if phs:
                meta['placeholders'] = OrderedDict(
                    (n, {'type': 'String'}) for n in dict.fromkeys(phs))
            arbs['en'][f'@{key}'] = meta
            for lang in LANGS[1:]:
                v = tr.get(lang)
                if v is None:
                    continue
                missing = set(phs) - set(PH_RE.findall(v))
                if missing:
                    errors.append(f'{p}: {key}[{lang}] lost {missing}')
                    continue
                arbs[lang][key] = v
    for l, d in arbs.items():
        save(l, d)
    if errors:
        print('\n'.join(errors), file=sys.stderr)
        sys.exit(1)
    print(f'merged {len(paths)} batch(es); {sum(1 for k in arbs["en"] if not k.startswith("@"))} keys')


if __name__ == '__main__':
    main(sys.argv[1:])
