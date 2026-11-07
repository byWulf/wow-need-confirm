# AGENTS.md

## Language

All documentation in this repository (README, AGENTS.md, code comments, commit messages) is written in **English**.

## Project

WoW addon `NeedConfirm`: shows a Yes/No dialog before a Need roll on group loot.

- `NeedConfirm.toc`: addon manifest, interface `16001` (WoW Forever only, Classic Era is not supported), `Notes` in all client languages
- `NeedConfirm.lua`:
  - Replaces the global `RollOnLoot`. A call with roll type `1` (Need) shows the static popup `NEEDCONFIRM_ROLL` (item link from `GetLootRollItemLink`, roll ID as popup data) instead of rolling; `OnAccept` calls the original `RollOnLoot`. All other roll types pass through. `RollOnLoot` is not protected, so replacing it causes no blocked actions. This is independent of how the loot roll frame is built (Blizzard's or another addon's).
  - Shift held: no question.
  - Bind-on-pickup items (5th return of `GetLootRollItemInfo`) are passed through, because Blizzard asks with `CONFIRM_LOOT_ROLL` anyway, unless Leatrix Plus auto-confirms those (`LeaPlusDB.NoConfirmLoot == "On"`).
  - `CANCEL_LOOT_ROLL` closes the popup for that roll ID.
  - Popup texts per locale in `TEXTS`; `{need}` is replaced with the client's global `NEED` string (fallback `NEED_WORDS`), `%s` is the item link. Keep the local roll constant named `ROLL_NEED`, a local `NEED` would shadow the global string.
- `README.md`: user documentation

## Installed copies

The addon is installed as a plain copy (not a clone) in:

- `C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\NeedConfirm`

After changing the `.toc` or `.lua`, copy them there. The folder name must stay `NeedConfirm`.

## Testing

There is no automated test setup. Changes are verified in game with `/reload` and a group loot roll (click Need, check the question, No keeps the roll window open).

## Releasing

Published on CurseForge as project `<ID>` (https://www.curseforge.com/wow/addons/need-confirm) and as GitHub releases. Releases are built by `.github/workflows/release.yml` with the BigWigs packager (`.pkgmeta` sets the folder name and leaves out `AGENTS.md`/`CLAUDE.md`):

1. Commit and push the changes to `main`.
2. Tag and push: `git tag -a vX.Y.Z -m "X.Y.Z"` and `git push origin vX.Y.Z` (semantic versioning).
3. The workflow packages the addon, replaces `@project-version@` in the TOC with the tag, uploads the zip to CurseForge (game version from the TOC interface, WoW Forever) and creates the GitHub release. The changelog is generated from the commit messages since the previous tag.

The CurseForge upload needs the repository secret `CF_API_TOKEN` (a CurseForge author API token). "Run workflow" on the Actions tab builds the package as an artifact without uploading. Never edit `## Version` in the TOC by hand; installed dev copies show `@project-version@`.
