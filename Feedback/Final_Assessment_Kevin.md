
# Final CMEE Bootcamp Assessment: Kevin Zhao

- README included at the root level, providing a brief overview of the project. You also had weekly Readme files which went into more details relevant to each week. You could have included versions of languages and dependencies/packages used. Also check out [this resource](https://github.com/jehna/readme-best-practices).
- You had an .gitignore, good! You could have done with more exclusions specific to certain weeks (remember that you can include/exclude subdirectories/files/patterns). You may [find this useful](https://www.gitignore.io).

## Week 1
- Results directory contained unnecessary files like `.csv`, which should have been excluded.
- Bash scripts (`variables.sh`) demonstrated foundational skills but needed better error handling.

## Week 2

- While README documented dependencies, script-specific instructions were minimal.
- Some scripts (e.g., `align_seqs.py`) needed clearer descriptions of input and output.
 - You formatted the output of certain scripts to well-- for example `lc1.py`.

## Week 3

- Results folder was properly managed with placeholders.
- README could have included detailed examples of script outputs for easier interpretation.
- Some R scripts like `TreeHeight.R` lacked robust error handling for missing data files.
- Some scripts lacked inline comments (e.g., `Girko.R`).

## Week 4

  - README highlighted key aspects of the Florida practical and provided detailed instructions.
- `Florida.R` effectively implemented permutation testing, with clear results and appropriate visualizations. Nested loop was unnecessary - compare with solution.
- LaTeX Report was very concise - could have expanded discussion on warming trends in Florida and their broader implications, and explained the basis for the permutation based statistical test. Figure wwas formatted well, but a brief caption would have helped.

- The Autocorrelation practical code was efficient, providing a correct answer to the question. The statistical and biological/ecological interpretations in the report could have been stronger; had a somewhat weak conclusion at the end.
- Your Groupwork practicals were all in order, and your group did well in collaborating on it based on the commit/merge/pull history. Check the groupwork feedback pushed to your group repo for more details.   


---

## Git Practices

- Commits were consistent, showing meaningful improvements in README and scripts.
- `.gitignore` was updated over time - good.
- Repository size grew to 1.96 MiB by Week 4 but remained well-managed without unnecessary binary files.
- Use feature branches for experimental code to improve version control.
- Add more descriptive commit messages for significant changes.

---

## Overall Assessment

Overall, a good job!

You demonstrated improvement across all aspects of the coursework. I was impressed by your efforts to understand as many details of the programming languages and coding as possible.

Some of your scripts retained fatal errors which could nave been easily fixed - work on being more vigilant and persistent in chasing down errors the future.

Commenting could be improved -- you are currently erring on the side of overly verbose comments at times (including in your readmes), which is nonetheless better than not commenting at all, or too little! This will improve with experience, as you will begin to get a feel of what is ``common-knowledge'' among programmers, and what stylistic idioms are your own and require explanation. In general though, comments should be written to help explain a coding or syntactical decision to a user (or to your future self re-reading the code!) rather than to describe the meaning of a symbol, argument or function (that should be in the function docstring in Python for example).

It was a tough set of weeks, but I hope they have given you a good start towards further training, a quantitative masters dissertation, and ultimately a career in quantitative biology! 


### (Provisional) Mark
 *74*