# LZW

From [Rosetta Code](https://rosettacode.org/wiki/LZW_compression):

> The Lempel-Ziv-Welch (LZW) algorithm provides loss-less data compression.
>
> You can read a complete description of it in the [Wikipedia article](https://en.wikipedia.org/wiki/Lempel-Ziv-Welch) on the subject. It was patented, but it entered the public domain in 2004.

## Project

This project's purpose was to educate me (jjrscott) on how the LZW works. While build this project I realised that I can use Swift's `enum` to abstract away the need for a pre-populated string table / alphabet to reveal the algorthim in a more pure form.

### Classic example

For some reason all demos use `TOBEORNOTTOBEORTOBEORNOT` as the input string. The following example takes a string and produces an integer array, just as the original demos do.

```swift
import LZW

func compress(_ original: String) -> [UInt] {
    LZW.compress(original.utf8.map({$0})).map { unit in
        switch unit {
        case .element(let value):
            return UInt(value)
        case .index(let index):
            return UInt(UInt8.max) + UInt(index)
        }
    }
}

let compressed = compress("TOBEORNOTTOBEORTOBEORNOT")
print(compressed)
```

**Output:**

```
[84, 79, 66, 69, 79, 82, 78, 79, 84, 256, 258, 260, 265, 259, 261, 263]
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
