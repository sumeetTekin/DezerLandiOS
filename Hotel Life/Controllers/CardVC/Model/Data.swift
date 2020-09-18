/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PaymentCardData : Codable {
	let id : String?
	let merchantId : String?
	let firstName : String?
	let lastName : String?
	let company : String?
	let email : String?
	let phone : String?
	let fax : String?
	let website : String?
	let createdAt : String?
	let updatedAt : String?
	let customFields : String?
	let globalId : String?
	let creditCards : [CreditCards]?
	let paypalAccounts : [PaypalAccounts]?
	let addresses : [String]?
	let paymentMethods : [PaymentMethods]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case merchantId = "merchantId"
		case firstName = "firstName"
		case lastName = "lastName"
		case company = "company"
		case email = "email"
		case phone = "phone"
		case fax = "fax"
		case website = "website"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case customFields = "customFields"
		case globalId = "globalId"
		case creditCards = "creditCards"
		case paypalAccounts = "paypalAccounts"
		case addresses = "addresses"
		case paymentMethods = "paymentMethods"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		merchantId = try values.decodeIfPresent(String.self, forKey: .merchantId)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		company = try values.decodeIfPresent(String.self, forKey: .company)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		fax = try values.decodeIfPresent(String.self, forKey: .fax)
		website = try values.decodeIfPresent(String.self, forKey: .website)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		customFields = try values.decodeIfPresent(String.self, forKey: .customFields)
		globalId = try values.decodeIfPresent(String.self, forKey: .globalId)
		creditCards = try values.decodeIfPresent([CreditCards].self, forKey: .creditCards)
		paypalAccounts = try values.decodeIfPresent([PaypalAccounts].self, forKey: .paypalAccounts)
		addresses = try values.decodeIfPresent([String].self, forKey: .addresses)
		paymentMethods = try values.decodeIfPresent([PaymentMethods].self, forKey: .paymentMethods)
	}

}
