import CoreData

struct Persistence {
    static var inMemoryManagedObjectContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(
            name: "Models",
            managedObjectModel: makeManagedObjectModel()
        )
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container.viewContext
    }()
    
    /// Describes test entities entirely in code. This is required because Swift Package Manager
    /// does not allow one to bundle resources such as an xcdatamodel, and we want to be able to test
    /// against Core Data model objects.
    /// See: https://dmytro-anokhin.medium.com/core-data-and-swift-package-manager-6ed9ff70921a
    private static func makeManagedObjectModel() -> NSManagedObjectModel {
        let managedObjectModel = NSManagedObjectModel()
        managedObjectModel.entities = [makeCandyEntity(), makeSpaceshipEntity()]
        
        return managedObjectModel
    }
    
    private static func makeCandyEntity() -> NSEntityDescription {
        let candyEntity = NSEntityDescription()
        candyEntity.name = "Candy"
        candyEntity.managedObjectClassName = NSStringFromClass(Candy.self)
        
        let name = NSAttributeDescription()
        name.name = "name"
        name.attributeType = .stringAttributeType
        
        let calories = NSAttributeDescription()
        calories.name = "calories"
        calories.attributeType = .integer32AttributeType
        
        let isSweet = NSAttributeDescription()
        isSweet.name = "isSweet"
        isSweet.attributeType = .booleanAttributeType
        
        let similarCandies = NSRelationshipDescription()
        similarCandies.name = "similarCandies"
        similarCandies.destinationEntity = candyEntity
        
        candyEntity.properties = [ name, calories, isSweet, similarCandies ]

        return candyEntity
    }
    
    private static func makeSpaceshipEntity() -> NSEntityDescription {
        let spaceshipEntity = NSEntityDescription()
        spaceshipEntity.name = "Spaceship"
        spaceshipEntity.managedObjectClassName = NSStringFromClass(Spaceship.self)
        
        let name = NSAttributeDescription()
        name.name = "name"
        name.attributeType = .stringAttributeType
        
        let shipDescription = NSAttributeDescription()
        shipDescription.name = "shipDescription"
        shipDescription.attributeType = .stringAttributeType
        
        let cost = NSAttributeDescription()
        cost.name = "cost"
        cost.attributeType = .integer32AttributeType
        
        let fleetMembers = NSRelationshipDescription()
        fleetMembers.name = "fleetMembers"
        fleetMembers.destinationEntity = spaceshipEntity
        
        let enemies = NSRelationshipDescription()
        enemies.name = "enemies"
        enemies.destinationEntity = spaceshipEntity
        
        let isReal = NSAttributeDescription()
        isReal.name = "isReal"
        isReal.attributeType = .booleanAttributeType
        
        spaceshipEntity.properties = [
            name,
            shipDescription,
            cost,
            fleetMembers,
            enemies,
            isReal
        ]
        
        return spaceshipEntity
    }
    
    private init() {}
}
