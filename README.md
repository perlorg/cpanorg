# CPAN.org content repository

This repository is for maintaining the non-source-code, non-archive
content on cpan.org.  Discussion related to this should be on the
[cpan-workers mailing list][cpan-workers].

[cpan-workers]: http://lists.perl.org/list/cpan-workers.html

## Rules for editing content:

* Don't add new files. Only files already on cpan.org should be added
(and then to their current location).  Generally email ask@perl.org to
get new files included here.

* Be conservative in your edits.  While lots of updates are needed,
this has been around for 15 years and will be for many more. There's
no rush.

* No style edits for now. Cleanups yes; but a new design/layout will
wait.

## How to submit changes

A 'pull request' on github is the best way. Sending a patch to the
cpan-workers list at the same time will be a good way to get peer
review. A change with a few "+1" votes from the list are more likely
to be expediently pulled in.

## How it works

Install Template Toolkit (`cpanm Template`) and run `make`. This will
in turn run `ttree` and generate output files in the html/ directory.

Image files are copied plainly to the html/ directory.

Everything else is processed through template toolkit. Only .html
files get the "master template" applied automatically.

The master template is in lib/style/cpan.html -- for now this is
mostly just blank.


