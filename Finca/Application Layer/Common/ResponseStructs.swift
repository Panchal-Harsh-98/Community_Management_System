//
//  ResponseStructs.swift
//  Finca
//
//  Created by harsh panchal on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
struct SliderResponse: Codable {
    let status: String!
    let slider: [Slider]!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case slider = "slider"
        case message = "message"
    }
}

// MARK: - Slider
struct Slider: Codable {
    let sliderImageName: String!
    let sliderStatus: String!
    let societyID: String!
    let appSliderID: String!
    
    enum CodingKeys: String, CodingKey {
        case sliderImageName = "slider_image_name"
        case sliderStatus = "slider_status"
        case societyID = "society_id"
        case appSliderID = "app_slider_id"
    }
}
struct BillResponse: Codable {
    let bill: [Bill_Model]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case bill = "bill"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Bill
struct Bill_Model: Codable {
    let receiveBillStatus: String!
    let billMasterID: String!
    let billGenrateDate: String!
    let billAmount: String!
    let unitPrice: String!
    let autoBillNumber: String!
    let receiveBillID: String!
    let billPaymentType: String!
    let billName: String!
    let billDescription: String!
    let billEndDate: String!
    let unitPhoto: String!
    let receiveBillReceiptPhoto: String!
    let noOfUnit: String!
    let billPaymentDate: String!
    let balancesheetID: String!
    
    enum CodingKeys: String, CodingKey {
        case receiveBillStatus = "receive_bill_status"
        case billMasterID = "bill_master_id"
        case billGenrateDate = "bill_genrate_date"
        case billAmount = "bill_amount"
        case unitPrice = "unit_price"
        case autoBillNumber = "auto_bill_number"
        case receiveBillID = "receive_bill_id"
        case billPaymentType = "bill_payment_type"
        case billName = "bill_name"
        case billDescription = "bill_description"
        case billEndDate = "bill_end_date"
        case unitPhoto = "unit_photo"
        case receiveBillReceiptPhoto = "receive_bill_receipt_photo"
        case noOfUnit = "no_of_unit"
        case billPaymentDate = "bill_payment_date"
        case balancesheetID = "balancesheet_id"
    }
}
struct MaintainanceResponse: Codable {
    let message: String!
    let maintenance: [Maintenance_Model]!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case maintenance = "maintenance"
        case status = "status"
    }
}

// MARK: - Maintenance
struct Maintenance_Model: Codable {
    let receiveMaintenanceDate: String!
    let balancesheetID: String!
    let createdDate: String!
    let endDate: String!
    let receiveMaintenanceID: String!
    let maintenanceDescription: String!
    let maintenanceName: String!
    let receiveMaintenanceStatus: String!
    let maintenceAmount: String!
    
    enum CodingKeys: String, CodingKey {
        case receiveMaintenanceDate = "receive_maintenance_date"
        case balancesheetID = "balancesheet_id"
        case createdDate = "created_date"
        case endDate = "end_date"
        case receiveMaintenanceID = "receive_maintenance_id"
        case maintenanceDescription = "maintenance_description"
        case maintenanceName = "maintenance_name"
        case receiveMaintenanceStatus = "receive_maintenance_status"
        case maintenceAmount = "maintence_amount"
    }
}

struct VisitorResponse: Codable {
    let status: String!
    let visitor: [Visitor_Model]!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case visitor = "visitor"
        case message = "message"
    }
}
struct Visitor_Model: Codable {
    let visitorType: String!
    let vistorNumber: String!
    let visitorMobile: String!
    let exitTime: String!
    let visitorStatus: String!
    let visitorID: String!
    let visitorName: String!
    let visitorProfile: String!
    let visitTime: String!
    let userID: String!
    let unitID: String!
    let visitDate: String!
    let societyID: String!
    let exitDate: String!
    
    enum CodingKeys: String, CodingKey {
        case visitorType = "visitor_type"
        case vistorNumber = "vistor_number"
        case visitorMobile = "visitor_mobile"
        case exitTime = "exit_time"
        case visitorStatus = "visitor_status"
        case visitorID = "visitor_id"
        case visitorName = "visitor_name"
        case visitorProfile = "visitor_profile"
        case visitTime = "visit_time"
        case userID = "user_id"
        case unitID = "unit_id"
        case visitDate = "visit_date"
        case societyID = "society_id"
        case exitDate = "exit_date"
    }
}
