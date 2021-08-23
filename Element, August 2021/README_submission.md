#  Simplified Cron Parser

This program parses a simplified crontab-format file and outputs the next time each job will run, given an input time representing 
"now". The full specification is provided in the accompanying [`spec.txt`](spec.txt).

Any questions should be addressed to Robin Macharg: robin.macharg@gmail.com

The program is a single Swift file.  It has been developed on a MacBook Pro running Big Sur and Xcode 12.5.

It can be run directly on a suitably configured Mac without pre-building from the command line.  An example invocation (where `$` 
represents the prompt) would look like :

`$ cat input.crontab | swift main.swift 16:10`

It reports any errors via standard POSIX shell return values (these may be examined after running by typing `echo $?`), and have the following 
meanings:

- 0 - success
- 1 - Invalid Argument - the time was malformed
- 2 - Invalid Crontab - the crontab was malformed.
- 3 - Algorithmic - An internal error.  The final output failed algorithmic consistency checks. 

The crontab parsing is whitespace- and leading-zero-tolerant. 

Several example input files have been provided: 

- `input.crontab` - The examplar input in the specification
- `invalid.crontab` - An intentionally malformed crontab file
- `edgeCases.crontab` - Edge cases for testing.  These have been run with the following input times: 
  00:00, 00:01, 00:02, 23:59,  12:26, 12:27, 12:28, 23:26

**NOTE** The spec seems to indicate that while current and crontab times are given in 24-hour time, the output should omit leading zeroes 
from the hour, but not from the minute.  This has been honoured.  If 24-hour output format is expected the final `print` line (approx line 267) 
can be replaced with the following:

`print("\(String(format: "%02d", resolvedHour)):\(String(format: "%02d", resolvedMinutes)) \(relativeDay.rawValue) - \(line.command)")`

A commented out version of this is intentionally left in for ease of replacement.

## Discussion

- The code makes heavy (but pragmantic) use of Swift features: enums, ranges, extensions, error handling etc. to simplify parsing and data 
  representation.  These precede the main algorithmic body of the code.
- Top-level functionas are used rather than classes due to the scope of the task.
- Comments are liberal and may exceed good practice for production code in order to better explain thinking and specific Swift features that 
  may not be clear to an assessor.
- As mentioned above, errors are surfaced via shell return values.  Due to the automated assessment of the program no visible error output is 
  presented.  The application may therefore fail part-way through while appearing to succeed.  In testing no algorithmic errors have been seen 
  unless forced.
