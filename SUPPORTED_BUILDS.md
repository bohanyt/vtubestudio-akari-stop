# Supported Builds

This project only patches builds whose asset layout has been inspected and whose exact input/output hashes are known.

## Current

Original `sharedassets0.assets` SHA-256:

```text
9839b25cc8bcaa5d2b0db9f6abfaa3d1caabbefc91855f60f8c450acea29d792
```

Expected patched SHA-256:

```text
02c66838063ad592c67ca5d2520544d33afa515bb8d21cb508c59cc0694d9c46
```

Target animation:

```text
AkariLoadingMove_Watermark
PathID: 1071
```

Observed movement loop length: approximately 44.33 seconds.

## Adding another build

Do not reuse raw offsets from this build blindly. A new build should be independently inspected to confirm the target AnimationClip, movement curves, byte offsets, and expected post-patch hash.
