//
//  PerlinNoise.swift
//  Canvasing
//
//  Created by Tiago Pereira on 21/10/25.
//

import Foundation

class PerlinNoise: NoiseGenerator {
    private var permutation: [Int] = []
    
    // Initialize with a seed
    init(seed: Int = 0) {
        var p = Array(0..<256)
        var rng = SeededRandomNumberGenerator(seed: seed)
        p.shuffle(using: &rng)
        permutation = p + p
    }
    
    // Protocol implementation
    func getValue(x: Double, y: Double, time: Double) -> Double {
        return noise(x: x, y: y)
    }
    
    // Main Perlin Noise calculation function
    func noise(x: Double, y: Double) -> Double {
        let X = Int(floor(x)) & 255
        let Y = Int(floor(y)) & 255
        
        let xf = x - floor(x)
        let yf = y - floor(y)
        
        let u = fade(xf)
        let v = fade(yf)
        
        let a = permutation[X] + Y
        let aa = permutation[a]
        let ab = permutation[a + 1]
        let b = permutation[X + 1] + Y
        let ba = permutation[b]
        let bb = permutation[b + 1]
        
        let gradAA = grad(hash: permutation[aa], x: xf, y: yf)
        let gradBA = grad(hash: permutation[ba], x: xf - 1, y: yf)
        let gradAB = grad(hash: permutation[ab], x: xf, y: yf - 1)
        let gradBB = grad(hash: permutation[bb], x: xf - 1, y: yf - 1)
        
        let lerpX1 = lerp(a: gradAA, b: gradBA, t: u)
        let lerpX2 = lerp(a: gradAB, b: gradBB, t: u)
        
        return lerp(a: lerpX1, b: lerpX2, t: v)
    }
    
    // Creates an S-curve for smooth interpolation
    private func fade(_ t: Double) -> Double {
        return t * t * t * (t * (t * 6 - 15) + 10)
    }
    
    // Linear interpolation between two values
    // Blends between value 'a' and value 'b' based on parameter 't'
    private func lerp(a: Double, b: Double, t: Double) -> Double {
        return a + t * (b - a)
    }
    // The heart of Perlin Noise's "gradient" nature
    // Instead of random numbers, random gradient directions
    private func grad(hash: Int, x: Double, y: Double) -> Double {
        let h = hash & 3
        let u = h < 2 ? x : y
        let v = h < 2 ? y : x
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
    }
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: Int) {
        state = UInt64(seed)
    }
    
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}


