# QCVA-02-05-2025
Welcome to QCVA-02-05-2025! (It stands for " Quick CowVisit Analysis", done February 5th, 2025). You are free to use it! As long as you give me the proper credits! Please note, however, it is part of a research conducted by a colleague. The raw data used in this analysis was provided by him.

# Credits ----------------------------------------------------------------------

QCVA-02-05-2025 was written in February of 2025, by José Eduardo Nieto Domínguez (https://orcid.org/0009-0003-9136-1839).
The raw data used for it was provided by Dr. Efrén Ramírez Bribiesca, as part of his experiment. It comes from GreenFeed machines ID 130 and 147 (hence the name of the files).

If you require any assistance in running it, or have any questions, please email me at: "nietodominguez.je@gmail.com"

I will be happy to help, in spanish or english!

# Brief description ------------------------------------------------------------

This code uses data from the "rfids 130.csv" and "rfids 147.csv" files. The raw data from both files contains the GreenFeed machines' readings of individual cow's "In"s and "Out"s, their CowTag (basically a cow ID) and the ScanTime of each reading (a date, using the YYYY-MM-DD format, plus a time, using the HH:MM:SS format).

Using said data, this code, in broad terms:
1. Loads each file and saves them as separate data frames (named "rfids130" and "rfids147").
2. Uses the "ScanTime" variable as a POSIXct (using the lubridate library).
3. Filters only the "In"s of each cow.
4. Creates a function that compares each "In" ScanTime and keeps only the records separated by a minimum of 240 minutes between them.
5. Applies said function to both data frames, in order to calculate what we call "a visit".
6. Summarizes the amout of visits of each cow, each day, for both data frames.
7. Saves those results as two separate Excel (XLSX) files: "Visits130v4.xlsx" and "Visits147v4.xlsx".
8. Prints an "All done!" confirmation message.

# General considerations -------------------------------------------------------

1. You need the tidyverse, lubridate and openxlsx libraries. The code has comments on how to install them.
2. The 240 minute value used for the function comes from the value saved as the "Min Time Between Feeding Periods (sec)" for each GreenFeed machine. As such, even if the raw data suggests a cow going in and out of the machine every few seconds, or minutes, those are not considered "visits" to feed. A new visit is considered only if an "In" is registered after at least 240 minutes have passed (per the GreenFeed machine's specifications).
3. If you have any existing  xlsx files named "Visits130v4.xlsx", or "Visits147v4.xlsx" in your working directory, you should delete them, save them somewhere else, or rename them. Otherwise, the code will not save the files created when you run it.

# ENJOY! Hope this helps!
