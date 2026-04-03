## 📦 Dependencies

This repository relies on the following tools:

- Python  
- splat (https://github.com/ethteck/splat)

---

## 📖 Overview

This project is currently a **proof of concept**.

The main idea is to configure `.yaml` files for splat, which define how data is extracted from the target binary. Depending on the configuration, different sections can be split, such as:

- `.rodata`  
- `.text`  
- `.data`  
- `.bss`  
- or raw assembly output  

For more detailed information, it is recommended to refer to the official documentation available in the splat repository.

---

## ⚙️ Scripts

The following files:

- `split_asm_exe.bat`  
- `split_221_asm.bat`  

are simple **workaround scripts** intended to execute the extraction process with a single click.

---

## ⚠️ Limitations

Please note that the current extraction configurations are **not fully accurate**:

- Section mapping is incomplete  
- Some data structures are not yet properly defined  

This is particularly noticeable in **overlay 221 (Crystal Challenge)**, which contains a `short` array at the beginning of its binary. These sections arent yet been implemented in the current configuration.
