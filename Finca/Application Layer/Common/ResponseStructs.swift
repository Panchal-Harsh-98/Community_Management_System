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
struct ExpectedVisitorResponse: Codable {
    let status: String!
    let visitor: [Exp_Visitor_Model]!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case visitor = "visitor"
        case message = "message"
    }
}
struct CommonResponse: Codable {
    let status: String!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
}
// MARK: - Visitor
struct Exp_Visitor_Model: Codable {
    let visitorType: String!
    let exitTime: String!
    let exitDate: String!
    let visitDate: String!
    let visitorStatus: String!
    let societyID: String!
    let vistorNumber: String!
    let visitorID: String!
    let visitorProfile: String!
    let userID: String!
    let visitorName: String!
    let unitID: String!
    let visitingReason: String!
    let visitorMobile: String!
    let visitTime: String!
    
    enum CodingKeys: String, CodingKey {
        case visitorType = "visitor_type"
        case exitTime = "exit_time"
        case exitDate = "exit_date"
        case visitDate = "visit_date"
        case visitorStatus = "visitor_status"
        case societyID = "society_id"
        case vistorNumber = "vistor_number"
        case visitorID = "visitor_id"
        case visitorProfile = "visitor_profile"
        case userID = "user_id"
        case visitorName = "visitor_name"
        case unitID = "unit_id"
        case visitingReason = "visiting_reason"
        case visitorMobile = "visitor_mobile"
        case visitTime = "visit_time"
    }
}
struct GalleryResponse: Codable {
    let status: String!
    let event: [EventModel]!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case event = "event"
        case message = "message"
    }
}

// MARK: - Event
struct EventModel: Codable {
    let eventTitle: String!
    let gallery: [GalleryModel]!
    
    enum CodingKeys: String, CodingKey {
        case eventTitle = "event_title"
        case gallery = "gallery"
    }
}

// MARK: - Gallery
struct GalleryModel: Codable {
    let galleryID: String!
    let galleryPhoto: String!
    let galleryTitle: String!
    let uploadDateTime: String!
    let societyID: String!
    let eventID: String!
    
    enum CodingKeys: String, CodingKey {
        case galleryID = "gallery_id"
        case galleryPhoto = "gallery_photo"
        case galleryTitle = "gallery_title"
        case uploadDateTime = "upload_date_time"
        case societyID = "society_id"
        case eventID = "event_id"
    }
}
struct DocumentResponse: Codable {
    let list: [DocumentModel]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
        case message = "message"
        case status = "status"
    }
}

// MARK: - List
struct DocumentModel: Codable {
    let shareWith: String!
    let documentID: String!
    let ducumentName: String!
    let documentTypeID: String!
    let ducumentDescription: String!
    let uploadeDate: String!
    let documentFile: String!
    
    enum CodingKeys: String, CodingKey {
        case shareWith = "share_with"
        case documentID = "document_id"
        case ducumentName = "ducument_name"
        case documentTypeID = "document_type_id"
        case ducumentDescription = "ducument_description"
        case uploadeDate = "uploade_date"
        case documentFile = "document_file"
    }
}
struct ElectionResponse: Codable {
    let election: [ElectionModel]!
    let status: String!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case election = "election"
        case status = "status"
        case message = "message"
    }
}

// MARK: - Election
struct ElectionModel: Codable {
    let electionDate: String!
    let electionName: String!
    let electionID: String!
    let electionStatus: String!
    let electionDescription: String!
    
    enum CodingKeys: String, CodingKey {
        case electionDate = "election_date"
        case electionName = "election_name"
        case electionID = "election_id"
        case electionStatus = "election_status"
        case electionDescription = "election_description"
    }
}
