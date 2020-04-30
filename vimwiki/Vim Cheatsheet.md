# Vim Cheatsheet

## Global Search and Replace

Make sure Vim's current working directory is set as the project root. Then run `:grep` to populate
the quickfix list with the files matching the target pattern. For instance, to search for all
occurrences of the word "Sam" in your project:

```
:grep! "Sam"
```

The `!` flag tells Vim not to jump to the first match. You can see the matched files by running
`:copen`. To run a substitution against the matched files, use the `:cfdo` command. For instance, to
replace all occurrences of the word "Sam" with the word "Bob", you'd run:

```
:cfdo %s/Sam/Bob/gc
```

You can then save all the files by running:

```
:cfdo update
```
