#!/bin/sh
# Copy the included skills from mattpocock/skills into skills/, unchanged.
#
# Usage: scripts/sync-upstream.sh [commit]
#   commit  upstream commit to copy (default: the pinned one below).
#
# The skills are copied verbatim so a later sync is a plain diff. Everything
# marcsh-specific lives in agents/ and commands/, never in skills/.
# After a sync, review `git diff`, update UPSTREAM.md, and test the pack.
set -eu

UPSTREAM_URL="https://github.com/mattpocock/skills.git"
PINNED_COMMIT="5863806dd4e15c63174bee4e7515a4256792ecfa"
COMMIT="${1:-$PINNED_COMMIT}"

# Upstream path -> pack skill name (the folder name is kept).
INCLUDE="
engineering/setup-matt-pocock-skills
engineering/ask-matt
engineering/grill-with-docs
engineering/to-spec
engineering/to-tickets
engineering/implement
engineering/implement-spec
engineering/code-review
engineering/retro
engineering/pr
engineering/codebase-design
engineering/domain-modeling
engineering/tdd
engineering/prototype
engineering/research
engineering/wayfinder
engineering/diagnosing-bugs
engineering/improve-codebase-architecture
engineering/triage
productivity/grilling
productivity/handoff
productivity/grill-me
productivity/wait-what
"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone -q "$UPSTREAM_URL" "$TMP/src"
git -C "$TMP/src" checkout -q "$COMMIT"
FULL="$(git -C "$TMP/src" rev-parse HEAD)"

mkdir -p "$ROOT/skills" "$ROOT/LICENSES"
for path in $INCLUDE; do
  name="$(basename "$path")"
  src="$TMP/src/skills/$path"
  [ -f "$src/SKILL.md" ] || { echo "missing upstream skill: $path" >&2; exit 1; }
  rm -rf "$ROOT/skills/$name"
  cp -R "$src" "$ROOT/skills/$name"
  # Codex-only metadata; marcsh does not read it.
  rm -rf "$ROOT/skills/$name/agents"
done

cp "$TMP/src/LICENSE" "$ROOT/LICENSES/mattpocock-skills-MIT.txt"

# marcsh rejects packs with symlinks in skills/.
if [ -n "$(find "$ROOT/skills" -type l)" ]; then
  echo "symlink found in skills/; marcsh would reject the pack" >&2
  exit 1
fi

echo "synced $(echo "$INCLUDE" | grep -c .) skills from $FULL"
