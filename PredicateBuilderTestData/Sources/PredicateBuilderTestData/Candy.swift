import CoreData

@objc public class Candy: NSManagedObject {
    public static let reeses: Candy = Candy(
        name: "Reese's",
        calories: 250
    )
    
    public static let almondJoy: Candy = Candy(
        name: "Almond Joy",
        calories: 100,
        similarCandies: [.reeses] // both chocolatey
    )
    
    @NSManaged public var name: String
    @NSManaged public var calories: Int
    @NSManaged public var isSweet: Bool
    @NSManaged public var similarCandies: Set<Candy>?
    
    public convenience init(
        name: String,
        calories: Int,
        isSweet: Bool = true,
        similarCandies: [Candy] = []
    ) {
        self.init(context: Persistence.inMemoryManagedObjectContext)
        
        self.name = name
        self.calories = calories
        self.isSweet = isSweet
        self.similarCandies = Set(similarCandies)
    }
}
