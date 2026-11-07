# Need Confirm

Asks for confirmation before you roll **Need** on group loot, so a misclick doesn't cost your group an item.

When you click Need, a dialog asks "Really roll Need on [item]?" first. Only **Yes** rolls Need. **No** or Escape does nothing, and the loot roll window stays open so you can still choose Greed or Pass.

## Supported game versions

| Version | Interface |
|---|---|
| WoW Forever | 16001 |

Classic Era and other versions are not supported.

## Installation

Install it from [CurseForge](https://www.curseforge.com/wow/addons/need-confirm), e.g. with the CurseForge app.

For a manual installation, note that the folder in your AddOns directory **must** be named `NeedConfirm`, otherwise WoW will not load the addon:

```bash
cd "C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns"
git clone https://github.com/byWulf/wow-need-confirm.git NeedConfirm
```

Alternatively, download the ZIP from the [releases](https://github.com/byWulf/wow-need-confirm/releases) and extract it into `Interface/AddOns`.

Then `/reload` in game.

## Usage

There is nothing to set up.

- **Need** asks first. Greed and Pass roll right away as before.
- Hold **Shift** while clicking Need to roll without the question.
- Bind-on-pickup items already get Blizzard's own "will bind to you" confirmation, so the addon doesn't ask a second time. If you switched that Blizzard dialog off with Leatrix Plus ("Disable loot warnings"), the addon asks instead.
- If the roll times out while the question is open, the question closes by itself.

The addon works with the default loot roll window and with other addons that replace it, because it checks the Need roll itself, not a particular button.

The dialog is available in English, German, French, Spanish, Italian, Portuguese, Russian, Korean and Chinese (simplified and traditional).

## License

MIT, see [LICENSE](LICENSE).
