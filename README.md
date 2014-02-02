Reverb Code Sample
==================

Developed using Ruby 2.0. No promises otherwise.

`bundle install` for the usual effect.

The command-line version is `./reverb`.
Run `./reverb --help` to see the options.
The usual usage is `./reverb -o [1..3] <files>` where `-o` corresponds to the three sorts in the spec.

The web version is a standard rack app, so just run `unicorn` to get started.
It requires a redis server running on localhost:6379 (the default).
