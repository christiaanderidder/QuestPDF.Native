This project integrates [Skia](https://skia.org) and [QuestPDF](https://www.questpdf.com). It consists of two layers:
- Native unmanaged code - C++ wrapper for Skia that exposes and/or composes Skia APIs necessary for QuestPDF,
- Managed dotnet code - low-level wrapper using P/Invoke calls to access native code.

# musl build
Run `docker build . -t questpdf:latest` and `docker run --rm -it --platform linux/amd64 questpdf:latest`