# GsXFuscator V0.6 — `.txt` drag-and-drop upload

This maintenance update keeps the version at **V0.6**. The browser upload panel now accepts `.lua`, `.luau`, and `.txt` through both the file picker and HTML5 drag-and-drop. A `.txt` file must contain **UTF-8 Lua/Luau source text**; arbitrary text is not converted into executable Lua. The output download extension stays `.lua`.

The original safety checks remain: the source file must be non-empty, valid UTF-8, at most 2 MiB, and have a supported extension. The compiler and protection presets are unchanged, including the compact executable output and short V0.6 banner plus requested anime artwork.

No runtime target dropdown was reintroduced. No changes were made to the VM or loader; this update affects file selection and validation only.

## Verified

- `.txt` chooser and drag-and-drop upload
- Compiling a dropped `.txt` file and downloading a `.lua` artifact
- Rejected unsupported extension, over-2-MiB file, empty file, invalid UTF-8
- Uppercase `.TXT` accepted; `.lua` and `.luau` still accepted
- Existing V0.6 browser sealed/direct smoke tests and Lua 5.4 smoke tests

Run tests: `python v2/tests/v06_txt_upload_browser_smoke.py` and `python v2/tests/v06_unified_browser_smoke.py`.
