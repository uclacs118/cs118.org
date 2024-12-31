# cs118.org

A website containing all class materials for CS 118.

= Syllabus
- Schedule
    - Weekly class material incl. discussions/activites
- Projects
- Homeworks
- Quick Links (incl. a URL shortener)

Created with Astro.

# Usage
```bash
$ npm run build # build code to ./dist directory
$ npm run dev -- --host # create development server at port 4321
```

# Content Management
All user generated content should be modified in the `.mdx` files + `public` 
and `src/assets` folders.

## Syllabus
The syllabus is located in `src/pages/index.mdx`.

## Schedule
Each day in the schedule is organized by week. For example, to access the days
in week 2, see the directory `src/pages/schedule/week2/`. For finals week, it's
in `src/pages/schedule/finals`. The date is determined by the filename, in
`YYYY-MM-DD.mdx` format. Even if the date is not actually within this week, 
it will still show up under this week. 

Do take notice of a special `ul` class `links`.

Use the file `bootstrap.js` to automatically create these files. Note that 
this action is destructive-do not run it if you already have data.

Please note that changing the due dates/other metadata
for items in homework and projects don't modify this page. Future iterations
may do this automatically.

## Homeworks/Projects
Each are in their respective folder under `src/pages`. To create an assignment,
create some file `assignment[number].mdx`.
For example, to create Project 2, create the file 
`src/pages/projects/project2.mdx`. 

All assignments must have the due date and title in the frontmatter. See 
`src/pages/projects/project0.mdx` for an example. 

To create a draft assignment that doesn't show up, prepend the filename with 
`draft_`. This will still be accessible in the
live site from its url, so don't commit any drafts to the main branch.

## URL Shortening
In `src/pages/[auto].astro`, create a URL mapping by modifying the `links` 
variable in the frontmatter.


