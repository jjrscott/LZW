// LZW.swift
//
// Original from https://rosettacode.org/wiki/LZW_compression#Swift
// Modified ny John Scott

class LZW {
    enum LZWError<T>: Error {
        case missingDictionaryElement(T)
        case missingDictionaryIndex(Int)
    }
    
    class func compress<T: Hashable>(_ uncompressed:[T], alphabet: [T]) throws -> [Int] {
        guard uncompressed.count > 0 else { return [] }
        
        var dictionary = [[T] : Int]()
        for (i, s) in alphabet.enumerated() {
            dictionary[[s]] = i
        }

        var w = [T]()
        var result = [Int]()
        for c in uncompressed {
            let wc = w + [c]
            if dictionary[wc] != nil {
                w = wc
            } else {
                dictionary[wc] = dictionary.count
                guard let wIndex = dictionary[w] else {
                    throw LZWError.missingDictionaryElement(w)
                }
                result.append(wIndex)
                w = [c]
            }
        }
        
        if !w.isEmpty {
            guard let wIndex = dictionary[w] else {
                throw LZWError.missingDictionaryElement(w)
            }
            result.append(wIndex)
        }
        return result
    }
    
    class func decompress<T: Hashable>(_ compressed:[Int], alphabet: [T]) throws -> [T] {
        guard compressed.count > 0 else { return [] }
        
        var dictionary = [Int: [T]]()
        
        for (i, s) in alphabet.enumerated() {
            dictionary[i] = [s]
        }

        var w = [alphabet[compressed[0]]]
        var result = w
        for wIndex in compressed[1 ..< compressed.count] {
            var entry = [T]()
            if let x = dictionary[wIndex] {
                entry = x
            } else if wIndex == dictionary.count {
                entry = w + [w[0]]
            } else {
                throw LZWError<T>.missingDictionaryIndex(wIndex)
            }
            
            result += entry
            dictionary[dictionary.count] = w + [entry[0]]
            w = entry
        }
        return result
    }
}

extension LZW {
    class func compress(_ uncompressed:String) throws -> [Int] {
        let uncompressed = uncompressed.utf8.map({$0})
        let alphabet = (String.UTF8View.Element.min ... String.UTF8View.Element.max).map({$0})
        return try compress(uncompressed, alphabet: alphabet)
    }
    
    class func decompress(_ compressed:[Int]) throws -> String {
        let alphabet = (String.UTF8View.Element.min ... String.UTF8View.Element.max).map({$0})
        let uncompressed = try decompress(compressed, alphabet: alphabet)
        return String(decoding: uncompressed, as: UTF8.self)
    }
}
