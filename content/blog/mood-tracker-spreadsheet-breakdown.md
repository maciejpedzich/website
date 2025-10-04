+++
title = "Mood Tracker Spreadsheet Breakdown"
date = 2025-10-04
description = "Analysing a spreadsheet I made to analyse my mood."

[taxonomies]
tags = ["Technical", "Google Sheets"]
+++

## Background and live demo

If you've read [my previous post](/blog/hello-again-world), then you probably remember me mentioning a Google Sheets spreadsheet I created back in July to keep track of my mood changes before my control visit in August.

Since I've really enjoyed this little experiment so far (with both my psychiatrist and my therapist encouraging me to continue it), I thought I'd share the inner workings of the latest edition of the spreadsheet ahead of the first monthly mood report post coming towards the end of this month.

In case you just want to copy the spreadsheet to track your own mood or look under the hood yourself, I've prepared a [live demo with random data](https://docs.google.com/spreadsheets/d/1lxI0PVTUZBtG8UaloNwUohoybKL0SAKA8mEEseSIfpk/edit?usp=sharing) you can copy to your account and play around with to your heart's content.

## Data structure

Because I'm supposed to schedule my next control visit for January next year and I'm too lazy to create separate spreadsheets for each month, I've opted to split these 4 or so months into 4 seasons of 4 weeks each. Every single day is given a rating on an integer-only scale from 1 to 5, where the greater the number, the better my overall mood that day.

### Columns and named ranges

Therefore I've labelled 4 columns: **Season (A)**, **Week (within a season; B)**, **Date (C)**, and **Rating (D)**. The first row is reserved for column headers, so the actual tracker entries start at row 2. They go all the way to row 113, as I'm looking at 16 weeks, so 112 days plus 2 (the first row number) minus 1 (this range includes the first row).

Speaking of ranges, I've created named ranges called the same as the respectively named columns, as well as a named range for all the raw data named _Entries_, so as to make filter operations more readable. We'll see that in action shortly.

Anyway, I've got the columns set up, but what about the rows? Filling in the last two columns is straightforward: I enter the first date and drag the cell down to the final entry, whereas the ratings... well, I assign them on a day-by-day basis. As for the other two columns, I've made use of clever formulas to automate the process of splitting the entries in the manner I described earlier.

### Splitting rows into seasons and weeks

I'll break down the **Season** column first. Since every row corresponds to a single day and every season is 28 days long, I take the zero-based row index (i.e. subtract 2 from `ROW()`), divide it by the number of days in a season, discard the decimal places from the division result (or in other words, `FLOOR()` it), and add 1 to adjust the resulting season index to one-based numbering. The formula looks like this:

```scala
=FLOOR((ROW()-2)/28)+1
```

{{ admonition(type="note", title="WHAT'S UP WITH SCALA?" text="Code snippets use Scala syntax highlighting, because Zola doesn't provide a dedicated language option for Excel formulas, and Scala just so happens to work well enough as a substitute.") }}

Now it's time for the **Week** column. I determine the absolute week number using an analogous approach, but this time dividing the zero-based row index by 7. However, I want to have the week number go back to 1 after I go from the last day of one season to the first day of the following season.

In order to have the week cycle from 1 to 4, I take the remainder from division of the week number by 4 and add one to that instead of the week index. This results in the following following formula:

```scala
=MOD(FLOOR((ROW()-2)/7),4)+1
```

Alright, so let's have a look at an excerpt from the live demo, filtered to show only the first row for every week of every season. We should see the aforementioned cycle as every date jumps by 7 days, with each reset causing the season to go up by 1.

| Season | Week | Date       |
| ------ | ---- | ---------- |
| 1      | 1    | 23.09.2025 |
| 1      | 2    | 30.09.2025 |
| 1      | 3    | 07.10.2025 |
| 1      | 4    | 14.10.2025 |
| 2      | 1    | 21.10.2025 |
| 2      | 2    | 28.10.2025 |
| 2      | 3    | 04.11.2025 |
| 2      | 4    | 11.11.2025 |
| 3      | 1    | 18.11.2025 |
| 3      | 2    | 25.11.2025 |
| 3      | 3    | 02.12.2025 |
| 3      | 4    | 09.12.2025 |
| 4      | 1    | 16.12.2025 |
| 4      | 2    | 23.12.2025 |
| 4      | 3    | 30.12.2025 |
| 4      | 4    | 06.01.2026 |

