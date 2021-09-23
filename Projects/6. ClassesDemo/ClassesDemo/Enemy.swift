class Enemy {
    var health: Int
    var attackStrength: Int
    
    init(health: Int, attackStrength: Int) {
        self.health = health
        self.attackStrength = attackStrength
    }
    
    func takeDamage(amount: Int) {
        health = health - amount
    }
    
    func attack() {
        print("Land a hit, does \(attackStrength) damage")
    }
    
    func move() {
        print("Move forward")
    }
}
