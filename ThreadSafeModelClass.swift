//
//  ThreadSafeModelClass.swift
//  MinCostPath
//
//  Created by sandeepan swain on 15/11/22.
//

import Foundation

// consider the following model without threadsafety

public class BaseModel {
    public var investedAmount: Decimal
    public var currentInvestmentValue: Decimal
    public var currentReturns: Decimal
    public var currentReturnsPercentage: Decimal

    init(investedAmount: Decimal,
         currentInvestmentValue: Decimal,
         currentReturns: Decimal,
         currentReturnsPercentage: Decimal) {
        self.investedAmount = investedAmount
        self.currentInvestmentValue = currentInvestmentValue
        self.currentReturns = currentReturns
        self.currentReturnsPercentage = currentReturnsPercentage
    }
    
}


class DispatchQueueManager {
    public static let concurrent = DispatchQueue(label: "Custom Dispatch Queue",
                                                      attributes: .concurrent)
}

@propertyWrapper public class ThreadSafe<T>{
    private let concurrentQueue = DispatchQueueManager.concurrent
    private var value: T
    public init(wrappedValue: T) {
        self.value = wrappedValue
    }
    
    public var wrappedValue:T {
        set(newValue) {
            self.concurrentQueue.async(flags: .barrier) {[weak self] in
                self?.value = newValue
            }
        }
        get {
            return self.concurrentQueue.sync {
                return self.value
            }
        }
    }
}

// thread safe model class

public class BaseModel {
    @ThreadSafe public var investedAmount: Decimal
    @ThreadSafe public var currentInvestmentValue: Decimal
    @ThreadSafe public var currentReturns: Decimal
    @ThreadSafe public var currentReturnsPercentage: Decimal

    init(investedAmount: Decimal,
         currentInvestmentValue: Decimal,
         currentReturns: Decimal,
         currentReturnsPercentage: Decimal) {
        self.investedAmount = investedAmount
        self.currentInvestmentValue = currentInvestmentValue
        self.currentReturns = currentReturns
        self.currentReturnsPercentage = currentReturnsPercentage
    }
    
}
