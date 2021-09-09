# Anagrams

This program takes a text file containing words (one word per line) and collects together anagrams in an efficient way.

This is a command-line program written in Swift, intended for Macs.

This zip file contains the application source and requires you to buid the executable yourself.  Build it as follows:

1. Open the Xcode project file, `Anagrams.xcodeproj`
2. In Xcode select `Archive` from the `Product` menu
3. Once built, in the Organiser select `Distribute Content`, then `Built Products`.  Select a location.  The executable can be run from the command-line, e.g.

`$ ./Anagrams path/to/input/file.txt`

Alternatively, the project is set up to run the built application with a small example input file. (`Product -> Run` or CMD-R).

Integration tests are provided.  These differ from equivalent unit tests in that they test the output of the program.  This is by design since there is only a single main anagram generation method.  Given more time I'd have extended the application to allow for injectable input/output and more fine-grained unit testing.

## Big O analysis

The program has a single main loop that runs once for each line. While there are dictionary and set insertions (O(n log(n)), word sorts (also O(n log(n)), where n in the worst case is the maximum length of a word in the file, the per-line loop dominates and gives the application O(n) runtime where n is number of lines in the file.

Some further comments:

The application reads a line at a time, and outputs all anagrams for each particular length of word (2 characters, 3 characters etc) before continuing.  The instructions assure us that this will fit in memory.  The temporary anagram container structure is emptied after each length is output.

On that note, the main data structure is a dictionary of sets, keyed on an alphanumerically sorted word.  A string set was chosen as the value since it provides efficient deduplication of repeated anagrams, as per the instructions.  I had looked at using a product of primes (A=2, B=3, C=5, "CAB" = 2 x 3 x 5 == 30, etc) as the key but, given there is no maximum word length constraint, couldn't guarantee that the product wouldn't overflow.

An additional stream reader is copied in wholesale to handle per-line file reading.  At the risk of overkill since this is a command-line program error values have been included via a static constant struct.

Further separation of concern could be achieved by allowing an injectable file reader iterator and output mechanism.  This would allow for more isolated unit testing.

Testing has been done for a relatively small file, an empty file and various permutations of the command line.  Pragmatism has been applied to complete the work within a reasonable timeframe. 
