// LZW.swift
//
// Original from https://rosettacode.org/wiki/LZW_compression#Swift
// Modified ny John Scott

enum LZW {
    enum Unit<T: Equatable>: Equatable {
        case element(T)
        case index(Int)
    }
    
    enum Error: Swift.Error {
        case missingIndex(Int)
    }
     
    static func compress<T: Equatable>(_ uncompressed:[T]) -> [Unit<T>] {
        var table = [[T]]()
        var ω = [T]()
        var output = [Unit<T>]()
        
        func code(_ ω: [T]) -> Unit<T> {
            if let ωIndex = table.firstIndex(of: ω) {
                return .index(ωIndex)
            } else {
                return .element(ω[0])
            }
        }
        
        for K in uncompressed {
            let ωK = ω + [K]
            if table.contains(ωK) || ω.count == 0  {
                // K → prefix string ω or ωK → ω;
                ω = ωK
            } else {
                // code(ω) → output
                output.append(code(ω))
                // ωK → string table;
                table.append(ωK)
                // K → ω;
                ω = [K]
            }
        }
        
        if !ω.isEmpty {
            // code(ω) → output
            output.append(code(ω))
        }
        return output
    }
    
    static func decompress<T: Equatable>(_ compressed:[Unit<T>]) throws -> [T] {
        var table = [[T]]()
        var ω = [T]()
        var output = [T]()
        
        for code in compressed {
            var entry: [T]
            switch code {
            case .element(let value):
                entry = [value]
            case .index(let ωIndex):
                if ωIndex < table.count {
                    entry = table[ωIndex]
                } else if ωIndex == table.count {
                    entry = ω + [ω[0]]
                } else {
                    throw Error.missingIndex(ωIndex)
                }
            }
            
            output.append(contentsOf: entry)
            if !ω.isEmpty {
                table.append(ω + [entry[0]])
            }
            ω = entry
        }
        return output
    }
}


extension LZW.Unit: CustomStringConvertible {
    var description: String {
        switch self {
        case .element(let value):
            return "pt(\(value))"
        case .index(let index):
            return "in(\(index))"
        }
    }
}
