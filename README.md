# gettingandcleaningdata
## run_analysis description

Run analysis takes the UCI HAR dataset and adds the activity performed during each measurement
from the _y.txt and the subject from each subject_test.txt and creates a data frame.

Then selects only the columns that contain "mean()" or "std()" in the name and reorganizes
the table to list subject and activity first.

Using dplyr all variables are gathered into observation and values, leaving subject and activity
intact.

Rows are then grouped by subject, activity and observation and the mean is calculated
for each group of observation by subject and activity.

The values are then written into a table "output.txt"
