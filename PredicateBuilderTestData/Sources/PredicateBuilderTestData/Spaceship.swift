import CoreData

@objc public class Spaceship: NSManagedObject {
    public static let xWing = Spaceship(name: "X-Wing")
    public static let tieFighter = Spaceship(name: "TIE fighter", enemies: [.xWing])
    public static let deathStar = Spaceship(
        name: "Death Star",
        cost: 1_000_000_000, // price not accurate ;)
        fleetMembers: [tieFighter],
        enemies: [.xWing]
    )
    public static let tardis = Spaceship(
        name: "Tardis",
        description: "Time And Relative Dimension In Space",
        cost: 100
    )
    public static let fictionalShips: [Spaceship] = [.deathStar, .tardis]
    
    @NSManaged public var name: String
    @NSManaged public var shipDescription: String?
    @NSManaged public var cost: Int32
    @NSManaged public var fleetMembers: Set<Spaceship>?
    @NSManaged public var enemies: Set<Spaceship>
    @NSManaged public var isReal: Bool
    
    public convenience init(
        name: String,
        description: String? = nil,
        cost: Int = 0,
        fleetMembers: [Spaceship] = [],
        enemies: [Spaceship] = [],
        isReal: Bool = false
    ) {
        self.init(context: Persistence.inMemoryManagedObjectContext)
        
        self.name = name
        self.shipDescription = description
        self.cost = Int32(cost)
        self.fleetMembers = Set(fleetMembers)
        self.enemies = Set(enemies)
        self.isReal = isReal
    }
}
