---
name: calibre
description: >
  Manage Calibre ebook libraries via CLI. Search, import, convert, organize,
  and export ebooks. Use when: (1) searching or browsing an ebook library,
  (2) importing new books, (3) converting between formats (epub, mobi, pdf, azw3),
  (4) updating book metadata (title, author, tags, series, covers),
  (5) exporting books for e-readers, (6) library maintenance and cleanup,
  (7) any Calibre or ebook management task.
when: "User asks about ebooks, Calibre, importing books, converting epub/mobi/pdf, library search, book metadata, or exporting for e-readers"
examples:
  - "Search my Calibre library for books by Philip K. Dick"
  - "Import this epub into Calibre"
  - "Convert book #42 to mobi format"
  - "Add the tag sci-fi to books 1, 2, and 3"
  - "Export all unread books to my Desktop"
  - "Find books added in the last 30 days"
  - "Fix missing covers in my library"
homepage: https://github.com/jamesalmeida/calibre-skill
metadata: {"openclaw": {"emoji": "📚", "requires": {"bins": ["calibredb"]}, "primaryEnv": null}}
---

## Prerequisites
- Calibre CLI tools available as `calibredb`, `ebook-convert`, `ebook-meta`, `fetch-ebook-metadata`.
- Install (macOS Homebrew): `brew install calibre`.
- macOS app path fallback: `/Applications/calibre.app/Contents/MacOS/`.
- Library directory contains `metadata.db` and author folders (default: `~/Calibre Library`).

## Configuration
- Prefer `--library-path` on every command. This persists to `{baseDir}/TOOLS.md` as `calibre_library_path=...`.
- Fallbacks: `CALIBRE_LIBRARY_PATH`, then `~/Calibre Library`.
- Scripts pass `--with-library` to `calibredb` and do not modify originals unless explicitly updating metadata.
- Agent path resolution: resolve script paths relative to `{baseDir}/scripts/`; use absolute paths for libraries and outputs.

## Quick Reference
- Search: `scripts/calibre_search.sh --library-path /path/to/library search --field title --query "Dune"`
- Recent: `scripts/calibre_search.sh --library-path /path/to/library recent --days 30 --columns "title,authors,formats"`
- Details: `scripts/calibre_search.sh --library-path /path/to/library details --id 123`
- Import file: `scripts/calibre_import.sh --library-path /path/to/library --file /path/book.epub --with-metadata`
- Import dir: `scripts/calibre_import.sh --library-path /path/to/library --dir /path/books --duplicates`
- Convert: `scripts/calibre_convert.sh --library-path /path/to/library --input /path/book.epub --format mobi --output-dir /tmp/out`
- Convert from library: `scripts/calibre_convert.sh --library-path /path/to/library --id 123 --format epub --output-dir /tmp/out`
- Update metadata: `scripts/calibre_metadata.sh --library-path /path/to/library update --id 123 --title "New" --tags "sci-fi,classic"`
- Bulk tags: `scripts/calibre_metadata.sh --library-path /path/to/library tags-add --ids "1,2,3" --tags "to-read"`
- Export: `scripts/calibre_export.sh --library-path /path/to/library --id 123 --format epub --to-dir /tmp/export`
- Export by search: `scripts/calibre_export.sh --library-path /path/to/library --search "tags:to-read" --format epub --to-dir /tmp/export`
- Maintenance: `scripts/calibre_metadata.sh --library-path /path/to/library audit --missing-covers --missing-metadata --missing-formats`

## Search Notes
- Date syntax: `date:>30daysago` or `date:>2024-01-01` (avoid `date:>-30`).
- Full-text search: `calibredb --with-library /path list --search 'fts_search:"exact phrase"'`.

## Workflows
- Import -> metadata -> convert -> export
  - `scripts/calibre_import.sh --library-path /path/to/library --file ... --with-metadata`
  - `scripts/calibre_metadata.sh --library-path /path/to/library update --id ... --series ... --series-index 1`
  - `scripts/calibre_convert.sh --library-path /path/to/library --id ... --format epub --output-dir ...`
  - `scripts/calibre_export.sh --library-path /path/to/library --id ... --format epub --to-dir ...`

## ebook-convert Notes
- Convert: `ebook-convert input.epub output.mobi`
- Batch: iterate files and run `ebook-convert` per file.
- Output format is inferred from output filename extension.
- Metadata is preserved by default when converting from a Calibre-managed file.

## Troubleshooting
- Missing Calibre: install with Homebrew or point to `/Applications/calibre.app/Contents/MacOS/`.
- Bad library path: must be a directory with `metadata.db`.
- Search returns nothing: verify `--library-path` and search syntax.
- Conversion failed: confirm input format and that `ebook-convert` is in PATH.
