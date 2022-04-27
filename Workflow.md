# Workflow

Under construction.

## Install and configure an Java IDE

Use your preferred IDE configured to receive UTF-8 as input and automatically
convert to ISO-8859-1 with Java entities: that you save you from a lot of
headaches, leaving you to worry about normally editing the files.

Instructions to setup that will vary depending on the IDE, but here are some
references:

- [IntelliJ IDEA](https://www.jetbrains.com/help/idea/encoding.html#file-encoding-settings)

The IDEA has a good chance to include a spell checking tool, which is a great
addition to the process.

## Run jtt for an overview

Executed with only the `--lang` option, `jtt` will only check all available
translation files and compare those in English with those available (or not) in
the selected language.

This will give you an overview what needs to be done.

My suggestion is to always started with the removal of deprecated keys with the
`--remove` option, so you start cleaning up instead of having to mess with
unnecessary keys text.

## Use Git

Check with Git (`git status`) what changes are being proposed and follow up
from there.

Once a translated file is done, add it with `git add`. I strongly suggest to
work in each file individually so you can get a better control of progress.

### New files

For new files, you will need to open them in the IDE and start the translation.

### Deprecated keys

Review each file that had keys removed, comparing them with the original. It is
possible that you will find lines that were removed because `jtt` identified
them as a empty key (they probably were left overs, without being a well formed
property).

### Removed file

Nothing really to be done in this case, except accept the change with `git add`.
