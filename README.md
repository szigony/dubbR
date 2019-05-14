# dubbR
A package for text analysis made from Hungarian script translations by Patrik Szigeti, formatted to be convenient for text analysis.

This package was created as part of an assignment for *Data Science 4 - Unstructured Text Analysis* at CEU, Budapest.

#### Table of Contents

- [Installation](#installation)
- [Functions](#functions)
  - [dub_data](#dub_data)
  - [dub_metadata](#dub_metadata)
  - [dub_text](#dub_text)
  - [dub_characters](#dub_characters)
  - [dub_shows](#dub_shows)
  - [dub_id_by_shows](#dub_id_by_shows)
- [Examples](#examples)

## Installation
`dubbR` is not on CRAN yet, please install from GitHub:
```r
remotes::install_github('szigony/dubbR')
```

## Functions

### `dub_data`

This is a hidden function that creates the tibbles that will serve as the basis for the exported functions.

- It loops through all the files in the [source_files](source_files/) folder, and extracts the tables (with the help of the `read_docx` function from the `docxtractr` package) that contain three columns: timestamp, character and text.
- It dissects the input file names and creates the metadata tibble by utilizing the `str_extract` function with RegEx, as well as the `str_replace` function from the `stringr` package.
- It automatically assigns a `dub_id` column based on the index of the iteration to each of the scripts for ease of identification.
- Data wrangling:
  - The first table in each script only contains the characteristics of the characters, such as gender and age.
  - There are multiple tables due to the commercial breaks within a show.
  - None of the tables have headers.
  - Creating a tibble for characters:
    - Remove empty rows, keep only the **distinct** characters.
    - Add the `dub_id`.
  - Creating a tibble for the text:
    - Remove empty rows, and add the `dub_id`.
- The function returns a list of tibbles (`dub_metadata`, `dub_text` and `dub_characters`) that later serve as inputs for the other functions.

### `dub_metadata`

Metadata about the audiovisual translations. Returns a tibble with the metadata.

| Column | Description |
| --- | --- |
| `dub_id` | Unique identifier of the scripts. |
| `production_code` | The production code that was used by the production company. |
| `show` | The name of the TV show. |
| `season` | The season of the TV show for which the translation was requested. |
| `episode` | The episode of the TV show within the season for which the translation was requested. |

### `dub_text`

The text of the audiovisual translations, formatted to be convenient for text analysis. Returns a tibble with the text of the scripts.

- *Optional input parameter:* `dub_id` - a list of IDs for which the texts should be imported.

| Column | Description |
| --- | --- |
| `dub_id` | Unique identifier of the scripts. |
| `text` | The text from the scripts line by line. |

### `dub_characters`

The characters from the audiovisual translations. This can be used to create `anti_join`s so that the character names wouldn't skew the analysis. Returns a tibble with the characters from the scripts.

- *Optional input parameter:* `dub_id` - a list of IDs for which the characters should be imported.

| Column | Description |
| --- | --- |
| `dub_id` | Unique identifier of the scripts. |
| `character` | The characters that appear in the scripts. |

### `dub_shows`

A unique list of the shows that appear in the package. It can be used to explore the package and filter the contents. Returns a tibble with the unique list of shows that appear in the package.

| Column | Description |
| --- | --- |
| `show` | The unique TV shows in the package. |

### `dub_id_by_shows`

Get the list of IDs that are in scope for the selected set of shows. This would tipically be used to filter for texts or characters of a specific show. Returns a list of `dub_id`s.

- *Input parameter:* `shows` - a show or a list of shows for which we'd like to return the `dub_id`s.

## Examples

This is a typical workflow of leveraging the package's capabilities:

1. See what shows are available in the package.

```r
dub_shows()
```

2. Look at the metadata for the show(s) you're interested in.

```r
dub_metadata() %>%
  filter(show == "Fifth Gear")
```

3. Either select specific episodes and filter by `dub_id`, or select a show and use the `dub_id_by_shows` function...

   - To filter for the scripts that are stored line by line.
   
   ```r
   dub_text(dub_id_by_shows("Fifth Gear"))
   ```
   
   - Or to filter for the characters that appear in the show to later apply them as stopwords.
   
   ```r
   dub_characters(dub_id_by_shows("Fifth Gear"))
   ```
   
4. Use the `tidytext` package to perform text analysis.

```r
library(tidytext)

dub_text(dub_id_by_shows("Fifth Gear")) %>%
  unnest_tokens(word, text)
```