/**

/// Perlin Noise Generator
///
/// Perlin Noise is a gradient noise function developed by Ken Perlin in 1983.
/// It creates smooth, natural-looking random values that are coherent in space.
/// This means nearby coordinates produce similar values, creating organic patterns.
///
/// Key Properties:
/// - Returns values between -1 and 1
/// - Deterministic (same input always gives same output)
/// - Smooth transitions between values
/// - No obvious repetitive patterns
class PerlinNoise: NoiseGenerator {
    
    // MARK: - Properties
    
    /// The permutation table - a shuffled array of integers 0-255, duplicated
    /// This table determines the randomness pattern of the noise
    /// It's duplicated to avoid buffer overflow when we look up neighboring values
    private var permutation: [Int] = []
    
    // MARK: - Initialization
    
    /// Initializes the Perlin Noise generator with an optional seed
    /// - Parameter seed: An integer seed for reproducible random patterns
    ///                   Same seed = same noise pattern every time
    init(seed: Int = 0) {
        // Start with sequential numbers 0 through 255
        var p = Array(0..<256)
        
        // Create a seeded random number generator
        // This ensures we get the same "random" shuffle each time with the same seed
        var rng = SeededRandomNumberGenerator(seed: seed)
        
        // Shuffle the array using our seeded random generator
        // This creates the unique noise pattern for this seed
        p.shuffle(using: &rng)
        
        // Duplicate the permutation array
        // Why? When we calculate noise, we look up values at X and X+1
        // Duplicating prevents index out of bounds errors
        // Instead of checking bounds, we can just wrap with & 255
        permutation = p + p
    }
    
    // MARK: - NoiseGenerator Protocol
    
    /// Gets a noise value at the given coordinates
    /// This is the interface method required by the NoiseGenerator protocol
    /// - Parameters:
    ///   - x: X coordinate in noise space
    ///   - y: Y coordinate in noise space
    ///   - time: Time value (not used in this implementation, but available)
    /// - Returns: A noise value between -1 and 1
    func getValue(x: Double, y: Double, time: Double) -> Double {
        return noise(x: x, y: y)
    }
    
    // MARK: - Core Noise Function
    
    /// The main Perlin Noise calculation function
    /// This implements the classic Perlin Noise algorithm
    /// - Parameters:
    ///   - x: X coordinate in noise space (can be any real number)
    ///   - y: Y coordinate in noise space (can be any real number)
    /// - Returns: A smooth noise value between -1 and 1
    func noise(x: Double, y: Double) -> Double {
        
        // STEP 1: Find the unit square that contains the point
        // ====================================================
        
        // floor(x) gives us the integer part of x
        // We AND with 255 to wrap the value within 0-255 range
        // This creates a repeating pattern every 256 units
        // Example: x = 17.3 -> X = 17, x = 258.7 -> X = 2
        let X = Int(floor(x)) & 255
        let Y = Int(floor(y)) & 255
        
        // STEP 2: Find relative position within the unit square
        // =====================================================
        
        // Get the decimal/fractional part of the coordinates
        // This tells us WHERE inside the unit square our point is
        // Values will be between 0.0 and 1.0
        // Example: x = 17.3 -> xf = 0.3, x = 17.9 -> xf = 0.9
        let xf = x - floor(x)
        let yf = y - floor(y)
        
        // STEP 3: Compute fade curves for smooth interpolation
        // ====================================================
        
        // Apply the fade function to our fractional coordinates
        // This creates an S-curve (ease in/out) that makes the interpolation smooth
        // Without this, we'd see visible grid patterns
        // The fade function creates smooth transitions between grid cells
        let u = fade(xf)
        let v = fade(yf)
        
        // STEP 4: Hash the coordinates of the unit square's four corners
        // ==============================================================
        
        // We need to calculate noise at all four corners of the square
        // and blend them together. The corners are:
        // (X, Y), (X+1, Y), (X, Y+1), (X+1, Y+1)
        
        // Get the hash value for bottom corners
        // permutation[X] gives us a pseudo-random number based on X
        // Adding Y incorporates the Y coordinate into the hash
        let a = permutation[X] + Y
        
        // Hash for bottom-left corner (X, Y)
        let aa = permutation[a]
        
        // Hash for top-left corner (X, Y+1)
        let ab = permutation[a + 1]
        
        // Get the hash value for right side corners (X+1, ...)
        let b = permutation[X + 1] + Y
        
        // Hash for bottom-right corner (X+1, Y)
        let ba = permutation[b]
        
        // Hash for top-right corner (X+1, Y+1)
        let bb = permutation[b + 1]
        
        // STEP 5: Calculate gradients at each corner
        // ==========================================
        
        // For each corner, calculate the gradient (dot product)
        // The gradient determines the direction and magnitude of influence
        // from that corner
        
        // Bottom-left corner (X, Y)
        // Distance from corner to our point: (xf, yf)
        let gradAA = grad(hash: permutation[aa], x: xf, y: yf)
        
        // Bottom-right corner (X+1, Y)
        // Distance from corner: (xf - 1, yf)
        // We subtract 1 because this corner is 1 unit to the right
        let gradBA = grad(hash: permutation[ba], x: xf - 1, y: yf)
        
        // Top-left corner (X, Y+1)
        // Distance from corner: (xf, yf - 1)
        let gradAB = grad(hash: permutation[ab], x: xf, y: yf - 1)
        
        // Top-right corner (X+1, Y+1)
        // Distance from corner: (xf - 1, yf - 1)
        let gradBB = grad(hash: permutation[bb], x: xf - 1, y: yf - 1)
        
        // STEP 6: Interpolate the gradient values
        // =======================================
        
        // First, interpolate along the X axis (left to right)
        // Blend bottom-left and bottom-right using the faded x value (u)
        let lerpX1 = lerp(a: gradAA, b: gradBA, t: u)
        
        // Blend top-left and top-right using the faded x value (u)
        let lerpX2 = lerp(a: gradAB, b: gradBB, t: u)
        
        // Finally, interpolate along the Y axis (bottom to top)
        // This blends our two X-interpolated values using the faded y value (v)
        // This gives us the final smooth noise value at point (x, y)
        return lerp(a: lerpX1, b: lerpX2, t: v)
    }
    
    // MARK: - Helper Functions
    
    /// Fade function - creates an S-curve for smooth interpolation
    ///
    /// This is Ken Perlin's improved fade function: 6t^5 - 15t^4 + 10t^3
    /// It maps input [0,1] to output [0,1] but with smooth acceleration
    /// at the start and smooth deceleration at the end
    ///
    /// Why do we need this?
    /// - Linear interpolation (just using t directly) creates visible grid patterns
    /// - This S-curve makes transitions between grid cells imperceptible
    /// - The curve has zero derivative at t=0 and t=1 (smooth at boundaries)
    ///
    /// Visual representation:
    ///   1.0 |         ___---
    ///       |      _-/
    ///   0.5 |    _/
    ///       |  _/
    ///   0.0 |_/
    ///       +------------
    ///       0    0.5    1
    ///
    /// - Parameter t: Input value between 0 and 1
    /// - Returns: Smoothly faded value between 0 and 1
    private func fade(_ t: Double) -> Double {
        // This polynomial creates the smooth S-curve
        // At t=0: result=0, at t=1: result=1
        // But the path between is smooth (not linear)
        return t * t * t * (t * (t * 6 - 15) + 10)
    }
    
    /// Linear interpolation between two values
    ///
    /// Blends between value 'a' and value 'b' based on parameter 't'
    /// When t=0, returns a
    /// When t=1, returns b
    /// When t=0.5, returns the midpoint between a and b
    ///
    /// Formula: a + t * (b - a)
    /// This can be rewritten as: a * (1-t) + b * t
    ///
    /// Example:
    ///   lerp(a: 0, b: 10, t: 0.3) = 3.0
    ///   lerp(a: 100, b: 200, t: 0.5) = 150.0
    ///
    /// - Parameters:
    ///   - a: Starting value
    ///   - b: Ending value
    ///   - t: Interpolation factor (typically 0 to 1)
    /// - Returns: Interpolated value between a and b
    private func lerp(a: Double, b: Double, t: Double) -> Double {
        return a + t * (b - a)
    }
    
    /// Gradient function - computes dot product of a pseudorandom gradient vector
    ///
    /// This is the heart of Perlin Noise's "gradient" nature
    /// Instead of random values, we use random GRADIENTS (directions)
    /// This creates the smooth, flowing quality of Perlin Noise
    ///
    /// The function:
    /// 1. Uses the hash to select one of 4 gradient directions
    /// 2. Computes the dot product with the distance vector (x, y)
    ///
    /// The 4 possible gradients are:
    /// - (1, 1)   -> h = 0
    /// - (-1, 1)  -> h = 1
    /// - (1, -1)  -> h = 2
    /// - (-1, -1) -> h = 3
    ///
    /// Why gradients instead of random values?
    /// - Ensures smoothness (values change gradually)
    /// - Creates flow and direction in the noise
    /// - The dot product gives us the "influence" of this corner
    ///
    /// - Parameters:
    ///   - hash: A pseudorandom hash value from the permutation table
    ///   - x: X component of distance vector from corner to point
    ///   - y: Y component of distance vector from corner to point
    /// - Returns: The dot product of gradient and distance vectors
    private func grad(hash: Int, x: Double, y: Double) -> Double {
        // Take bottom 2 bits of hash to get a value 0-3
        // This selects one of our 4 gradient directions
        let h = hash & 3
        
        // Select u and v based on the gradient direction
        // This is a compact way to handle all 4 cases
        // h < 2 (h = 0 or 1): use x for u, y for v
        // h >= 2 (h = 2 or 3): swap them (use y for u, x for v)
        let u = h < 2 ? x : y
        let v = h < 2 ? y : x
        
        // Apply signs based on hash bits
        // Bit 0 (h & 1): if set, negate u (changes horizontal direction)
        // Bit 1 (h & 2): if set, negate v (changes vertical direction)
        //
        // This gives us our 4 gradient directions:
        // h=0 (00): +u +v = ( x,  y) = (1, 1) direction
        // h=1 (01): -u +v = (-x,  y) = (-1, 1) direction
        // h=2 (10): +u +v = ( y,  x) = (1, -1) direction (swapped)
        // h=3 (11): -u +v = (-y,  x) = (-1, -1) direction (swapped)
        //
        // The result is the dot product: gradient · distance_vector
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
    }
}

// MARK: - Seeded Random Number Generator

/// A simple linear congruential generator (LCG) for seeded randomness
///
/// This allows us to create reproducible "random" sequences
/// The same seed always produces the same sequence of numbers
///
/// How it works:
/// - Uses a simple mathematical formula: new_state = (a * old_state + c) mod m
/// - The constants (a and c) are chosen to give good distribution
/// - We use wrapping multiplication (&*) and addition (&+) to handle overflow
///
/// Why do we need this?
/// - Swift's built-in Random uses system randomness (truly random)
/// - We need deterministic randomness (same seed = same result)
/// - This is crucial for: debugging, reproducibility, and consistent art
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    
    /// Internal state of the random number generator
    /// This gets updated with each call to next()
    private var state: UInt64
    
    /// Initialize with a seed value
    /// - Parameter seed: An integer that determines the random sequence
    init(seed: Int) {
        // Convert seed to UInt64 and store as initial state
        state = UInt64(seed)
    }
    
    /// Generate the next random number in the sequence
    /// This is required by the RandomNumberGenerator protocol
    /// - Returns: A pseudorandom UInt64 value
    mutating func next() -> UInt64 {
        // Linear Congruential Generator formula
        // state = (a * state + c) mod 2^64
        //
        // The constants used here are from PCG (Permuted Congruential Generator)
        // - Multiplier: 6364136223846793005
        // - Increment: 1442695040888963407
        //
        // &* and &+ are wrapping operators (ignore overflow)
        // This effectively does modulo 2^64 automatically
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

 */
