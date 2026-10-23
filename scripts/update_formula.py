#!/usr/bin/env python3
"""Point a formula at the latest upstream release.

Reads the release's published SHA256SUMS rather than re-downloading and
hashing each archive, so the formula can only ever carry checksums the
release itself vouched for.

Usage: update_formula.py <formula.rb> <owner/repo> <asset-prefix>
Exits 0 whether or not anything changed; prints "changed=true|false" to
$GITHUB_OUTPUT when running under Actions.
"""

import json
import os
import re
import sys
import urllib.request

# Formula sha256 lines, in the order the platforms appear in the file,
# paired with the suffix of the asset each one covers.
PLATFORM_SUFFIXES = [
    "macos-apple-silicon.tar.gz",
    "macos-intel.tar.gz",
    "linux-arm64.tar.gz",
    "linux-x86-64.tar.gz",
]


def fetch(url, as_json=False):
    req = urllib.request.Request(url, headers={"User-Agent": "homebrew-tap-updater"})
    token = os.environ.get("GITHUB_TOKEN")
    if token and "api.github.com" in url:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30) as resp:
        body = resp.read().decode()
    return json.loads(body) if as_json else body


def main():
    formula_path, repo, prefix = sys.argv[1], sys.argv[2], sys.argv[3]

    latest = fetch(f"https://api.github.com/repos/{repo}/releases/latest", as_json=True)
    tag = latest["tag_name"]
    version = tag.lstrip("v")

    formula = open(formula_path).read()
    current = re.search(r'^\s*version "([^"]+)"', formula, re.M).group(1)
    if current == version:
        print(f"already at {version}, nothing to do")
        emit(changed=False)
        return

    sums_url = f"https://github.com/{repo}/releases/download/{tag}/SHA256SUMS"
    sums = {}
    for line in fetch(sums_url).splitlines():
        digest, _, name = line.partition("  ")
        if name:
            sums[name.strip()] = digest.strip()

    # Resolve every checksum before touching the file, so a missing asset
    # can't leave the formula half-updated.
    digests = []
    for suffix in PLATFORM_SUFFIXES:
        name = f"{prefix}-{suffix}"
        if name not in sums:
            sys.exit(f"error: {name} missing from {tag} SHA256SUMS")
        digests.append(sums[name])

    sha_lines = re.findall(r'^\s*sha256 "[0-9a-f]{64}"', formula, re.M)
    if len(sha_lines) != len(digests):
        sys.exit(
            f"error: formula has {len(sha_lines)} sha256 lines, "
            f"expected {len(digests)} - update PLATFORM_SUFFIXES"
        )

    formula = re.sub(
        r'^(\s*)version "[^"]+"', rf'\g<1>version "{version}"', formula, count=1, flags=re.M
    )

    remaining = list(digests)
    formula = re.sub(
        r'(^\s*sha256 ")[0-9a-f]{64}(")',
        lambda m: m.group(1) + remaining.pop(0) + m.group(2),
        formula,
        flags=re.M,
    )

    open(formula_path, "w").write(formula)
    print(f"updated {current} -> {version}")
    emit(changed=True, version=version, tag=tag)


def emit(**kw):
    out = os.environ.get("GITHUB_OUTPUT")
    if not out:
        return
    with open(out, "a") as fh:
        for k, v in kw.items():
            fh.write(f"{k}={str(v).lower() if isinstance(v, bool) else v}\n")


if __name__ == "__main__":
    main()
