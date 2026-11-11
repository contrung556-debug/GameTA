# Bé Vui English — Godot 4 3D

A new standalone **real 3D** prototype alongside the existing Flutter app.

## Included
- Orthographic 3D town with geometry, lighting, shadows, roads, school, hospital, market, supermarket, restaurant, park, fountain, cars and bus.
- Mesh-based 3D gray cat mascot, graduation cap, blue shirt and backpack; animated movement to locations.
- Playable 6-place English vocabulary game, 5 questions per location.
- On-device English speech via Godot text-to-speech where supported.
- Stars and completed lessons saved locally as `user://progress.json`.
- Responsive Godot UI in landscape, buttons for every location.
- Offline procedural 3D geometry: no copyrighted game art or remote downloads.

## Run
1. Install **Godot 4.2+**.
2. Import `godot_3d/project.godot` into Godot Project Manager.
3. Press F6/F5 to run.
4. Click a place at the bottom, answer the English quiz and earn stars.

## Mobile export
Install Godot Android export templates, Android SDK and configure an export preset for Android. For iOS, use Godot's iOS export on macOS with Xcode and Apple code signing. No signed APK/IPA is included.

## Important limitations
This is an initial interactive **3D game prototype**, not a polished AAA-style game or a verified phone build. Procedural low-poly meshes do not yet match the photorealistic/polished pre-rendered references. Godot is not available in the current environment to run an automated scene import/export, so syntax and mobile performance still need testing in Godot. The original Flutter app is unchanged and remains separate.
