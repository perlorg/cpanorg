# CPAN.org content repository

This repository is for maintaining the non-source-code, non-archive content on
[cpan.org](https://www.cpan.org).
Discussion related to this should be on the
[**cpan-workers** mailing list](https://lists.perl.org/list/cpan-workers.html).

## Rules for editing content

* Don't add new output files. Only files already on cpan.org should be added
(and then to their current location). Generally email
[ask@perl.org](mailto:ask@perl.org) to get new files included here.
Making new templates/scripts/etc to produce the output files is fine.

* Be conservative in your edits.
While lots of updates are needed, this has been around for 20 years and
will be for many more. There's no rush.

* No style edits for now.  Cleanups yes; but a new design/layout will wait.

## How to submit changes

A 'pull request' on GitHub is the best way.
Sending a patch to the [cpan-workers](mailto:cpan-workers@perl.org) list
at the same time will be a good way to get peer review. A change with a
few "+1" votes from the list is more likely to be expediently pulled in.

## How it works

Install [Template Toolkit](https://metacpan.org/dist/Template-Toolkit)
and the other requirements with `cpanm` by running `make install`.

To fetch the data needed for the site, run `make update-data update-daily`.

Then run `make`.

This will in turn run
[`ttree`](https://metacpan.org/dist/Template-Toolkit/view/bin/ttree)
and generate output files in the `html/` directory.

Image files are copied plainly to the `html/` directory.

Everything else is processed through
[Template Toolkit](https://metacpan.org/dist/Template-Toolkit).

Only `.html` files get the "master template" applied automatically.

## Configuration Variables

The build system supports the following configuration variables:

- **DEST**: Output directory for generated files (default: `html`)
- **PRIMARY**: Deployment target directory (default: `../CPAN`)

These can be overridden when running make:

```bash
make DEST=/writable/path build              # Build to custom directory
make DEST=/tmp/html PRIMARY=/deploy/target update-primary  # Custom build and deploy paths
```

This is particularly useful for Kubernetes deployments where the default `./html` directory may be read-only.

## Run under Docker

Experimental, you can build the content from those templates with:

    mkdir -p root/tmp root/CPAN
    docker run --rm -ti \
      -v `pwd`:/cpan/content -v `pwd`/root:/cpan \
      -w /cpan/content \
      quay.io/perl/cpanorg:master \
        make build update-data update-primary
