## 📦 Dependencies

This repository relies on the following tools:

- Python
- splat 0.38.0 / spimdisasm 1.40.1 (https://github.com/ethteck/splat)

`splat` must be reachable from your `PATH`.

---

## 📖 Overview

Splat configuration to disassemble **Crash Team Racing (NTSC-U, SCUS-94426)**:
the PSX-EXE plus its 13 overlays, each with its own `.yaml`, its own symbol file
and a section layout verified against the raw bytes of the binary.

Every function is declared with its exact start and size, and every byte of every
binary lands in a declared section. This is no longer a proof of concept: the
current split reproduces all 14 binaries byte for byte.

### The binaries

| Group | Files | Load address |
|---|---|---|
| PSX-EXE | `SCUS_944.26` | `0x80010000` |
| EndRaceMenu | `221`-`225` | `0x8009F6FC` |
| Quadblock | `226`-`229` | `0x800A0CB8` |
| Threads | `230`-`233` | `0x800AB9F0` |

The three overlay groups **tile without overlapping**. Within a group the
overlays are alternatives, but one overlay from each group can be resident at the
same time. That is why every overlay config loads the EXE symbols as well, while
the EXE config loads none of the overlays' (the relationship is asymmetric, the
same convention used by silent-hill-decomp and sotn-decomp).

---

## 📁 Layout

```
yaml/         one .yaml per binary (14)
syms/         one symbol file per binary, plus the psyq symbol names
split/        generated output (asm + data + rodata + bss)
split_all.bat runs the extraction for all 14 binaries
```

---

## ⚙️ Running it

Place the 14 binaries in the repository root with their exact names and
double-click **`split_all.bat`**. It checks that every file is present, reports
any that are missing, extracts all 14 into `split/`, and waits for a keypress
instead of closing the window.

To run a single config by hand:

```
splat split yaml\226_cfg.yaml
```

Note that `base_path` inside each yaml is `../split`, because splat resolves it
relative to the folder containing the yaml file.

---


### Current results

| Check | Result |
|---|---|
| `alabel` | **0 / 14** |
| Zero-size functions | **0 / 14** |
| Byte-for-byte rebuild | **14 / 14**, 0 ignored, 0 mismatched, 0 duplicated |
| Code inside data regions | **0 / 14** |
| Data disassembled as code | **0 / 14** |
| psyq symbols | **131 / 131** land on a real function start, sizes exact |
| Spurious symbols | 0, except 1 each in overlays 227, 228 and 229 |

Function counts:

```
PSX-EXE 1213    221_ovr   1    226_ovr 177    230_ovr  86
            	222_ovr   2    227_ovr 186    231_ovr 126
            	223_ovr   3    228_ovr 151    232_ovr  37
            	224_ovr   3    229_ovr 154    233_ovr  52
            	225_ovr   1
```

---

## ⚠️ Known and documented

Two things are known, understood and deliberately left as they are.

**1. Four bytes of padding at the end of the EXE's `.text`.** An alignment `nop`
at `0x8008099C` that nothing references, fixing it would
mean breaking the EXE's section convention for no gain.

**2. 55 incomplete functions in hand-written assembly** — 6 (?) in the EXE and
16/13/10/10 in overlays 226-229; the other nine binaries have none. These are
functions whose last transfer jumps into the middle of another function. They are
all declared, all sized, and all their bytes are covered; what cannot be expressed
is where they jump at the end.

Apparently they are **not** a bad split, and this was measured rather than assumed. Merging
them is blocked in every single case by a symbol that is a genuine entry point:
`func_8006B82C` in the EXE is called by 6 `jal`, `func_800AAB80` in overlay 226 by
52. The handful that looked free were referenced by `%hi`/`%lo` pairs that build
return addresses by hand — removing them produced 13 `alabel`, so it was reverted.

The reason is that apparently the code genuinely has multiple entry points (feel free to correct it), which C cannot
express:

- Overlay 226: address `0x800A1BE8` is reached **both** by falling through from
  `0x800A1BE4` inside `func_800A19A8` **and** by a `bgez $zero` from
  `func_800A18C0`. Two predecessors, one internal and one external.
- PSX-EXE: `0x8006B954` is the **delay slot** of the `jr $ra` at `0x8006B950`, and
  four functions jump straight into it to share an epilogue. No compiler emits
  that.

This is apparently perfectly legal MIPS — the ISA has no notion of a "function". It is simply
not the output of a C compiler, and in a decompilation it stays as hand-written
`.s`.
