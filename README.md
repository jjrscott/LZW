# LZW

From [Rosetta Code](https://rosettacode.org/wiki/LZW_compression):

> The Lempel-Ziv-Welch (LZW) algorithm provides loss-less data compression.
>
> You can read a complete description of it in the [Wikipedia article](https://en.wikipedia.org/wiki/Lempel-Ziv-Welch) on the subject. It was patented, but it entered the public domain in 2004.

## Algorithm

[A Technique for High-Performance Data Compression](https://www.csd.uoc.gr/~hy474/bibliography/DataCompression-Welch.pdf):

```
Initialize table to contain single-character strings
Read first input character → prefix string ω
Step: Read next input character K
         If no such K (input exhausted): code(ω) → output; EXIT
         If ωK exists in string table: ωK → ω; repeat Step.
         else ωK not in string table: code(ω) → output; ωK → string table; K → ω; repeat Step.
```
