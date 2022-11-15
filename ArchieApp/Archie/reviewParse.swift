//
//  reviewParse.swift
//  
//
//  Created by Jeremy Cao on 11/11/22.
//

import Foundation
import NaturalLanguage

let reviews = ["Absolutely terrible service with horrible food", "Best food in existence", "I don't know what is happening", "Horrible experience, my dog literally died after I fed them them my chocolate pudding 0/10 just disgraceful"]

getReviews(id: String -> [String]) {
    var reviewList = [String]()

    guard let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)/reviews") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let _ = print(">>>>", json, #line,"<<<<")

                if let reviews = json["businesses"] as? [NSDictionary] {
                    
                    // Cycle through each review and append only the text to a list of reviews
                    for r in reviews {
                        reviewList.append(r["text"] as! String)
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()

        return reviewList
}



func reviewTag(reviews: [String]) -> [String] {
    var corpus = " "

    for review in reviews {
        corpus = corpus + review
        corpus = corpus + " "
    }
    //let corpus = reviews[0] + " " + reviews[1] + " " + reviews[2]
    //var corpusSplit = corpus.split(separator: " ")

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
    
    
    return adjectives
}

func reviewRank(adjectives: [String]) -> Any{
    var counter = 0
    var adjInfo:[String:Int] = [:]

    for word in adjectives {
        counter = adjectives.filter{$0 == word}.count
        adjInfo["\(word)"] = counter * (1 +  (word.count/5))
    }

    //print(adjInfo)

    let ranking = adjInfo.sorted {$0.1 > $1.1}
    //print(type(of: ranking))
    //return ranking
    return (ranking[0].key, ranking[1].key, ranking[2].key)

    //print(ranking[0].key, ranking[1].key, ranking[2].key)
}

let parsedCorpus = reviewTag(reviews: reviews)
let results = reviewRank(adjectives: parsedCorpus)

//return results
print("REVIEW PARSE RESULTS: ", results)
