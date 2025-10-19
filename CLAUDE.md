# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository maintains the content for [cpan.org](https://www.cpan.org) using Perl Template Toolkit. The build system processes templates from `src/` and generates static HTML output to a configurable working directory (default: current directory with `html/`, `data/`, and `tmp/` subdirectories).

## Build Commands

### Initial Setup
```bash
make install  # Install Template Toolkit and dependencies (Template, JSON, Template::Plugin::Comma, Template::Plugin::JSON, XML::RSS, local::lib, File::Slurp)
```

### Building the Site
```bash
make build           # Build site from templates (runs ttree)
make update-data     # Fetch RSS feeds and CPAN stats
make update-daily    # Fetch Perl release data
make update          # update-data + build
make update-primary  # update + rsync to PRIMARY directory
make clean           # Remove WORKDIR/html directory and rebuild
```

### Configuration Variables
The build system supports customizable paths:

```bash
make WORKDIR=/tmp/cpanorg build                         # Build to /tmp/cpanorg/html with data in /tmp/cpanorg/data
make WORKDIR=/work PRIMARY=/deploy update-primary       # Custom work and deploy paths (PRIMARY default: ../CPAN)
make RSYNC_TEMP_DIR=/cpan/tmp update-primary            # Specify rsync temp directory (useful for Docker)
```

This is useful for Kubernetes deployments where `./html` and `./data` may be read-only.

### Docker Workflow
```bash
mkdir -p root/tmp root/CPAN
docker run --rm -ti \
  -v `pwd`:/cpan/content -v `pwd`/root:/cpan \
  -w /cpan/content \
  quay.io/perl/cpanorg:master \
    make RSYNC_TEMP_DIR=/cpan/tmp build update-data update-primary
```

## Architecture

### Template Processing Flow

1. **Input**: Source files in `src/` directory
2. **Template System**: Uses Template Toolkit's `ttree` command (configured via `tt.rc`)
3. **Pre-processing**: `lib/tpl/defaults` is processed first for all files
4. **Wrapper**: `lib/tpl/wrapper` wraps `.html` files with style templates
5. **Output**: Generated files written to `$(WORKDIR)/html` directory (default: `./html/`)

### Key Configuration Files

- **tt.rc**: Main Template Toolkit configuration
  - Sets `src` as input directory
  - Default output directory is `html` (can be overridden with `--dest` flag)
  - Defines library paths: `lib/` and `data/`
  - Copies image files (gif, png, pdf, jpg, svg) directly
  - Ignores .tt, .svn, .swp, .DS_Store files

- **dependencies.rc**: Defines file dependencies for rebuilding
  - Example: `index.html` depends on `recent.json` and `cpan-stats.json`

- **Makefile**: Orchestrates build process

### Template System

**lib/tpl/defaults**: Pre-processed for every file
- Sets up `page` hash with title, style template
- Loads Template plugins (Comma, JSON)
- Defines `rss_feed` BLOCK for rendering JSON feed data
- Processes `tpl/data/cpan-stats` for site statistics

**lib/tpl/wrapper**: Applied to all `.html` files
- Wraps content with style template from `lib/style/`
- Default style is `cpan.html` unless `page.style` is set
- Non-.html files skip wrapper and output raw content

**lib/style/cpan.html**: Master page layout template

### Data Files

Data files in `$(WORKDIR)/data` (default: `./data/`) are fetched by scripts in `bin/`:

- **bin/cpanorg_rss_fetch**: Fetches MetaCPAN recent releases RSS, outputs `$(DATA)/recent.json`
- **bin/update_data**: Fetches CPAN statistics from cpan.org, outputs `$(DATA)/cpan-stats.json`
- **bin/cpanorg_perl_releases**: Fetches Perl version data, outputs:
  - `$(DATA)/perl_versions_earliest.json`
  - `$(DATA)/perl_versions_latest.json`
  - `$(DATA)/perl_version_latest_stable.json`

These JSON files are consumed by templates via Template Toolkit's `INSERT` and JSON plugin.
Scripts use the `DATA` environment variable to determine output location.

### Source File Structure

Source files in `src/` use Template Toolkit syntax:
- Begin with metadata block setting `page.title`, `page.style`, etc.
- Use `[% ... %]` for Template Toolkit directives
- Can access variables like `cpan_stats.modules.count`
- Use PROCESS to include blocks like `rss_feed`

## Content Editing Rules

From README.md:

- **Don't add new output files** without approval (email ask@perl.org)
- **Be conservative** in edits - this site has 20 years of history
- **No style edits** for now - cleanups yes, but new design/layout will wait
- Submit changes via GitHub pull requests
- Get peer review on cpan-workers mailing list for expedient merging
