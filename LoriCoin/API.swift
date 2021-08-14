// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetBnbbusdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetBNBBUSD($dates: [ISO8601DateTime!]!, $window: Int!) {
      ethereum(network: bsc) {
        __typename
        dexTrades(
          options: {desc: "timeInterval.minute"}
          date: {in: $dates}
          exchangeName: {in: ["Pancake", "Pancake v2"]}
          baseCurrency: {is: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"}
          quoteCurrency: {is: "0xe9e7cea3dedca5984780bafc599bd69add087d56"}
        ) {
          __typename
          timeInterval {
            __typename
            minute(count: $window, format: "%Y-%m-%dT%H:%M:%SZ")
          }
          quotePrice
        }
      }
    }
    """

  public let operationName: String = "GetBNBBUSD"

  public var dates: [ISO8601DateTime]
  public var window: Int

  public init(dates: [ISO8601DateTime], window: Int) {
    self.dates = dates
    self.window = window
  }

  public var variables: GraphQLMap? {
    return ["dates": dates, "window": window]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dexTrades", arguments: ["options": ["desc": "timeInterval.minute"], "date": ["in": GraphQLVariable("dates")], "exchangeName": ["in": ["Pancake", "Pancake v2"]], "baseCurrency": ["is": "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"], "quoteCurrency": ["is": "0xe9e7cea3dedca5984780bafc599bd69add087d56"]], type: .list(.nonNull(.object(DexTrade.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dexTrades: [DexTrade]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "dexTrades": dexTrades.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Trades on Ethereum DEX Smart Contracts
      public var dexTrades: [DexTrade]? {
        get {
          return (resultMap["dexTrades"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DexTrade] in value.map { (value: ResultMap) -> DexTrade in DexTrade(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }, forKey: "dexTrades")
        }
      }

      public struct DexTrade: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumDexTrades"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("timeInterval", type: .object(TimeInterval.selections)),
            GraphQLField("quotePrice", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(timeInterval: TimeInterval? = nil, quotePrice: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumDexTrades", "timeInterval": timeInterval.flatMap { (value: TimeInterval) -> ResultMap in value.resultMap }, "quotePrice": quotePrice])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Time interval
        public var timeInterval: TimeInterval? {
          get {
            return (resultMap["timeInterval"] as? ResultMap).flatMap { TimeInterval(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "timeInterval")
          }
        }

        public var quotePrice: Double? {
          get {
            return resultMap["quotePrice"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "quotePrice")
          }
        }

        public struct TimeInterval: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["TimeInterval"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("minute", arguments: ["count": GraphQLVariable("window"), "format": "%Y-%m-%dT%H:%M:%SZ"], type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(minute: String) {
            self.init(unsafeResultMap: ["__typename": "TimeInterval", "minute": minute])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var minute: String {
            get {
              return resultMap["minute"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "minute")
            }
          }
        }
      }
    }
  }
}

public final class DevWalletQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query DevWallet($address: [String!]) {
      ethereum(network: bsc) {
        __typename
        transfers(options: {asc: "date.date", limit: 1}, currency: {in: $address}) {
          __typename
          date {
            __typename
            date: date
          }
          sender {
            __typename
            address
          }
          receiver {
            __typename
            address
          }
        }
      }
    }
    """

  public let operationName: String = "DevWallet"

  public var address: [String]?

  public init(address: [String]?) {
    self.address = address
  }

  public var variables: GraphQLMap? {
    return ["address": address]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("transfers", arguments: ["options": ["asc": "date.date", "limit": 1], "currency": ["in": GraphQLVariable("address")]], type: .list(.nonNull(.object(Transfer.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transfers: [Transfer]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "transfers": transfers.flatMap { (value: [Transfer]) -> [ResultMap] in value.map { (value: Transfer) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Currency Transfers
      public var transfers: [Transfer]? {
        get {
          return (resultMap["transfers"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Transfer] in value.map { (value: ResultMap) -> Transfer in Transfer(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Transfer]) -> [ResultMap] in value.map { (value: Transfer) -> ResultMap in value.resultMap } }, forKey: "transfers")
        }
      }

      public struct Transfer: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumTransfers"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("date", type: .object(Date.selections)),
            GraphQLField("sender", type: .object(Sender.selections)),
            GraphQLField("receiver", type: .object(Receiver.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(date: Date? = nil, sender: Sender? = nil, receiver: Receiver? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumTransfers", "date": date.flatMap { (value: Date) -> ResultMap in value.resultMap }, "sender": sender.flatMap { (value: Sender) -> ResultMap in value.resultMap }, "receiver": receiver.flatMap { (value: Receiver) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Calendar date
        public var date: Date? {
          get {
            return (resultMap["date"] as? ResultMap).flatMap { Date(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "date")
          }
        }

        /// Transfer sender
        public var sender: Sender? {
          get {
            return (resultMap["sender"] as? ResultMap).flatMap { Sender(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "sender")
          }
        }

        /// Transfer receiver
        public var receiver: Receiver? {
          get {
            return (resultMap["receiver"] as? ResultMap).flatMap { Receiver(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "receiver")
          }
        }

        public struct Date: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Date"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("date", alias: "date", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(date: String) {
            self.init(unsafeResultMap: ["__typename": "Date", "date": date])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// String date representation with default format as YYYY-MM-DD
          public var date: String {
            get {
              return resultMap["date"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "date")
            }
          }
        }

        public struct Sender: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumAddressInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumAddressInfo", "address": address])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// String address representation
          public var address: String {
            get {
              return resultMap["address"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }
        }

        public struct Receiver: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumAddressInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumAddressInfo", "address": address])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// String address representation
          public var address: String {
            get {
              return resultMap["address"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }
        }
      }
    }
  }
}

public final class GetTransactionsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetTransactions($baseCurrency: String!, $till: ISO8601DateTime!, $limit: Int!, $offset: Int!, $quoteCurrency: String!, $minTrade: Float, $window: Int) {
      ethereum(network: bsc) {
        __typename
        dexTrades(
          options: {limit: $limit, desc: "timeInterval.minute", offset: $offset}
          time: {till: $till}
          exchangeName: {in: ["Pancake", "Pancake v2"]}
          any: [{baseCurrency: {is: $baseCurrency}, quoteCurrency: {is: $quoteCurrency}}]
          tradeAmountUsd: {gt: $minTrade}
        ) {
          __typename
          timeInterval {
            __typename
            second
            minute(count: $window, format: "%Y-%m-%dT%H:%M:%SZ")
          }
          baseCurrency {
            __typename
            address
            symbol
          }
          transaction {
            __typename
            hash
          }
          quoteCurrency {
            __typename
            symbol
          }
          count
          tradeAmount(in: USD)
          trades: count
          quotePrice
          buyAmount(in: USD)
          sellAmount(in: USD)
        }
      }
    }
    """

  public let operationName: String = "GetTransactions"

  public var baseCurrency: String
  public var till: ISO8601DateTime
  public var limit: Int
  public var offset: Int
  public var quoteCurrency: String
  public var minTrade: Double?
  public var window: Int?

  public init(baseCurrency: String, till: ISO8601DateTime, limit: Int, offset: Int, quoteCurrency: String, minTrade: Double? = nil, window: Int? = nil) {
    self.baseCurrency = baseCurrency
    self.till = till
    self.limit = limit
    self.offset = offset
    self.quoteCurrency = quoteCurrency
    self.minTrade = minTrade
    self.window = window
  }

  public var variables: GraphQLMap? {
    return ["baseCurrency": baseCurrency, "till": till, "limit": limit, "offset": offset, "quoteCurrency": quoteCurrency, "minTrade": minTrade, "window": window]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dexTrades", arguments: ["options": ["limit": GraphQLVariable("limit"), "desc": "timeInterval.minute", "offset": GraphQLVariable("offset")], "time": ["till": GraphQLVariable("till")], "exchangeName": ["in": ["Pancake", "Pancake v2"]], "any": [["baseCurrency": ["is": GraphQLVariable("baseCurrency")], "quoteCurrency": ["is": GraphQLVariable("quoteCurrency")]]], "tradeAmountUsd": ["gt": GraphQLVariable("minTrade")]], type: .list(.nonNull(.object(DexTrade.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dexTrades: [DexTrade]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "dexTrades": dexTrades.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Trades on Ethereum DEX Smart Contracts
      public var dexTrades: [DexTrade]? {
        get {
          return (resultMap["dexTrades"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DexTrade] in value.map { (value: ResultMap) -> DexTrade in DexTrade(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }, forKey: "dexTrades")
        }
      }

      public struct DexTrade: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumDexTrades"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("timeInterval", type: .object(TimeInterval.selections)),
            GraphQLField("baseCurrency", type: .object(BaseCurrency.selections)),
            GraphQLField("transaction", type: .object(Transaction.selections)),
            GraphQLField("quoteCurrency", type: .object(QuoteCurrency.selections)),
            GraphQLField("count", type: .scalar(Int.self)),
            GraphQLField("tradeAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("count", alias: "trades", type: .scalar(Int.self)),
            GraphQLField("quotePrice", type: .scalar(Double.self)),
            GraphQLField("buyAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("sellAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(timeInterval: TimeInterval? = nil, baseCurrency: BaseCurrency? = nil, transaction: Transaction? = nil, quoteCurrency: QuoteCurrency? = nil, count: Int? = nil, tradeAmount: Double? = nil, trades: Int? = nil, quotePrice: Double? = nil, buyAmount: Double? = nil, sellAmount: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumDexTrades", "timeInterval": timeInterval.flatMap { (value: TimeInterval) -> ResultMap in value.resultMap }, "baseCurrency": baseCurrency.flatMap { (value: BaseCurrency) -> ResultMap in value.resultMap }, "transaction": transaction.flatMap { (value: Transaction) -> ResultMap in value.resultMap }, "quoteCurrency": quoteCurrency.flatMap { (value: QuoteCurrency) -> ResultMap in value.resultMap }, "count": count, "tradeAmount": tradeAmount, "trades": trades, "quotePrice": quotePrice, "buyAmount": buyAmount, "sellAmount": sellAmount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Time interval
        public var timeInterval: TimeInterval? {
          get {
            return (resultMap["timeInterval"] as? ResultMap).flatMap { TimeInterval(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "timeInterval")
          }
        }

        /// Base currency
        public var baseCurrency: BaseCurrency? {
          get {
            return (resultMap["baseCurrency"] as? ResultMap).flatMap { BaseCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "baseCurrency")
          }
        }

        /// Transaction of DexTrade
        public var transaction: Transaction? {
          get {
            return (resultMap["transaction"] as? ResultMap).flatMap { Transaction(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "transaction")
          }
        }

        /// Quote currency
        public var quoteCurrency: QuoteCurrency? {
          get {
            return (resultMap["quoteCurrency"] as? ResultMap).flatMap { QuoteCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "quoteCurrency")
          }
        }

        public var count: Int? {
          get {
            return resultMap["count"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "count")
          }
        }

        public var tradeAmount: Double? {
          get {
            return resultMap["tradeAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "tradeAmount")
          }
        }

        public var trades: Int? {
          get {
            return resultMap["trades"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "trades")
          }
        }

        public var quotePrice: Double? {
          get {
            return resultMap["quotePrice"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "quotePrice")
          }
        }

        public var buyAmount: Double? {
          get {
            return resultMap["buyAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "buyAmount")
          }
        }

        public var sellAmount: Double? {
          get {
            return resultMap["sellAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "sellAmount")
          }
        }

        public struct TimeInterval: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["TimeInterval"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("second", type: .nonNull(.scalar(String.self))),
              GraphQLField("minute", arguments: ["count": GraphQLVariable("window"), "format": "%Y-%m-%dT%H:%M:%SZ"], type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(second: String, minute: String) {
            self.init(unsafeResultMap: ["__typename": "TimeInterval", "second": second, "minute": minute])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var second: String {
            get {
              return resultMap["second"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "second")
            }
          }

          public var minute: String {
            get {
              return resultMap["minute"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "minute")
            }
          }
        }

        public struct BaseCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .scalar(String.self)),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String? = nil, symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "address": address, "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Token Smart Contract Address
          public var address: String? {
            get {
              return resultMap["address"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }

        public struct Transaction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumTransactionInfoExtended"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("hash", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hash: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumTransactionInfoExtended", "hash": hash])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Hash hex representation
          public var hash: String {
            get {
              return resultMap["hash"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hash")
            }
          }
        }

        public struct QuoteCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }
      }
    }
  }
}

public final class GetLatestPriceQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetLatestPrice($baseCurrency: String!, $quoteCurrency: String!) {
      ethereum(network: bsc) {
        __typename
        dexTrades(
          options: {desc: ["block.height", "tradeIndex"], limit: 1}
          exchangeName: {in: ["Pancake", "Pancake v2"]}
          baseCurrency: {is: $baseCurrency}
          quoteCurrency: {is: $quoteCurrency}
        ) {
          __typename
          transaction {
            __typename
            hash
          }
          tradeIndex
          tradeIndex
          block {
            __typename
            height
          }
          baseCurrency {
            __typename
            symbol
            address
          }
          quoteCurrency {
            __typename
            symbol
            address
          }
          quotePrice
        }
      }
    }
    """

  public let operationName: String = "GetLatestPrice"

  public var baseCurrency: String
  public var quoteCurrency: String

  public init(baseCurrency: String, quoteCurrency: String) {
    self.baseCurrency = baseCurrency
    self.quoteCurrency = quoteCurrency
  }

  public var variables: GraphQLMap? {
    return ["baseCurrency": baseCurrency, "quoteCurrency": quoteCurrency]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dexTrades", arguments: ["options": ["desc": ["block.height", "tradeIndex"], "limit": 1], "exchangeName": ["in": ["Pancake", "Pancake v2"]], "baseCurrency": ["is": GraphQLVariable("baseCurrency")], "quoteCurrency": ["is": GraphQLVariable("quoteCurrency")]], type: .list(.nonNull(.object(DexTrade.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dexTrades: [DexTrade]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "dexTrades": dexTrades.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Trades on Ethereum DEX Smart Contracts
      public var dexTrades: [DexTrade]? {
        get {
          return (resultMap["dexTrades"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DexTrade] in value.map { (value: ResultMap) -> DexTrade in DexTrade(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }, forKey: "dexTrades")
        }
      }

      public struct DexTrade: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumDexTrades"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("transaction", type: .object(Transaction.selections)),
            GraphQLField("tradeIndex", type: .scalar(String.self)),
            GraphQLField("tradeIndex", type: .scalar(String.self)),
            GraphQLField("block", type: .object(Block.selections)),
            GraphQLField("baseCurrency", type: .object(BaseCurrency.selections)),
            GraphQLField("quoteCurrency", type: .object(QuoteCurrency.selections)),
            GraphQLField("quotePrice", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(transaction: Transaction? = nil, tradeIndex: String? = nil, block: Block? = nil, baseCurrency: BaseCurrency? = nil, quoteCurrency: QuoteCurrency? = nil, quotePrice: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumDexTrades", "transaction": transaction.flatMap { (value: Transaction) -> ResultMap in value.resultMap }, "tradeIndex": tradeIndex, "block": block.flatMap { (value: Block) -> ResultMap in value.resultMap }, "baseCurrency": baseCurrency.flatMap { (value: BaseCurrency) -> ResultMap in value.resultMap }, "quoteCurrency": quoteCurrency.flatMap { (value: QuoteCurrency) -> ResultMap in value.resultMap }, "quotePrice": quotePrice])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Transaction of DexTrade
        public var transaction: Transaction? {
          get {
            return (resultMap["transaction"] as? ResultMap).flatMap { Transaction(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "transaction")
          }
        }

        /// Index of trade in transaction, used to separate trades in transaction
        public var tradeIndex: String? {
          get {
            return resultMap["tradeIndex"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "tradeIndex")
          }
        }

        /// Block in the blockchain
        public var block: Block? {
          get {
            return (resultMap["block"] as? ResultMap).flatMap { Block(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "block")
          }
        }

        /// Base currency
        public var baseCurrency: BaseCurrency? {
          get {
            return (resultMap["baseCurrency"] as? ResultMap).flatMap { BaseCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "baseCurrency")
          }
        }

        /// Quote currency
        public var quoteCurrency: QuoteCurrency? {
          get {
            return (resultMap["quoteCurrency"] as? ResultMap).flatMap { QuoteCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "quoteCurrency")
          }
        }

        public var quotePrice: Double? {
          get {
            return resultMap["quotePrice"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "quotePrice")
          }
        }

        public struct Transaction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumTransactionInfoExtended"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("hash", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hash: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumTransactionInfoExtended", "hash": hash])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Hash hex representation
          public var hash: String {
            get {
              return resultMap["hash"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hash")
            }
          }
        }

        public struct Block: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BlockExtended"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("height", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(height: Int) {
            self.init(unsafeResultMap: ["__typename": "BlockExtended", "height": height])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Block number (height) in blockchain
          public var height: Int {
            get {
              return resultMap["height"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "height")
            }
          }
        }

        public struct BaseCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(symbol: String, address: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol, "address": address])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }

          /// Token Smart Contract Address
          public var address: String? {
            get {
              return resultMap["address"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }
        }

        public struct QuoteCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(symbol: String, address: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol, "address": address])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }

          /// Token Smart Contract Address
          public var address: String? {
            get {
              return resultMap["address"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }
        }
      }
    }
  }
}

public final class GetTopTradesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetTopTrades($baseCurrency: String!, $desc: [String!]) {
      ethereum(network: bsc) {
        __typename
        dexTrades(
          options: {limit: 20, desc: $desc}
          any: [{baseCurrency: {is: $baseCurrency}, quoteCurrency: {is: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"}}]
        ) {
          __typename
          transaction {
            __typename
            hash
          }
          tradeIndex
          date {
            __typename
            date
          }
          buyAmount
          buyAmountInUsd: buyAmount(in: USD)
          buyCurrency {
            __typename
            symbol
          }
          sellAmount
          sellCurrency {
            __typename
            symbol
          }
          sellAmountInUsd: sellAmount(in: USD)
          tradeAmount(in: USD)
        }
      }
    }
    """

  public let operationName: String = "GetTopTrades"

  public var baseCurrency: String
  public var desc: [String]?

  public init(baseCurrency: String, desc: [String]?) {
    self.baseCurrency = baseCurrency
    self.desc = desc
  }

  public var variables: GraphQLMap? {
    return ["baseCurrency": baseCurrency, "desc": desc]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dexTrades", arguments: ["options": ["limit": 20, "desc": GraphQLVariable("desc")], "any": [["baseCurrency": ["is": GraphQLVariable("baseCurrency")], "quoteCurrency": ["is": "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"]]]], type: .list(.nonNull(.object(DexTrade.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dexTrades: [DexTrade]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "dexTrades": dexTrades.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Trades on Ethereum DEX Smart Contracts
      public var dexTrades: [DexTrade]? {
        get {
          return (resultMap["dexTrades"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DexTrade] in value.map { (value: ResultMap) -> DexTrade in DexTrade(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }, forKey: "dexTrades")
        }
      }

      public struct DexTrade: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumDexTrades"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("transaction", type: .object(Transaction.selections)),
            GraphQLField("tradeIndex", type: .scalar(String.self)),
            GraphQLField("date", type: .object(Date.selections)),
            GraphQLField("buyAmount", type: .scalar(Double.self)),
            GraphQLField("buyAmount", alias: "buyAmountInUsd", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("buyCurrency", type: .object(BuyCurrency.selections)),
            GraphQLField("sellAmount", type: .scalar(Double.self)),
            GraphQLField("sellCurrency", type: .object(SellCurrency.selections)),
            GraphQLField("sellAmount", alias: "sellAmountInUsd", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("tradeAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(transaction: Transaction? = nil, tradeIndex: String? = nil, date: Date? = nil, buyAmount: Double? = nil, buyAmountInUsd: Double? = nil, buyCurrency: BuyCurrency? = nil, sellAmount: Double? = nil, sellCurrency: SellCurrency? = nil, sellAmountInUsd: Double? = nil, tradeAmount: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumDexTrades", "transaction": transaction.flatMap { (value: Transaction) -> ResultMap in value.resultMap }, "tradeIndex": tradeIndex, "date": date.flatMap { (value: Date) -> ResultMap in value.resultMap }, "buyAmount": buyAmount, "buyAmountInUsd": buyAmountInUsd, "buyCurrency": buyCurrency.flatMap { (value: BuyCurrency) -> ResultMap in value.resultMap }, "sellAmount": sellAmount, "sellCurrency": sellCurrency.flatMap { (value: SellCurrency) -> ResultMap in value.resultMap }, "sellAmountInUsd": sellAmountInUsd, "tradeAmount": tradeAmount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Transaction of DexTrade
        public var transaction: Transaction? {
          get {
            return (resultMap["transaction"] as? ResultMap).flatMap { Transaction(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "transaction")
          }
        }

        /// Index of trade in transaction, used to separate trades in transaction
        public var tradeIndex: String? {
          get {
            return resultMap["tradeIndex"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "tradeIndex")
          }
        }

        /// Calendar date
        public var date: Date? {
          get {
            return (resultMap["date"] as? ResultMap).flatMap { Date(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "date")
          }
        }

        public var buyAmount: Double? {
          get {
            return resultMap["buyAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "buyAmount")
          }
        }

        public var buyAmountInUsd: Double? {
          get {
            return resultMap["buyAmountInUsd"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "buyAmountInUsd")
          }
        }

        /// Maker buys this currency
        public var buyCurrency: BuyCurrency? {
          get {
            return (resultMap["buyCurrency"] as? ResultMap).flatMap { BuyCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "buyCurrency")
          }
        }

        public var sellAmount: Double? {
          get {
            return resultMap["sellAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "sellAmount")
          }
        }

        /// Maker sells this currency
        public var sellCurrency: SellCurrency? {
          get {
            return (resultMap["sellCurrency"] as? ResultMap).flatMap { SellCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "sellCurrency")
          }
        }

        public var sellAmountInUsd: Double? {
          get {
            return resultMap["sellAmountInUsd"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "sellAmountInUsd")
          }
        }

        public var tradeAmount: Double? {
          get {
            return resultMap["tradeAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "tradeAmount")
          }
        }

        public struct Transaction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumTransactionInfoExtended"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("hash", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hash: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumTransactionInfoExtended", "hash": hash])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Hash hex representation
          public var hash: String {
            get {
              return resultMap["hash"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hash")
            }
          }
        }

        public struct Date: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Date"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("date", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(date: String) {
            self.init(unsafeResultMap: ["__typename": "Date", "date": date])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// String date representation with default format as YYYY-MM-DD
          public var date: String {
            get {
              return resultMap["date"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "date")
            }
          }
        }

        public struct BuyCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }

        public struct SellCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }
      }
    }
  }
}

public final class GetCandleDataQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetCandleData($baseCurrency: String!, $till: ISO8601DateTime!, $limit: Int!, $offset: Int!, $quoteCurrency: String!, $minTrade: Float, $window: Int) {
      ethereum(network: bsc) {
        __typename
        dexTrades(
          options: {limit: $limit, desc: "timeInterval.minute", offset: $offset}
          time: {till: $till}
          exchangeName: {in: ["Pancake", "Pancake v2"]}
          baseCurrency: {is: $baseCurrency}
          quoteCurrency: {is: $quoteCurrency}
          tradeAmountUsd: {gt: $minTrade}
        ) {
          __typename
          timeInterval {
            __typename
            minute(count: $window, format: "%Y-%m-%dT%H:%M:%SZ")
          }
          baseCurrency {
            __typename
            address
            symbol
          }
          quoteCurrency {
            __typename
            symbol
          }
          count
          tradeAmount(in: USD)
          trades: count
          quotePrice
          maximum_price: quotePrice(calculate: maximum)
          minimum_price: quotePrice(calculate: minimum)
          open_price: minimum(of: block, get: quote_price)
          close_price: maximum(of: block, get: quote_price)
        }
      }
    }
    """

  public let operationName: String = "GetCandleData"

  public var baseCurrency: String
  public var till: ISO8601DateTime
  public var limit: Int
  public var offset: Int
  public var quoteCurrency: String
  public var minTrade: Double?
  public var window: Int?

  public init(baseCurrency: String, till: ISO8601DateTime, limit: Int, offset: Int, quoteCurrency: String, minTrade: Double? = nil, window: Int? = nil) {
    self.baseCurrency = baseCurrency
    self.till = till
    self.limit = limit
    self.offset = offset
    self.quoteCurrency = quoteCurrency
    self.minTrade = minTrade
    self.window = window
  }

  public var variables: GraphQLMap? {
    return ["baseCurrency": baseCurrency, "till": till, "limit": limit, "offset": offset, "quoteCurrency": quoteCurrency, "minTrade": minTrade, "window": window]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dexTrades", arguments: ["options": ["limit": GraphQLVariable("limit"), "desc": "timeInterval.minute", "offset": GraphQLVariable("offset")], "time": ["till": GraphQLVariable("till")], "exchangeName": ["in": ["Pancake", "Pancake v2"]], "baseCurrency": ["is": GraphQLVariable("baseCurrency")], "quoteCurrency": ["is": GraphQLVariable("quoteCurrency")], "tradeAmountUsd": ["gt": GraphQLVariable("minTrade")]], type: .list(.nonNull(.object(DexTrade.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dexTrades: [DexTrade]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "dexTrades": dexTrades.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Trades on Ethereum DEX Smart Contracts
      public var dexTrades: [DexTrade]? {
        get {
          return (resultMap["dexTrades"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DexTrade] in value.map { (value: ResultMap) -> DexTrade in DexTrade(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }, forKey: "dexTrades")
        }
      }

      public struct DexTrade: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumDexTrades"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("timeInterval", type: .object(TimeInterval.selections)),
            GraphQLField("baseCurrency", type: .object(BaseCurrency.selections)),
            GraphQLField("quoteCurrency", type: .object(QuoteCurrency.selections)),
            GraphQLField("count", type: .scalar(Int.self)),
            GraphQLField("tradeAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("count", alias: "trades", type: .scalar(Int.self)),
            GraphQLField("quotePrice", type: .scalar(Double.self)),
            GraphQLField("quotePrice", alias: "maximum_price", arguments: ["calculate": "maximum"], type: .scalar(Double.self)),
            GraphQLField("quotePrice", alias: "minimum_price", arguments: ["calculate": "minimum"], type: .scalar(Double.self)),
            GraphQLField("minimum", alias: "open_price", arguments: ["of": "block", "get": "quote_price"], type: .scalar(String.self)),
            GraphQLField("maximum", alias: "close_price", arguments: ["of": "block", "get": "quote_price"], type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(timeInterval: TimeInterval? = nil, baseCurrency: BaseCurrency? = nil, quoteCurrency: QuoteCurrency? = nil, count: Int? = nil, tradeAmount: Double? = nil, trades: Int? = nil, quotePrice: Double? = nil, maximumPrice: Double? = nil, minimumPrice: Double? = nil, openPrice: String? = nil, closePrice: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumDexTrades", "timeInterval": timeInterval.flatMap { (value: TimeInterval) -> ResultMap in value.resultMap }, "baseCurrency": baseCurrency.flatMap { (value: BaseCurrency) -> ResultMap in value.resultMap }, "quoteCurrency": quoteCurrency.flatMap { (value: QuoteCurrency) -> ResultMap in value.resultMap }, "count": count, "tradeAmount": tradeAmount, "trades": trades, "quotePrice": quotePrice, "maximum_price": maximumPrice, "minimum_price": minimumPrice, "open_price": openPrice, "close_price": closePrice])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Time interval
        public var timeInterval: TimeInterval? {
          get {
            return (resultMap["timeInterval"] as? ResultMap).flatMap { TimeInterval(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "timeInterval")
          }
        }

        /// Base currency
        public var baseCurrency: BaseCurrency? {
          get {
            return (resultMap["baseCurrency"] as? ResultMap).flatMap { BaseCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "baseCurrency")
          }
        }

        /// Quote currency
        public var quoteCurrency: QuoteCurrency? {
          get {
            return (resultMap["quoteCurrency"] as? ResultMap).flatMap { QuoteCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "quoteCurrency")
          }
        }

        public var count: Int? {
          get {
            return resultMap["count"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "count")
          }
        }

        public var tradeAmount: Double? {
          get {
            return resultMap["tradeAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "tradeAmount")
          }
        }

        public var trades: Int? {
          get {
            return resultMap["trades"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "trades")
          }
        }

        public var quotePrice: Double? {
          get {
            return resultMap["quotePrice"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "quotePrice")
          }
        }

        public var maximumPrice: Double? {
          get {
            return resultMap["maximum_price"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "maximum_price")
          }
        }

        public var minimumPrice: Double? {
          get {
            return resultMap["minimum_price"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "minimum_price")
          }
        }

        public var openPrice: String? {
          get {
            return resultMap["open_price"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "open_price")
          }
        }

        public var closePrice: String? {
          get {
            return resultMap["close_price"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "close_price")
          }
        }

        public struct TimeInterval: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["TimeInterval"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("minute", arguments: ["count": GraphQLVariable("window"), "format": "%Y-%m-%dT%H:%M:%SZ"], type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(minute: String) {
            self.init(unsafeResultMap: ["__typename": "TimeInterval", "minute": minute])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var minute: String {
            get {
              return resultMap["minute"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "minute")
            }
          }
        }

        public struct BaseCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .scalar(String.self)),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(address: String? = nil, symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "address": address, "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Token Smart Contract Address
          public var address: String? {
            get {
              return resultMap["address"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }

        public struct QuoteCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }
      }
    }
  }
}

public final class WalletBalanceQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query WalletBalance($address: String!) {
      ethereum(network: bsc) {
        __typename
        address(address: {in: [$address]}) {
          __typename
          address
          balances {
            __typename
            value
            currency {
              __typename
              address
              name
              symbol
              decimals
            }
          }
        }
      }
    }
    """

  public let operationName: String = "WalletBalance"

  public var address: String

  public init(address: String) {
    self.address = address
  }

  public var variables: GraphQLMap? {
    return ["address": address]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("address", arguments: ["address": ["in": [GraphQLVariable("address")]]], type: .nonNull(.list(.nonNull(.object(Address.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(address: [Address]) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "address": address.map { (value: Address) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Basic information about address ( or smart contract )
      public var address: [Address] {
        get {
          return (resultMap["address"] as! [ResultMap]).map { (value: ResultMap) -> Address in Address(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Address) -> ResultMap in value.resultMap }, forKey: "address")
        }
      }

      public struct Address: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumAddressInfoWithBalance"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("address", type: .nonNull(.scalar(String.self))),
            GraphQLField("balances", type: .list(.nonNull(.object(Balance.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(address: String, balances: [Balance]? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumAddressInfoWithBalance", "address": address, "balances": balances.flatMap { (value: [Balance]) -> [ResultMap] in value.map { (value: Balance) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// String address representation
        public var address: String {
          get {
            return resultMap["address"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "address")
          }
        }

        /// DEPRECATED Balances by currencies for the address
        public var balances: [Balance]? {
          get {
            return (resultMap["balances"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Balance] in value.map { (value: ResultMap) -> Balance in Balance(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Balance]) -> [ResultMap] in value.map { (value: Balance) -> ResultMap in value.resultMap } }, forKey: "balances")
          }
        }

        public struct Balance: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumBalance"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("value", type: .scalar(Double.self)),
              GraphQLField("currency", type: .object(Currency.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(value: Double? = nil, currency: Currency? = nil) {
            self.init(unsafeResultMap: ["__typename": "EthereumBalance", "value": value, "currency": currency.flatMap { (value: Currency) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var value: Double? {
            get {
              return resultMap["value"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "value")
            }
          }

          /// Currency of transfer
          public var currency: Currency? {
            get {
              return (resultMap["currency"] as? ResultMap).flatMap { Currency(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "currency")
            }
          }

          public struct Currency: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Currency"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("address", type: .scalar(String.self)),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
                GraphQLField("decimals", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(address: String? = nil, name: String? = nil, symbol: String, decimals: Int) {
              self.init(unsafeResultMap: ["__typename": "Currency", "address": address, "name": name, "symbol": symbol, "decimals": decimals])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Token Smart Contract Address
            public var address: String? {
              get {
                return resultMap["address"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "address")
              }
            }

            /// Currency name
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// Currency symbol
            public var symbol: String {
              get {
                return resultMap["symbol"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "symbol")
              }
            }

            /// Decimals
            public var decimals: Int {
              get {
                return resultMap["decimals"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "decimals")
              }
            }
          }
        }
      }
    }
  }
}

public final class WalletTransactionsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query WalletTransactions($adress: String!) {
      ethereum(network: bsc) {
        __typename
        dexTrades(makerOrTaker: {is: $adress}) {
          __typename
          gasPrice
          smartContract {
            __typename
            currency {
              __typename
              name
              symbol
            }
          }
          gasValue(in: USD)
          exchange {
            __typename
            fullName
          }
          sellCurrency {
            __typename
            name
            address
            symbol
          }
          buyCurrency {
            __typename
            name
            symbol
            address
          }
          buyAmount(in: USD)
          tradeIndex
          transaction {
            __typename
            hash
            to {
              __typename
              address
            }
            txFrom {
              __typename
              address
            }
          }
          sellAmount(in: USD)
        }
      }
    }
    """

  public let operationName: String = "WalletTransactions"

  public var adress: String

  public init(adress: String) {
    self.adress = adress
  }

  public var variables: GraphQLMap? {
    return ["adress": adress]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("ethereum", arguments: ["network": "bsc"], type: .object(Ethereum.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereum: Ethereum? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereum": ethereum.flatMap { (value: Ethereum) -> ResultMap in value.resultMap }])
    }

    /// Ethereum Mainnet / Classic Chain Datasets
    public var ethereum: Ethereum? {
      get {
        return (resultMap["ethereum"] as? ResultMap).flatMap { Ethereum(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereum")
      }
    }

    public struct Ethereum: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Ethereum"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dexTrades", arguments: ["makerOrTaker": ["is": GraphQLVariable("adress")]], type: .list(.nonNull(.object(DexTrade.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(dexTrades: [DexTrade]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Ethereum", "dexTrades": dexTrades.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Trades on Ethereum DEX Smart Contracts
      public var dexTrades: [DexTrade]? {
        get {
          return (resultMap["dexTrades"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DexTrade] in value.map { (value: ResultMap) -> DexTrade in DexTrade(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DexTrade]) -> [ResultMap] in value.map { (value: DexTrade) -> ResultMap in value.resultMap } }, forKey: "dexTrades")
        }
      }

      public struct DexTrade: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EthereumDexTrades"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("gasPrice", type: .nonNull(.scalar(Double.self))),
            GraphQLField("smartContract", type: .object(SmartContract.selections)),
            GraphQLField("gasValue", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("exchange", type: .object(Exchange.selections)),
            GraphQLField("sellCurrency", type: .object(SellCurrency.selections)),
            GraphQLField("buyCurrency", type: .object(BuyCurrency.selections)),
            GraphQLField("buyAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
            GraphQLField("tradeIndex", type: .scalar(String.self)),
            GraphQLField("transaction", type: .object(Transaction.selections)),
            GraphQLField("sellAmount", arguments: ["in": "USD"], type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(gasPrice: Double, smartContract: SmartContract? = nil, gasValue: Double? = nil, exchange: Exchange? = nil, sellCurrency: SellCurrency? = nil, buyCurrency: BuyCurrency? = nil, buyAmount: Double? = nil, tradeIndex: String? = nil, transaction: Transaction? = nil, sellAmount: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumDexTrades", "gasPrice": gasPrice, "smartContract": smartContract.flatMap { (value: SmartContract) -> ResultMap in value.resultMap }, "gasValue": gasValue, "exchange": exchange.flatMap { (value: Exchange) -> ResultMap in value.resultMap }, "sellCurrency": sellCurrency.flatMap { (value: SellCurrency) -> ResultMap in value.resultMap }, "buyCurrency": buyCurrency.flatMap { (value: BuyCurrency) -> ResultMap in value.resultMap }, "buyAmount": buyAmount, "tradeIndex": tradeIndex, "transaction": transaction.flatMap { (value: Transaction) -> ResultMap in value.resultMap }, "sellAmount": sellAmount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Gas price in Gwei
        public var gasPrice: Double {
          get {
            return resultMap["gasPrice"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "gasPrice")
          }
        }

        /// Smart contract being called
        public var smartContract: SmartContract? {
          get {
            return (resultMap["smartContract"] as? ResultMap).flatMap { SmartContract(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "smartContract")
          }
        }

        public var gasValue: Double? {
          get {
            return resultMap["gasValue"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "gasValue")
          }
        }

        /// Identification of admin / manager / factory of smart contract, executing trades
        public var exchange: Exchange? {
          get {
            return (resultMap["exchange"] as? ResultMap).flatMap { Exchange(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "exchange")
          }
        }

        /// Maker sells this currency
        public var sellCurrency: SellCurrency? {
          get {
            return (resultMap["sellCurrency"] as? ResultMap).flatMap { SellCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "sellCurrency")
          }
        }

        /// Maker buys this currency
        public var buyCurrency: BuyCurrency? {
          get {
            return (resultMap["buyCurrency"] as? ResultMap).flatMap { BuyCurrency(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "buyCurrency")
          }
        }

        public var buyAmount: Double? {
          get {
            return resultMap["buyAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "buyAmount")
          }
        }

        /// Index of trade in transaction, used to separate trades in transaction
        public var tradeIndex: String? {
          get {
            return resultMap["tradeIndex"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "tradeIndex")
          }
        }

        /// Transaction of DexTrade
        public var transaction: Transaction? {
          get {
            return (resultMap["transaction"] as? ResultMap).flatMap { Transaction(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "transaction")
          }
        }

        public var sellAmount: Double? {
          get {
            return resultMap["sellAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "sellAmount")
          }
        }

        public struct SmartContract: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumSmartContract"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("currency", type: .object(Currency.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(currency: Currency? = nil) {
            self.init(unsafeResultMap: ["__typename": "EthereumSmartContract", "currency": currency.flatMap { (value: Currency) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Token implemented in this smart contract
          public var currency: Currency? {
            get {
              return (resultMap["currency"] as? ResultMap).flatMap { Currency(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "currency")
            }
          }

          public struct Currency: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Currency"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String? = nil, symbol: String) {
              self.init(unsafeResultMap: ["__typename": "Currency", "name": name, "symbol": symbol])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Currency name
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// Currency symbol
            public var symbol: String {
              get {
                return resultMap["symbol"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "symbol")
              }
            }
          }
        }

        public struct Exchange: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumDex"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("fullName", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(fullName: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumDex", "fullName": fullName])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Full name ( name for known, Protocol for unknown )
          public var fullName: String {
            get {
              return resultMap["fullName"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "fullName")
            }
          }
        }

        public struct SellCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("address", type: .scalar(String.self)),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, address: String? = nil, symbol: String) {
            self.init(unsafeResultMap: ["__typename": "Currency", "name": name, "address": address, "symbol": symbol])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency name
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// Token Smart Contract Address
          public var address: String? {
            get {
              return resultMap["address"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }
        }

        public struct BuyCurrency: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Currency"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("symbol", type: .nonNull(.scalar(String.self))),
              GraphQLField("address", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, symbol: String, address: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Currency", "name": name, "symbol": symbol, "address": address])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Currency name
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// Currency symbol
          public var symbol: String {
            get {
              return resultMap["symbol"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "symbol")
            }
          }

          /// Token Smart Contract Address
          public var address: String? {
            get {
              return resultMap["address"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "address")
            }
          }
        }

        public struct Transaction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EthereumTransactionInfoExtended"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("hash", type: .nonNull(.scalar(String.self))),
              GraphQLField("to", type: .object(To.selections)),
              GraphQLField("txFrom", type: .nonNull(.object(TxFrom.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hash: String, to: To? = nil, txFrom: TxFrom) {
            self.init(unsafeResultMap: ["__typename": "EthereumTransactionInfoExtended", "hash": hash, "to": to.flatMap { (value: To) -> ResultMap in value.resultMap }, "txFrom": txFrom.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Hash hex representation
          public var hash: String {
            get {
              return resultMap["hash"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hash")
            }
          }

          /// Transaction receiver
          public var to: To? {
            get {
              return (resultMap["to"] as? ResultMap).flatMap { To(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "to")
            }
          }

          /// Transaction from address
          public var txFrom: TxFrom {
            get {
              return TxFrom(unsafeResultMap: resultMap["txFrom"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "txFrom")
            }
          }

          public struct To: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["EthereumAddressInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("address", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(address: String) {
              self.init(unsafeResultMap: ["__typename": "EthereumAddressInfo", "address": address])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// String address representation
            public var address: String {
              get {
                return resultMap["address"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "address")
              }
            }
          }

          public struct TxFrom: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["EthereumAddressInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("address", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(address: String) {
              self.init(unsafeResultMap: ["__typename": "EthereumAddressInfo", "address": address])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// String address representation
            public var address: String {
              get {
                return resultMap["address"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "address")
              }
            }
          }
        }
      }
    }
  }
}
