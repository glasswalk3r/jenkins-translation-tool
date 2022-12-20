# Classes diagram

These are the classes in use by `jtt`.

Before jumping into it, please consider that:

- Perl doesn't have the concept of private methods, but `-` is there just to visualize that.
- `ConfigProperties` stands for `Config::Properties`, which is available at CPAN.

```mermaid
classDiagram
class Stats {
  -files
  -missing
  -unused
  -empty
  -same
  -no_jenkins
  -keys
  +new()
  +get_keys()
  +get_files()
  +get_missing()
  +get_unused()
  +get_empty()
  +get_same()
  +get_no_jenkins()
  +inc_files()
  +inc_missing()
  +inc_unused()
  +inc_empty()
  +inc_same()
  +inc_no_jenkins()
  +add_key()
  +get_unique_keys()
  +perc_done()
  +summary()
  -_done()
}
class FindResults {
  -files
  -warnings
  +new()
  +add_file()
  +add_warning()
  -_generic_iterator()
  +files()
  +warnings()
  +size()
}
class Warnings {
  -empty
  -unused
  -same
  -non_jenkins
  -search_found
  -ignored
  +new()
  +add()
  +has_unused()
  +reset()
  +summary()
  -_relative_path()
  +has_missing()
  +has_found()
}
class Properties {
  +save()
  +unescape()
  +process_line()
  -_save()
}

class ConfigProperties
ConfigProperties <|-- JenkinsI18nProperties
```
