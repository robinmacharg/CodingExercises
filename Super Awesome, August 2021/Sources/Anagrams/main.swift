/**
 * Anagrams.
 *
 * Takes as argument the path to a file containing one word per line,
 * groups the words that are anagrams to each other, and writes to
 * the standard output each of these groups.
 *
 * The groups are separated by newlines and the words inside each
 * group are separated by commas.
 *
 * Example usage:
 *
 *     ./Anagrams path/to/wordfile.txt
 */

import Foundation

do {
    if CommandLine.arguments.count == 2 {
        let anagramFinder = Anagrams(filepath: CommandLine.arguments[1])
        try anagramFinder.run()
    }
    else {
        print("Exactly one argument must be supplied")
        exit(AnagramError.INCORRECT_ARGUMENTS)
    }
}
catch let error {
    print("There was an unknown problem: \(error.localizedDescription)")
    exit(AnagramError.GENERAL_ERROR)
}
