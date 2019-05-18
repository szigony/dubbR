# dubbR
A package for text analysis made from Hungarian script translations by Patrik Szigeti, formatted to be convenient for text analysis.

This package was created as part of an assignment for *Data Science 4 - Unstructured Text Analysis* at CEU, Budapest.

#### Table of Contents

- [Available shows](#available-shows)
- [Installation](#installation)
- [Functions](#functions)
  - [dub_data](#dub_data)
  - [dub_metadata](#dub_metadata)
  - [dub_text](#dub_text)
  - [dub_characters](#dub_characters)
  - [dub_shows](#dub_shows)
  - [dub_id_by_shows](#dub_id_by_shows)
- [Example](#example)
- [Known issues](#known-issues)

## Available shows

Descriptions from IMDb. These shows all aired on the Discovery Channel in Hungary.

- **Backroad Bounty** - With keen eyes for detail and a knack for finding hidden gems, Marty Gebel and Peter "Bam-Bam" Bamford team up to travel the back roads of rural Canada in hopes of bringing vintage and unique treasures to the spotlight.
- **Ed Stafford Into the Unknown** - Ed Stafford is on a mission to investigate some of the planet's mysteries. Using photographs of Earth, taken by satellites, showing strange markings in some of the most remote places on the planet, he sets out to find the targets, and solve the riddles.
- **Fifth Gear** - A motor magazine with the recent driving news, expert opinions, and practical & reliable advices.
- **Finding Bigfoot** - Matt Moneymaker, founder of the Bigfoot Field Researchers Organisation (B.F.R.O.), and a team of the B.F.R.O.'s top investigators travel North America and the world to search for the mysterious creature called Bigfoot.
- **Fire in the Hole** - Explosives expert Matt Barnett, founder and president of Texplo Explosives, is the man to call when you need something blown up.
- **Incredible Engineering Blunders Fixed** - From sinking skyscrapers to demolition disasters, the world’s most bizarre engineering blunders are baffling examples of how man-made structures can go wrong. From the hilarious to the unbelievable, there are many ways to create unnecessary problems.
- **Misfit Garage** - As things went in the workshop at Gas Monkey there was conflict and disagreements... Some which got certain guys either fired or forced them to take the road. But no, they aint giving up just yet. The fired up their own garage in the hopes of becoming a worthy rival for Gas Monkey.

## Installation
`dubbR` is not on CRAN yet, please install from GitHub:
```r
remotes::install_github('szigony/dubbR')
```

## Functions

### `dub_data`

This function creates the tibbles that will serve as the basis for the exported functions. It is stored in the [data_raw](data-raw/) folder so that it can be run whenever necessary, but so that it also wouldn't loop through all the files when using `library(dubbR)`. Its contents are stored in the [R](R/) folder, in the `sysdata.rda` file.

- It loops through all the files in the [source_files](source_files/) folder, and extracts the tables (with the help of the `read_docx` function from the `docxtractr` package) that contain three columns: timestamp, character and text.
- It dissects the input file names and creates the metadata tibble by utilizing the `str_extract` function with RegEx, as well as the `str_replace` function from the `stringr` package.
- It automatically assigns a `dub_id` column based on the index of the iteration to each of the scripts for ease of identification.
- Data wrangling:
  - The first table in each script only contains the characteristics of the characters, such as gender and age.
  - There are multiple tables due to the commercial breaks within a show.
  - None of the tables have headers.
  - Creating a tibble for characters:
    - Remove empty rows, keep only the **distinct** characters.
    - Unnamed characters appear in the scripts as "Férfi X" or "Nő Y" (man or woman), these are removed, as none of them are addressed this way in the shows.
    - Add the `dub_id`.
  - Creating a tibble for the text:
    - Remove empty rows, and add the `dub_id`.
- The function creates three tibbles (`dubbr_metadata`, `dubbr_text` and `dubbr_characters`) that later serve as inputs for the other functions.

### `dub_metadata`

Metadata about the audiovisual translations. Returns a tibble with the metadata. Follows the structure of `dubbr_metadata` that is created by `dub_data`.

*Optional input parameter:* `shows` - the show or shows that are of interest.

| Column | Description |
| --- | --- |
| `dub_id` | Unique identifier of the scripts. |
| `production_code` | The production code that was used by the production company. |
| `show` | The name of the TV show. |
| `season` | The season of the TV show for which the translation was requested. |
| `episode` | The episode of the TV show within the season for which the translation was requested. |

### `dub_text`

The text of the audiovisual translations, formatted to be convenient for text analysis. Returns a tibble with the text of the scripts. Follows the structure of `dubbr_text` that is created by `dub_data`.

*Optional input parameter:* `shows` - the show or shows that are of interest.

| Column | Description |
| --- | --- |
| `dub_id` | Unique identifier of the scripts. |
| `text` | The text from the scripts line by line. |

### `dub_characters`

The characters from the audiovisual translations. This can be used to create `anti_join`s so that the character names wouldn't skew the analysis. Returns a tibble with the characters from the scripts. Follows the structure of `dubbr_characters` that is created by `dub_data`.

*Optional input parameter:* `shows` - the show or shows that are of interest.

| Column | Description |
| --- | --- |
| `dub_id` | Unique identifier of the scripts. |
| `character` | The characters that appear in the scripts. |

### `dub_shows`

A unique list of the shows that appear in the package. It can be used to explore the package and filter the contents. Returns a tibble with the unique list of shows that appear in the package.

| Column | Description |
| --- | --- |
| `show` | The unique TV shows in the package. |

## Example

This is a typical workflow of leveraging the package's capabilities:

1. See what shows are available in the package.

```r
dub_shows()
```

2. Look at the metadata for the show(s) you're interested in.

```r
dub_metadata("Fifth Gear")
```

- This returns 18 rows for the 18 scripts of **Fifth Gear** that are available in the package.

3. Select a show and...

   - ...filter for the scripts that are stored line by line.
   
   ```r
   dub_text("Fifth Gear")
   ```
   
   - ...or filter for the characters that appear in the show to later apply them as stopwords.
   
   ```r
   dub_characters("Fifth Gear")
   ```
   
4. Use the `tidytext` package to perform text analysis.

```r
library(dplyr)
library(tidytext)
library(dubbR)

fg_scripts <- dub_text("Fifth Gear") %>%
  unnest_tokens(word, text)
  
fg_characters <- dub_characters("Fifth Gear") %>%
  rename(word = character) %>%
  select(word) %>%
  mutate(word = tolower(word)) %>%
  distinct()
  
fg_scripts %>%
  anti_join(fg_characters) %>%
  anti_join(get_stopwords("hu"))
```

## Known issues

- `NOTE: header=FALSE but table has a marked header row in the Word document`
  
  In some cases, the first column of the tables with the text are detected by `read_docx` function as likely headers.
  
  **Solution:** These scripts were removed from the package for now.
  
- ```r
  Warning messages:
  1: In bind_rows_(x, .id) : Unequal factor levels: coercing to character
  2: In bind_rows_(x, .id) :
    binding character and factor vector, coercing into character vector
  ```
  
  **Solution:** Pending.
