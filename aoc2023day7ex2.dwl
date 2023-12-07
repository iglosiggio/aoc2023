%dw 2.5
fun strength(card: String): Number = {
    A:  12, K:  11, Q:  10, T:   9, "9": 8,
    "8": 7, "7": 6, "6": 5, "5": 4, "4": 3,
    "3": 2, "2": 1, J:   0
}[card] default ???

fun handNumber(hand: String): Number =
    (0 to sizeOf(hand)-1) as Array<Number>
    reduce (v, acc=0) -> acc*13 + strength(hand[v])

fun level(hand: String): Number =
    (0 to sizeOf(hand)-1) as Array
    map hand[$]
    groupBy $
    mapObject ({ ($$): sizeOf($) })
    then (hand) -> sizeOf(hand) match {
        case 1 -> 13*13*13*13 // Five of a kind
        case 2 ->
            if (hand.J?)
                13*13*13*13 // Five of a kind
            else
                (max(valuesOf(hand)) default ???) * 13*13*13 // Four of a kind / Full house
        case 3 ->
            if (hand.J?)
                (max(valuesOf(hand-'J')) + hand.J default ???) * 13*13*13 // Four of a kind / Full house
            else
                (max(valuesOf(hand)) default ???) * 13*13 // Three of a kind / Two pair
        case 4 ->
            if (hand.J?)
                (max(valuesOf(hand-'J')) + hand.J default ???) * 13*13 // Three of a kind / Two pair
            else
                13 // One pair
        case 5 ->
            if (hand.J?)
                13 // One pair
            else
                0 // High card
    }

var hands = payload
    replace /\r/ with ''
    splitBy '\n'
    map ($ splitBy ' ' then { hand: $[0], bid: $[1] as Number })
    map ($ ++ { level: level($.hand) })
---
hands
orderBy level($.hand)*13*13*13*13*13+handNumber($.hand)
map $.bid*($$+1)
then sum($)
