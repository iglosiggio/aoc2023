%dw 2.5
import * from dw::core::Arrays
import * from dw::core::Strings
var lines = payload
    replace '\r' with ''
    splitBy '\n'
    map ($ splitBy ' ')
    map ({
        records: $[0],
        broken: $[1]
            splitBy ','
            map $ as Number
    })

fun doThing(line: String, check: Array<Number>): Number = do {
    var lineLen = sizeOf(line)
    var checkLen = sizeOf(check)
    var validSuffixes = reverse(line)
        splitBy ''
        reduce (v, acc=[true]) -> (v != '#' and acc[0]) >> acc
    @TailRec()
    fun rec(idx: Number, groupSize: Number, checkIdx: Number): Number = do {
        var c = line[idx]
        ---
        // Nothing else to check?
        if (checkIdx == checkLen)
            // Then there shouldn't be any '#' remaining
            if (groupSize == 0 and validSuffixes[idx])
                1
            else
                0
        // End of line without every group checked
        else if (idx == lineLen)
            // If we have exactly one more group to check lets do it
            if (checkIdx == checkLen - 1 and groupSize == check[checkIdx])
                1
            else
                0
        // Decision point
        else if (c == '?')
            // If we are not inside a group
            if (groupSize == 0)
                // Then both options are reasonable
                rec(idx + 1, 1, checkIdx) + rec(idx + 1, 0, checkIdx)
            // If we are inside a group let's check if we can end it here
            else if (check[checkIdx] == groupSize)
                rec(idx + 1, groupSize + 1, checkIdx) + rec(idx + 1, 0, checkIdx + 1)
            else
                rec(idx + 1, groupSize + 1, checkIdx)
        else if (c == '.')
            // If we are not inside a group
            if (groupSize == 0)
                // Skip
                rec(idx + 1, 0, checkIdx)
            // Else check
            else if (check[checkIdx] == groupSize)
                rec(idx + 1, 0, checkIdx + 1)
            else 0
        else if (c == '#')
            // The current group becomes bigger
            rec(idx + 1, groupSize + 1, checkIdx)
        else
            ???
    }
    ---
    rec(0, 0, 0)
}
---
// This does not work on the playground, you can split the input in half and process each half on itself tho
lines map doThing($.records, $.broken) sumBy $
