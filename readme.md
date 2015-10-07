# Readme

A word-counting captcha demo.

## Assumptions

Challenge texts are case-sensitive, therefore
`Hodor` and `hodor` are considered two different words.

Random words are to be excluded from the count, but a
challenge text may only have one unique word in
which case the exclusion list should be empty.

## Design Decisions

The `Reader` class is responsible for reading a
challenge text and converting it into a payload
for the server.

The `Challenge` class is responsible only for knowing
about the text files and converting them to strings
that can be parsed by a Reader.

This seperation of data retrieval from data parsing
makes it easier to change the persistence layer in
the future: you could, for example, use a database in
the future, and only the `Challenge` class needs to
be adjusted, all other classes that deal with
challenges don't need to know that the persistence
layer changed.

As a minimal version of "cheat resistance," the
challenge verification does not use text passed in
by the client, but instead looks up the challenge
text using the challenge ID, and then compares the
results.

## Running

1. Bundle the gems

`bundle install`

2. Run the server

`bundle exec rackup -p 8000`

3. Run the tests

`bundle exec guard`

Alternatively, the `./run` script will
bundle and rackup for you.