Looks good to me! Let's move on.

## Weekday rating averages

As the header suggests, this next sheet aims to showcase the average rating for every day of the week throughout the whole season. The table consists of two columns: **Weekday (C)**, and **Average (D)**. Like in the _main_ data table, the first row is reserved for column header.

For **Weekday**, I had to adapt to the default numbering of weekdays used by Google Sheets and the [`WEEKDAY` function](https://support.google.com/docs/answer/3092985?hl=en), where 1 means Sunday, 2 means Monday, and so on until you reach Saturday at number 7. I've also applied custom date formatting to that column to display the corresponding weekday's short name.

Here's how the **Average** column gets filled out. For each row, I filter through all the _Entries_ by selecting only the ones with dates that fall on the weekday of the current row, extracting the 4th column from the results (it's the **Ratings** column) and finally calculating the average.

All it takes is writing the following formula for the first weekday row (the second row overall) and dragging it all the way to the final weekday:

```scala
=AVERAGE(
  CHOOSECOLS(
    FILTER(Entries, WEEKDAY(Date)=C2),
    4
  )
)
```

Now, I know that the [`QUERY` function](https://support.google.com/docs/answer/3093343?hl=en) is a thing, but I thought I'd spice things up by deliberately refraining from using it. Anyway, here we have the resulting table:

| Weekday | Average |
| ------- | ------- |
| Mon     | 2.50    |
| Tue     | 3.13    |
| Wed     | 3.13    |
| Thu     | 2.25    |
| Fri     | 2.94    |
| Sat     | 3.44    |
| Sun     | 3.06    |

## Rating counts

Next up is a sheet for listing each rating's count in every week of a certain season and overall. It consists of a dropdown menu for season selection, as well as a table for presenting the counts on a week-by-week and overall basis.

The dropdown menu is located at cell `B1` and allows you to choose a unique value from the `=Season` range. There's no need to explicitly place it inside the [`UNIQUE` function](https://support.google.com/docs/answer/10522653?hl=en), Google Sheets will automatically remove all the duplicates for you.

### Named functions bonanza

Now, the real fun begins with the aforementioned table. It has 5 columns and 5 rows, where every column header represents a specific rating, and every row header represents a period within selected season (the first four label their respective weeks, the last one labels the whole season). Each cell contains the number of occurrences of a certain rating in a certain period.

Here's the kicker: this whole table (including the headers) is generated using formulas. The column headers are nothing else but a simple [`=SEQUENCE(1,5)`](https://support.google.com/docs/answer/9368244?hl=en), which outputs 1 row and 5 columns (provided parameters) of subsequent integers from 1 onwards (by default). Easy as it can be, but what about the rest of the table?

I've managed to generate it using a single expression... sort of. In case you haven't just figured it out, I've created a bunch of [named functions](https://support.google.com/docs/answer/12504534?hl=en) to move some potentially reusable pieces to their own formulas, but also to improve general readability of the main formula. I'll explain them first, and then I'll put them all together to create _the big one_.

#### `ROW_HEADER(week)`

This function accepts an integer in range `[1; 5]` and returns appropriate text, which is meant to serve as the header for a row representing a specific week or the overall period. Here's the definition:

```scala
=IF(week=5, "Overall", JOIN(" ", "Week", week))
```

That's incredibly reusable, but also incredibly boring. Let's examine something more... bizarre.

#### `RATINGS_FOR_PERIOD(entries, season, week)`

This function accepts:

1. A table just like the one under the `Entries` named range.
2. An integer in range `[1; 4]`.
3. An integer in range `[1; 5]`.

It returns an array of ratings registered in a given `week` of a given `season`, or all the ratings throughout specified `season` if `week` is set to 5. Here's the definition:

```scala
=CHOOSECOLS(
  FILTER(
    entries,
    (CHOOSECOLS(entries,1)=season)*((week=5)+(CHOOSECOLS(entries,2)=week))
  ),
  4
)
```

You might be wondering what the [`*` (multiply)](https://support.google.com/docs/answer/3093978?hl=en) and [`+` (add)](https://support.google.com/docs/answer/3093590?hl=en) operators do here and how they're supposed to work in this big filter condition. Although this doesn't seem to be documented in the reference pages I linked to, apparently you can use the respective operators as substitutes of [logical `AND`](https://support.google.com/docs/answer/3093301?hl=en) and [logical `OR`](https://support.google.com/docs/answer/3093306?hl=en).

The reason why I've had to replace these functions with operators, is that for whatever reason, the left-hand side of the `AND` would get evaluated early, altering the `entries`' dimensions while the right-hand side was still expecting the initial dimensions, causing a value error in the process.

Making sense of this whole function should be much easier now. It essentially selects the **Ratings** column from all the `entries` registered in:

- Provided `season` overall if the `week` parameter is set to 5.
- Provided `week` of that `season` otherwise.

#### `LIST_COUNTS(week, ratings)`

This function accepts:

1. An integer in range `[1; 5]`.
2. An array of integers in range `[1; 5]`.

It returns a row containing a text header, along with the number of occurrences of each rating in the provided `ratings` array. Here's the definition:

```scala
={
  ROW_HEADER(week),
  MAP(
    SEQUENCE(1, 5),
    LAMBDA(r, COUNTIF(ratings, r))
  )
}
```

One very cool thing to note, is that you don't have to manually [`FLATTEN`](https://support.google.com/docs/answer/10307761?hl=en) the mapped sequence, because the comma (or backslash depending on your regional settings) is responsible for joining two rows together into one continuous row. If you'd like to join two columns, use a semicolon instead.

### The Big One

Ok, it's time to piece together the formula to generate the rest of the table. I started off with a column sequence (ie. `=SEQUENCE(5,1)`), with each row item acting as a `week` number.

I could then apply a `MAP` to generate a row via the `LIST_COUNTS` named function, passing the aforementioned week number, along with an array of ratings obtained by calling `RATINGS_FOR_PERIOD` with the `Entries` named range, the selected season at cell `B1`, and the same `week` number.

Translating this description to a formula using the named functions above looks like this:

```scala
=MAP(
  SEQUENCE(5, 1),
  LAMBDA(
    week,
    LIST_COUNTS(
      week,
      RATINGS_FOR_PERIOD(Entries, B1, week)
    )
  )
)
```

It produces the table below (for season 1 in the live demo):

{% wide_container() %}

| Period  | 1   | 2   | 3   | 4   | 5   |
| ------- | --- | --- | --- | --- | --- |
| Week 1  | 1   | 4   | 2   | 0   | 0   |
| Week 2  | 2   | 1   | 2   | 2   | 0   |
| Week 3  | 1   | 0   | 1   | 2   | 3   |
| Week 4  | 2   | 1   | 0   | 3   | 1   |
| Overall | 6   | 6   | 5   | 7   | 4   |

{% end %}

Just to drive home the fact that this formula is indeed _the big one_, here's an inlined variant (ie. one where all the named function calls have been replaced by their bodies):

```scala
=MAP(
  SEQUENCE(5, 1),
  LAMBDA(
    w,
    {
      IF(w=5, "Overall", JOIN(" ", "Week", w)),
      MAP(
        SEQUENCE(1, 5),
        LAMBDA(
          r,
          COUNTIF(
            CHOOSECOLS(
              FILTER(
                Entries,
                (Season=B1)*((w=5)+(Week=w))
              ),
              4
            ),
            r
          )
        )
      )
    }
  )
)
```

Imagine trying to debug this monster without all the formatting. Yeah, no thanks!

## Rating distributions

This sheet is actually very similar to the previous one, both when it comes to the underlying formulas and the resulting table. The latter has the same row labels, only this time the columns provide a [five-number summary](https://en.wikipedia.org/wiki/Five-number_summary) of ratings for a given period in the selected season. I've labelled the columns manually as follows:

1. Min
2. Q1 (first quartile)
3. Median
4. Q3 (third quartile)
5. Max
6. IQR (interquartile range)

As for the rest of the table, the main formula really does look familiar:

```scala
=MAP(
  SEQUENCE(5, 1),
  LAMBDA(
    week,
    LIST_QUARTILES(
      week,
      RATINGS_FOR_PERIOD(Entries, B1, week)
    )
  )
)
```

I've only had to replace the `LIST_COUNTS` call with a call to `LIST_QUARTILES`, which goes to show how powerful named functions can prove when designing complex formulas. Let's take a look at this new function:

```scala
={
  ROW_HEADER(week),
  MAP(
    SEQUENCE(1, 5, 0),
    LAMBDA(q, QUARTILE(ratings, q))
  )
}
```

Simple and elegant, especially when you take advantage of the fact that passing 0, 2, and 4 as the second argument of the [`QUARTILE` function](https://support.google.com/docs/answer/3094041?hl=en) will have it return the minimum, median, and maximum value in the dataset respectively.

But where's the IQR column? Although I could've incorporated it into the formula, I've chosen to add a separate column that's effectively `Q3-Q1`, and voila:

{% wide_container() %}

| Period  | Min | Q1  | Median | Q3  | Max | IQR |
| ------- | --- | --- | ------ | --- | --- | --- |
| Week 1  | 1   | 2   | 2      | 2.5 | 3   | 0.5 |
| Week 2  | 1   | 1.5 | 3      | 3.5 | 4   | 2   |
| Week 3  | 1   | 3.5 | 4      | 5   | 5   | 1.5 |
| Week 4  | 1   | 1.5 | 4      | 4   | 5   | 2.5 |
| Overall | 1   | 2   | 3      | 4   | 5   | 2   |

{% end %}

## Season summary

At this point, I'm pretty sure you know the drill. I've wanted to create a table that would list some key measures for each week in the season and overall. We're talking the minimum, maximum, average, median, mode, and standard deviation.

The `SUMMARISE(week, ratings)` named function I've written to list those stats isn't quite as elegant as `LIST_QUARTILES`, but it's far from terrible:

```scala
={
  ROW_HEADER(week),
  MIN(ratings),
  MAX(ratings),
  AVERAGE(ratings),
  MEDIAN(ratings),
  JOIN("; ", MODE.MULT(ratings)),
  STDEVP(ratings)
}
```

The only thing worth noting about this function, is that I reckon it's more reasonable to treat provided ratings as the entire population rather than a sample when dealing with weeks, hence the [`STDEVP`](https://support.google.com/docs/answer/3094105?hl=en) instead of [`STDEV`](https://support.google.com/docs/answer/3094054?hl=en), or using the former only for the overall period and the latter for weeks.

With that out of the way, this is the autogenerated table for season 1 in the live demo:

{% wide_container() %}

| Period  | Min | Max | Average | Median | Mode    | Std. dev. |
| ------- | --- | --- | ------- | ------ | ------- | --------- |
| Week 1  | 1   | 3   | 2.14    | 2      | 2       | 0.64      |
| Week 2  | 1   | 4   | 2.57    | 3      | 1; 3; 4 | 1.18      |
| Week 3  | 1   | 5   | 3.86    | 4      | 5       | 1.36      |
| Week 4  | 1   | 5   | 3.00    | 4      | 4       | 1.51      |
| Overall | 1   | 5   | 2.89    | 3      | 4       | 1.37      |

{% end %}

## It's a wrap

Thank you for reading this article all the way through. Although the new academic year is underway, I can't wait to do more data science experiments in my spare time and write them up in a similar fashion... provided I find enough energy, haha.

Take care, and I hope to see you in the next post!
