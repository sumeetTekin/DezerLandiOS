/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CreditCards : Codable {
	let bin : String?
	let cardType : String?
	let cardholderName : String?
	let commercial : String?
	let countryOfIssuance : String?
	let createdAt : String?
	let customerId : String?
	let customerGlobalId : String?
	let customerLocation : String?
	let debit : String?
	let defaultValue : Bool?
	let durbinRegulated : String?
	let expirationMonth : String?
	let expirationYear : String?
	let expired : Bool?
	let globalId : String?
	let healthcare : String?
	let imageUrl : String?
	let issuingBank : String?
	let last4 : String?
	let payroll : String?
	let prepaid : String?
	let productId : String?
	let subscriptions : [String]?
	let token : String?
	let uniqueNumberIdentifier : String?
	let updatedAt : String?
	let venmoSdk : Bool?
	let verifications : [String]?
	let maskedNumber : String?
	let expirationDate : String?

	enum CodingKeys: String, CodingKey {

		case bin = "bin"
		case cardType = "cardType"
		case cardholderName = "cardholderName"
		case commercial = "commercial"
		case countryOfIssuance = "countryOfIssuance"
		case createdAt = "createdAt"
		case customerId = "customerId"
		case customerGlobalId = "customerGlobalId"
		case customerLocation = "customerLocation"
		case debit = "debit"
		case defaultValue = "default"
		case durbinRegulated = "durbinRegulated"
		case expirationMonth = "expirationMonth"
		case expirationYear = "expirationYear"
		case expired = "expired"
		case globalId = "globalId"
		case healthcare = "healthcare"
		case imageUrl = "imageUrl"
		case issuingBank = "issuingBank"
		case last4 = "last4"
		case payroll = "payroll"
		case prepaid = "prepaid"
		case productId = "productId"
		case subscriptions = "subscriptions"
		case token = "token"
		case uniqueNumberIdentifier = "uniqueNumberIdentifier"
		case updatedAt = "updatedAt"
		case venmoSdk = "venmoSdk"
		case verifications = "verifications"
		case maskedNumber = "maskedNumber"
		case expirationDate = "expirationDate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		bin = try values.decodeIfPresent(String.self, forKey: .bin)
		cardType = try values.decodeIfPresent(String.self, forKey: .cardType)
		cardholderName = try values.decodeIfPresent(String.self, forKey: .cardholderName)
		commercial = try values.decodeIfPresent(String.self, forKey: .commercial)
		countryOfIssuance = try values.decodeIfPresent(String.self, forKey: .countryOfIssuance)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
		customerGlobalId = try values.decodeIfPresent(String.self, forKey: .customerGlobalId)
		customerLocation = try values.decodeIfPresent(String.self, forKey: .customerLocation)
		debit = try values.decodeIfPresent(String.self, forKey: .debit)
		defaultValue = try values.decodeIfPresent(Bool.self, forKey: .defaultValue)
		durbinRegulated = try values.decodeIfPresent(String.self, forKey: .durbinRegulated)
		expirationMonth = try values.decodeIfPresent(String.self, forKey: .expirationMonth)
		expirationYear = try values.decodeIfPresent(String.self, forKey: .expirationYear)
		expired = try values.decodeIfPresent(Bool.self, forKey: .expired)
		globalId = try values.decodeIfPresent(String.self, forKey: .globalId)
		healthcare = try values.decodeIfPresent(String.self, forKey: .healthcare)
		imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
		issuingBank = try values.decodeIfPresent(String.self, forKey: .issuingBank)
		last4 = try values.decodeIfPresent(String.self, forKey: .last4)
		payroll = try values.decodeIfPresent(String.self, forKey: .payroll)
		prepaid = try values.decodeIfPresent(String.self, forKey: .prepaid)
		productId = try values.decodeIfPresent(String.self, forKey: .productId)
		subscriptions = try values.decodeIfPresent([String].self, forKey: .subscriptions)
		token = try values.decodeIfPresent(String.self, forKey: .token)
		uniqueNumberIdentifier = try values.decodeIfPresent(String.self, forKey: .uniqueNumberIdentifier)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		venmoSdk = try values.decodeIfPresent(Bool.self, forKey: .venmoSdk)
		verifications = try values.decodeIfPresent([String].self, forKey: .verifications)
		maskedNumber = try values.decodeIfPresent(String.self, forKey: .maskedNumber)
		expirationDate = try values.decodeIfPresent(String.self, forKey: .expirationDate)
	}

}
