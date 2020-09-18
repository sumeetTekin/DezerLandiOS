/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PaypalAccounts : Codable {
	let billingAgreementId : String?
	let createdAt : String?
	let customerId : String?
	let customerGlobalId : String?
	let defaultValue : Bool?
	let email : String?
	let globalId : String?
	let imageUrl : String?
	let subscriptions : [String]?
	let token : String?
	let updatedAt : String?
	let isChannelInitiated : Bool?
	let payerId : String?
	let payerInfo : String?
	let limitedUseOrderId : String?
	let revokedAt : String?

	enum CodingKeys: String, CodingKey {

		case billingAgreementId = "billingAgreementId"
		case createdAt = "createdAt"
		case customerId = "customerId"
		case customerGlobalId = "customerGlobalId"
		case defaultValue = "default"
		case email = "email"
		case globalId = "globalId"
		case imageUrl = "imageUrl"
		case subscriptions = "subscriptions"
		case token = "token"
		case updatedAt = "updatedAt"
		case isChannelInitiated = "isChannelInitiated"
		case payerId = "payerId"
		case payerInfo = "payerInfo"
		case limitedUseOrderId = "limitedUseOrderId"
		case revokedAt = "revokedAt"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		billingAgreementId = try values.decodeIfPresent(String.self, forKey: .billingAgreementId)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
		customerGlobalId = try values.decodeIfPresent(String.self, forKey: .customerGlobalId)
		defaultValue = try values.decodeIfPresent(Bool.self, forKey: .defaultValue)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		globalId = try values.decodeIfPresent(String.self, forKey: .globalId)
		imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
		subscriptions = try values.decodeIfPresent([String].self, forKey: .subscriptions)
		token = try values.decodeIfPresent(String.self, forKey: .token)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		isChannelInitiated = try values.decodeIfPresent(Bool.self, forKey: .isChannelInitiated)
		payerId = try values.decodeIfPresent(String.self, forKey: .payerId)
		payerInfo = try values.decodeIfPresent(String.self, forKey: .payerInfo)
		limitedUseOrderId = try values.decodeIfPresent(String.self, forKey: .limitedUseOrderId)
		revokedAt = try values.decodeIfPresent(String.self, forKey: .revokedAt)
	}

}
