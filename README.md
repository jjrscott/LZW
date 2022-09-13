# LZW

This project's purpose was to educate me (jjrscott) on how the LZW works. While build this project I realised that the LZW algorithm as originally states has two distinct parts:

1. encoding characters into an alphabet and pre-populating a prefix table,
2. (the part normally though of as LZW) expanding the prefix table and encoding table indexes into an output stream.

I can use Swift's `enum` to abstract away the need for a pre-populated string table / alphabet to reveal the algorthim in a more pure form.

## Rosetta Code

From [Rosetta Code](https://rosettacode.org/wiki/LZW_compression):

> The Lempel-Ziv-Welch (LZW) algorithm provides loss-less data compression.
>
> You can read a complete description of it in the [Wikipedia article](https://en.wikipedia.org/wiki/Lempel-Ziv-Welch) on the subject. It was patented, but it entered the public domain in 2004.

### Classic example

For some reason all demos use `TOBEORNOTTOBEORTOBEORNOT` as the input string. The following example takes a string and produces an integer array, just as the original demos do.

```swift
import LZW

let original = "TOBEORNOTTOBEORTOBEORNOT"

let compressed = LZW.compress(original.utf8.map({$0}))

print("compressed: \(compressed)")

let encoded = compressed.map { unit in
    switch unit {
    case .element(let value):
        return UInt(value)
    case .index(let index):
        return UInt(UInt8.max) + UInt(index)
    }
}

print("encoded: \(encoded)")
```

**Output:**

```
compressed: [.element(84), .element(79), .element(66), .element(69), .element(79),
             .element(82), .element(78), .element(79), .element(84), .index(0),
             .index(2), .index(4), .index(9), .index(3), .index(5), .index(7)]
encoded: [84, 79, 66, 69, 79, 82, 78, 79, 84, 256, 258, 260, 265, 259, 261, 263]
```

## Algorithm

[A Technique for High-Performance Data Compression](https://www.csd.uoc.gr/~hy474/bibliography/DataCompression-Welch.pdf):

```
Initialize table to contain single-character strings
Read first input character K:
        K → prefix string ω;
Step: Read next input character K
         If no such K (input exhausted):
                    code(ω) → output;
                    EXIT.
         If ωK exists in string table:
                    ωK → ω;
                    repeat Step.
         else ωK not in string table:
                    code(ω) → output;
                    ωK → string table;
                    K → ω;
                    repeat Step.
```
