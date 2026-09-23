# VTube Studio Akari Stop

A tiny Windows patch that keeps the built-in **Akari webcam watermark visible** in VTube Studio, but stops it from flying across the screen.

This was made for capture workflows where the moving watermark makes cropping or framing difficult.

> **This does not remove, hide, or make the watermark transparent.**
> Akari remains visible. The patch only freezes the movement curves that move her around the screen.

## Status

**Proof-of-concept / version-specific.**

The current patch is verified against the exact `sharedassets0.assets` build identified by:

```text
SHA256
9839b25cc8bcaa5d2b0db9f6abfaa3d1caabbefc91855f60f8c450acea29d792
```

The patcher refuses to modify other builds.

## What it changes

The movement was traced to:

```text
sharedassets0.assets
AnimationClip: AkariLoadingMove_Watermark
PathID: 1071
```

The clip drives the watermark's `RectTransform` movement.

The patch keeps Akari's visual/frame animation intact while fixing the targeted movement curves to a static position.

It does **not** patch:

- VTube Studio's paid watermark-removal feature
- Akari's PNG assets
- `Assembly-CSharp.dll`
- the Public Plugin API
- any Steam entitlement or DLC check

## Usage

1. Close VTube Studio.
2. In Steam, open **VTube Studio → Manage → Browse local files**.
3. Open `VTube Studio_Data`.
4. Copy these four files into that folder, next to `sharedassets0.assets`:

```text
PATCH_AKARI_FREEZE.cmd
PATCH_AKARI_FREEZE.ps1
RESTORE_AKARI_ORIGINAL.cmd
RESTORE_AKARI_ORIGINAL.ps1
```

5. Double-click `PATCH_AKARI_FREEZE.cmd`.
6. Press a key when prompted.
7. The patch should finish with `PATCH PASS`.
8. Start VTube Studio and watch Akari for at least one full movement cycle (~45–60 seconds).

## Safety

Before writing anything, the script checks that `sharedassets0.assets` matches the supported SHA-256 hash.

It automatically creates:

```text
sharedassets0.assets.akari-original
```

If the post-patch hash is unexpected, the script restores the backup automatically.

## Restore

Close VTube Studio, then run:

```text
RESTORE_AKARI_ORIGINAL.cmd
```

You can also restore the original file through Steam's **Verify integrity of game files**.

## Why not use the VTube Studio API?

The normal VTube Studio item API can expose user-loaded items, but the built-in webcam watermark is not exposed as a normal `ItemListResponse` item.

The movement was therefore traced in the Unity assets instead.

## Compatibility

Currently supported:

| Asset SHA-256 | Status |
|---|---|
| `9839b25cc8bcaa5d2b0db9f6abfaa3d1caabbefc91855f60f8c450acea29d792` | Tested |

If VTube Studio updates and the hash changes, **do not force the patch**. Open an issue with the VTube Studio version and SHA-256 of `sharedassets0.assets`.

See [SUPPORTED_BUILDS.md](SUPPORTED_BUILDS.md) for technical details.

## Disclaimer

Unofficial community tool. Not affiliated with or endorsed by DenchiSoft or VTube Studio.

No VTube Studio binaries, artwork, models, textures, or other proprietary assets are distributed by this repository.

Use at your own risk and keep a backup.

## License

The scripts and documentation in this repository are licensed under the MIT License.
