//
//  main.m
//  Battleships
//
//  Created by Robin Macharg on 24/10/2023.
//

/*
 * Play a simple (one player/sided) Battleships "game".
 * Submitted for a SevenRooms automated coding assesment.
 * Time allowed was ~40 minutes.  This version has been edited
 * for clarity and correctness, as well as having commentary added.
 */

#import <Foundation/Foundation.h>

/**
 * Given a nested array describing a (row, column) grid of ships, and an array of (row, column) shots fired,
 * return an array of strings describing how the game unfolds.
 *
 * Assumptions:
 * - Shots are within the grid
 * - The grid is populated with either ".", indicating the cell is empty/sea, or a stringified number,
 *   denoting the ship.
 */
NSMutableArray<NSString *> * runGame(NSMutableArray<NSMutableArray<NSString *> *> * grid,
                                     NSMutableArray<NSMutableArray<NSNumber *> *> * shots)
{
    NSMutableArray *gameplay = [@[] mutableCopy];
    
    // Take a deep copy of the grid - we'll be modifying it
    NSData *archivedGrid = [NSKeyedArchiver archivedDataWithRootObject:grid
                                                 requiringSecureCoding:NO
                                                                 error:nil];
    
    // Explicit set of expected classes when taking a deep copy of the grid
    NSSet *allowedClasses = [NSSet setWithObjects:[NSMutableArray class], [NSString class], nil];
    
    // Unpack our deep copy
    NSMutableArray* copiedGrid = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses
                                                                     fromData:archivedGrid
                                                                        error:nil];
    
    // Iterate over the shots, recording the gameplay and updating the grid to record our hits
    for (NSMutableArray *shot in shots) {
        int row = [[shot objectAtIndex:0] intValue];
        int column = [[shot objectAtIndex:1] intValue];
        NSString *gridVal = [[copiedGrid objectAtIndex:row] objectAtIndex:column];
        
        // Miss
        if ([gridVal isEqualTo: @"."]) {
            [gameplay addObject: @"Missed"];
        }
        
        // Previous hit
        else if ([gridVal integerValue] < 0) {
            [gameplay addObject: @"Already attacked"];
        }
        
        // A new hit
        else {
            NSMutableArray *wholeRow = [copiedGrid objectAtIndex:row];
            // Replace the ship indicator with a negative version. Allows us to (potentially)
            // retrieve the ship value later (e.g. for % of ship destroyed)
            NSString *replacement = [NSString stringWithFormat:@"%d", -[gridVal intValue]];
            [wholeRow replaceObjectAtIndex:column withObject:replacement];
            [copiedGrid replaceObjectAtIndex:row withObject:wholeRow];
            
            // Obviously not efficient - constructing an initial dict of ship cell counts
            // and decrementing values would be better.
            // KVC discussed here: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html
            NSArray *flattenedGrid = [copiedGrid valueForKeyPath: @"@unionOfArrays.self"];
            
            // The grid still contains pieces of the ship, so it's not been sunk
            if ([flattenedGrid containsObject:gridVal]) {
                [gameplay addObject:[NSString stringWithFormat:@"Attacked ship %@", gridVal]];
            }
            
            // No more ship, ergo the ship has been sunk
            else {
                [gameplay addObject:[NSString stringWithFormat:@"Ship %@ sunk", gridVal]];
            }
        }
    }
    return gameplay;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Mildly more efficient array initialisation, not a concern for this amount of data
        NSMutableArray<NSMutableArray<NSString *> *> *grid = [NSMutableArray arrayWithArray:@[
            [NSMutableArray arrayWithArray:@[@".", @".", @".", @"1", @"1", @"1"]],
            [NSMutableArray arrayWithArray:@[@".", @"2", @".", @".", @".", @"."]],
            [NSMutableArray arrayWithArray:@[@".", @"2", @"3", @".", @".", @"."]],
            [NSMutableArray arrayWithArray:@[@".", @".", @"3", @".", @".", @"."]],
            [NSMutableArray arrayWithArray:@[@".", @".", @"3", @".", @".", @"."]],
        ]];
        
        // Less efficient, but still fine
        NSMutableArray<NSMutableArray<NSNumber *> *> *shots = [@[
            @[@0, @0], // Missed
            @[@0, @3], // Attacked ship 1
            @[@1, @1], // Attacked ship 2
            @[@0, @3], // Already attacked
            @[@0, @4], // Attacked ship 1
            @[@0, @5], // Ship 1 sunk
            @[@2, @1], // Ship 2 sunk
            @[@4, @5], // Missed
        ] mutableCopy];
        
        NSLog(@"%@", runGame(grid, shots));
    }
    return 0;
}

/*
Initial pseudo-code

var result: String[] = []

for shot in shots {

    let gridVal = grid[shot[0], shot[1]]

    // Empty
    if gridVal == "." {
        result.append("Missed")
    }
    
    // already attacked
    else if gridVal < 0 {
        result.append("Already attacked")
    }
    else {
        // Record hit
        grid[shot[0], shot[1]] = -gridVal // or "#"?
        if grid.joined.contains(gridVal) {
            result.append("attacked ship \(gridVal)")
        }
        else {
            result.append(Ship \(gridVal) sunk)
        }
    }
}
*/
