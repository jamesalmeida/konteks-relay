# calibredb Reference (OpenClaw)

## Purpose
Command-line access to Calibre libraries: list/search, add, export, set metadata.

## Key Concepts
- Library path must point to directory containing `metadata.db`.
- Always pass `--with-library /path/to/library` unless `CALIBRE_OVERRIDE_DATABASE_PATH` is set.

## Common Commands
- List books: `calibredb --with-library /path list --fields "title,authors,formats"`
- Search: `calibredb --with-library /path list --search "title:Dune"`
- Show details: `calibredb --with-library /path show_metadata 42`
- Add file: `calibredb --with-library /path add /books/book.epub`
- Add directory: `calibredb --with-library /path add -r /books`
- Export: `calibredb --with-library /path export --to-dir /tmp/out --formats epub 42`
- Update field: `calibredb --with-library /path set_metadata 42 --field "tags:sci-fi"`
- Set cover: `calibredb --with-library /path set_metadata 42 --field "cover:/tmp/cover.jpg"`
- Set tags: `calibredb --with-library /path set_metadata 42 --field "tags:to-read,classic"`

## Search Fields (common)
- `title`, `authors`, `tags`, `series`, `publisher`, `rating`, `date`

## Notes
- Use `--for-machine` for JSON output.
- `check_library` validates library integrity.
- Full-text search uses `fts_search:"query"` (e.g., `--search 'fts_search:"exact phrase"'`).
