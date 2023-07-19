# PredicateBuilder
PredicateBuilder is a declarative, type-safe way to create `NSPredicate` types used to constrain Core Data fetching and collection filtering.

🧱  **Build predicates with a DSL**, key paths, simple included operator types like `And`, and SwiftUI-like modifiers

🔍  **Visualize and understand predicate problems at compile-time** and leave runtime crashes behind

📚  **Transform dense, complex predicate format strings** into composable and readable predicates

🧩  **Integrate seamlessly into existing codebases** since all `@PredicateBuilder` types build a normal `NSPredicate`

## Isn't this just [`Foundation.#Predicate`](https://developer.apple.com/documentation/foundation/predicate)? 
It's more! Swift 5.9's `Predicate` type introduced a nice improvement in type safety when interacting with predicates, especially with SwiftData. Unfortunately, it comes with some of the same pitfalls as the NSPredicate Format String Syntax, such as runtime crashes when querying a type that is not supported by CoreData. 

PredicateBuilder offers enhanced compile-time safety and a DSL for composing predicates.

## Usage 

```swift
// Simple predicates
let namePredicate: NSPredicate = \Candy.name == "Reese's"
@PredicateBuilder<Candy> var isSweetPredicate: NSPredicate {
    \Candy.isSweet
}

// Compound predicates
let isSharingSize: NSPredicate = \Candy.isKingSize || \Candy.servings > 2
@PredicateBuilder<Candy> var isTake5Bar: NSPredicate { // 🍫 Not sponsored 🥨
    And {
        \Candy.ingredients.contains(.chocolate)
        \Candy.ingredients.contains(.peanuts)
        \Candy.ingredients.contains(.caramel)
        \Candy.ingredients.contains(.peanutButter)
        
        // Dropping the leading type name is allowed when the compiler can infer it
        \.ingredients.contains(.pretzels)
    }
}

// Modifiers
let isChocolate: NSPredicate = Value(\Candy.ingredients).contains(.cocoa)
@PredicateBuilder<Candy> var caseInsensitiveNameLikePredicate: NSPredicate {
    Value(\.name)
        .like("snickers")
        .withOptions(.caseInsensitive)
}

// More complex predicate composed of subpredicates:
// Use the TypedPredicate type to compose predicates from other predicates.
// This preserves the type information needed to build the final result.
@PredicateBuilder var isSweetPredicate: some TypedPredicate<Candy> {
    \.isSweet
}
@PredicateBuilder<Candy> var complexCandyPredicate: NSPredicate {
    if isSweetToothActive {
        isSweetPredicate
    }
    
    for name in favoriteCandyNames {
        \.name == name
    }
    
    Or {
        // Any of our favorite candy shop's candies that are chocolate
        // Resolves to 'ANY candiesInStock.isChocolate == 1' in the NSPredicate expression language
        AnyMembers(of: \CandyShop.favorite.candiesInStock) {
            \.isChocolate
        }
        
        // We dislike Almonds so much that we only want the halloween basket contents if 
        // there isn't a single Almond Joy in there
        NoMembers(of: \HalloweenBasket.current.contents) {
            \.name == "Almond Joy"
        }
    }
}

// ❌ Invalid predicates that won't compile
\String.count == 5 // Operator function '==' requires that 'String' inherit from 'NSManagedObject'
\Candy.isSweet == 24 // Cannot compare right hand operand type that does not match key path's `Value` type
@PredicateBuilder<Candy> var predicate: NSPredicate {
    \NSString.boolValue == true // NSString.self != Candy.self
}
```

## Requirements
The types you query with `@PredicateBuilder` must be `NSManagedObject` subclasses. This ensures that each property you are querying is supported by the `NSPredicate` expression language and protects your code from potential crashes. 

## Installation 
### Swift Package Manager
Add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/square/predicate-builder", from: "1.0.0")
]
```

Or navigate to your Xcode project then select `Add Package Dependencies`, and search for `PredicateBuilder`.