import CoreData
import PredicateBuilder
import PredicateBuilderCore
import PredicateBuilderTestData

// A bunch of predicate examples. 

let halloweenPumpkinContents: [Candy] = [
    .reeses,
    .almondJoy,
    Candy(name: "Impossible candy", calories: -100)
]
var halloweenCandyNames: [String] {
    halloweenPumpkinContents.map(\.name)
}

// Convenience Playground logging
func logResults(for predicate: NSPredicate, in array: Array<Candy> = halloweenPumpkinContents) {
    print("\nStarting array: \(array.map(\.name))")
    print("Predicate format string: [\(predicate.predicateFormat)]")
    let nsArray: NSArray = NSArray(array: array)
    let results = nsArray.filter(predicate.evaluate(with:))
        .map {
            guard let candy = $0 as? Candy else {
                return "Failed candy unwrap"
            }
            
            return candy.name
        }
    
    print("Results: \(results)")
}

// MARK: The old way
// The current way we build NSPredicates using format strings does not type-check the predicate
// at compile time. So this statement might compile, but it could crash at runtime due to
// querying the wrong type or the wrong (or missing) property on an object
let oldStylePredicate = NSPredicate(
    format: "%K == %@",
    // Candy.name == "Reese's"
    #keyPath(Candy.name),
    "Reese's"
)
logResults(for: oldStylePredicate)

// MARK: The new way

// Doesn't compile: Cannot convert value of type 'Int' to expected argument type 'String'
// let wrongTypePredicate: NSPredicate = \Candy.name == 2

// Doesn't compile: Value of type 'Candy' has no member 'invalidProperty'
// let invalidMemberPredicate: NSPredicate = \Candy.invalidProperty == "Snickers"


// But wait... there's more:
//
// Type safety is great, but predicates can get complex.
// A predicate with format `"%K == %@ AND %K != nil AND %K == %d AND %K IN %@"` won't look much better at the callsite, even with type safety
// e.g. (pseudocode): let predicate = \Candy.name == "Reese's" && \Candy.isAvailable != nil && myHalloweenBasket.contains(favoriteCandy) ...etc
//
// Introducing, the PredicateBuilder result builder

// MARK: - PredicateBuilder

// Single predicate
let namePredicate = \Candy.name == "Reese's"
let equalsPredicate = Value(\Candy.name).equals("Reese's")
logResults(for: namePredicate)

// Compound predicate
let caloriesPredicate = \Candy.calories == Candy.almondJoy.calories
let compoundPredicate = namePredicate || caloriesPredicate
logResults(for: compoundPredicate)

print("""

-----------------------------
PredicateBuilder DSL Examples
-----------------------------

""")

@PredicateBuilder<Candy> var simpleBuiltPredicate: NSPredicate {
    \Candy.name == "Reese's"
}
logResults(for: simpleBuiltPredicate)

// MARK: More complex predicate builders

@PredicateBuilder<Candy> var andPredicate: NSPredicate {
    And {
        \Candy.name == "Reese's"
        \Candy.calories == 999
    }
}
logResults(for: andPredicate)

let someCondition: Bool = false
@PredicateBuilder<Candy> var orPredicate: NSPredicate {
    if true {
        \Candy.name == "Reese's"
    }
    
    if someCondition {
        \Candy.name == "Reese's"
    } else {
        \Candy.isSweet
    }
}
logResults(for: orPredicate)

@PredicateBuilder<Candy> var complexPredicate: NSPredicate {
    And {  // This And can potentially be omitted: See `buildBlock(_ components: [Predicate]...) -> NSPredicate` below
        \Candy.isSweet == true

        Or {
            \Candy.calories == Candy.almondJoy.calories
            \Candy.name == "Reese's"
        }
    }
}
logResults(for: complexPredicate)

// MARK: - Predicate Modifiers


let preferredCandyName: String? = nil
@PredicateBuilder<Candy> var modifierPredicate: NSPredicate {
    And {
        \Candy.name == "test"
        \Candy.calories == 250
    }
}
logResults(for: modifierPredicate)

@PredicateBuilder<Candy> var isSweetPredicate: NSPredicate {
    \Candy.isSweet
}
logResults(for: isSweetPredicate)

@PredicateBuilder<Candy> var inPredicate: NSPredicate {
    halloweenCandyNames
        .contains(\Candy.name)
}
logResults(for: inPredicate)

@PredicateBuilder<Candy> var longCompoundedPredicate: NSPredicate {
    Or {
        \Candy.calories < 100
        \Candy.calories >= 100
        \Candy.name != "Almond Joy"
        \Candy.name == "Reese's" && \Candy.calories <= 5
    }
}
logResults(for: longCompoundedPredicate)


@PredicateBuilder<Candy> var anyPredicate: NSPredicate {
    AnyMembers(of: \Candy.similarCandies) {
        \Candy.name == "Reese's"
    }
}
logResults(for: anyPredicate)


// MARK: - Swift 5.9 playground

#if swift(>=5.9)
import PredicateBuilderMacro

if #available(macOS 14.0, iOS 17.0, *) {
    
    // MARK: Trouble with #Predicate macro
    
    // Uncomment for errors:
    // Doesn't work? "Unable to parse the format string \"(SELF.name == 'Reese's')\""
//    let macroCandyPredicate: Predicate<Candy> = #Predicate { candy in
//        candy.name == "Reese's"
//    }
//    let nsPredicateRepresentation: NSPredicate! = NSPredicate(macroCandyPredicate)
//    print(nsPredicateRepresentation?.predicateFormat)
//    logResults(for: nsPredicateRepresentation)
    
    
    // The PredicateBuilder appears to offer more type and runtime safety than
    // the #Predicate macro:

    let fetchRequest = NSFetchRequest<Candy>()
    // Crashes! The macro expansion attempts to represent "candy.isSweet" as
    // "SELF.isSweet" in the expression string, which is not the correct way
    // to compare booleans. While it compiles, it crashes at runtime.
//    fetchRequest.predicate = NSPredicate(
//        #Predicate<Candy> { candy in
//            candy.name == "Reese's" &&
//            candy.isSweet
//        }
//    )
    
    // Works as-expected
    @PredicateBuilder<Candy> var predicate: NSPredicate {
        And {
            \.name == "Reese's"
            \.isSweet
        }
    }
    fetchRequest.predicate = predicate
    
    // Now with macro support!
    fetchRequest.predicate = #PredicateBuilder<Candy> {
        \.isSweet
    }
}
#endif
