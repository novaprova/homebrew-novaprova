Updating
----

Introduction
====

This document describes how to update the NovaProva Homebrew package for
a new release of NovaProva.  The intended audience is the engineer making
a NovaProva release.

At time of writing, this is not an operation that has ever been
performed.  Only time will tell if this procedure works.

Steps
====

You need to know the following details first.

- The git tag for the new release.  For the sake of explanation let's pretend it's "1.9".

    VERSION=1.9

- The SHA-256 checksum of the github tarball.  Calculate it this way:

    curl -L https://github.com/novaprova/novaprova/archive/$VERSION.tar.gz -o - | shasum -a 256


Edit `Formula/novaprova.rb`.

- comment out the `bottle` section
- update the version number at the end of the URL argument for the `url` keyword.

Commit and push `Formula/novaprova.rb`.  A few seconds later, a new Github Actions
job will appear [under here](https://github.com/novaprova/homebrew-novaprova/actions)
About 10-15 min after that, the job should complete successfully.

Look at the end of the job log.  If all went well you should see some
lines like this

    ==> novaprova/novaprova/novaprova
      bottle do
        root_url "https://dl.bintray.com/novaprova/bottles-novaprova"
        sha256 "c0d73cfc93ae227e742cba979e41211d315a0ec0c341c0517ce43e133bd91ba2" => :catalina
      end
    ...
    {"message":"success"}

Copy and stash the text between `bottle do` and `end`.   You'll need that soon.

Visit [the Bintray page for the novaprova package](https://bintray.com/novaprova/bottles-novaprova/novaprova)
You should see a notice box with text like this

> Notice: You have 1 unpublished item(s) for this repo (expiring in 6 days and 22 hours) Discard | Publish

Hit the *Publish* link.  You should see a new version in the *Versions* table, containing
a single file with a name something like `novaprova-1.5rc2.catalina.bottle.tar.gz`
Check that the file can be downloaded and contains:

- the library `libnovaprova.a`
- the header file `np/np.h`
- man pages
- the configuration file `lib/pkgconfig/novaprova.pc`

Edit `Formula/novaprova.rb` again.  Uncomment the `bottle` section and replace it with the text
from the Github Action log you stashed earlier.  Commit and push.

Regrettably this will cause another bottle to be built and uploaded to Bintray.  Go back to the
Bintray page and *Discard* it this new bottle.

And you're done!

Yes, that was horribly complicated.  Welcome to Homebrew.

Greg Banks
2020/06/27

