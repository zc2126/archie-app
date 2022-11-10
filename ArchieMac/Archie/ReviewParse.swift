import NaturalLanguage

let reviews = ["Absolutely terrible service with horrible food", "Best food in existence", "I don't know what is happening", "Horrible experience, my dog literally died after I fed them them my chocolate pudding 0/10 just disgraceful"]

var corpus = " "

for review in reviews {
    corpus = corpus + review
    corpus = corpus + " "
}
//let corpus = reviews[0] + " " + reviews[1] + " " + reviews[2]

var corpusSplit = corpus.split(separator: " ")

//print(corpusSplit)

// Create the POS tagger instance
let tagger = NLTagger(tagSchemes: [.lexicalClass])
tagger.string = corpus

// Set options to omit whitespace and any punctuation; also set the range of the tagger to be length of corpus
let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinContractions]

var adjectives = [String]()

tagger.enumerateTags(in: corpus.startIndex ..< corpus.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
    if let tag = tag {
        if tag.rawValue == "Adjective" {
            adjectives.append(("\(corpus[tokenRange])").lowercased())
        }
        //print("\(corpus[tokenRange]): \(tag.rawValue)")
    }
    return true
}

//print(adjectives)

struct AdjInfo {
    var adj : String
    var count : Int
}

var adjCount = [AdjInfo]()

/*
for word in adjectives {
    if adjCount.adj.contains(word) {
        print("Counted")
    }
    else {
        adjCount.append(AdjInfo(adj: word, count: 1))
    }
}
*/
