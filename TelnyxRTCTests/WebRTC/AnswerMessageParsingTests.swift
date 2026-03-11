//
//  AnswerMessageParsingTests.swift
//  TelnyxRTCTests
//
//  Created by OpenHands Agent on 2026/03/05.
//  Copyright © 2026 Telnyx LLC. All rights reserved.
//

import XCTest
@testable import TelnyxRTC

/// Tests for parsing `telnyx_rtc.answer` events, specifically the `telnyx_call_control_id` field.
/// These tests verify backwards compatibility when the field is absent and proper parsing when present.
class AnswerMessageParsingTests: XCTestCase {
    
    /// Test parsing an ANSWER message that includes `telnyx_call_control_id`.
    /// This simulates the new backend behavior for outbound call flows (parked & bridged scenarios).
    func testAnswerMessageParsingWithCallControlId() {
        let jsonMessage = """
        {
            "jsonrpc": "2.0",
            "id": "test-id-123",
            "method": "telnyx_rtc.answer",
            "params": {
                "callID": "a2f31dd9-b9e6-403a-89d8-33767df14a56",
                "sdp": "v=0\\r\\no=- 123456 2 IN IP4 127.0.0.1\\r\\n",
                "telnyx_call_control_id": "v3:mXnwxhjqOG0oDW6V6m7pEYGFCibIeNnsHQwvvUbqyADtTXKaX6uK4g",
                "telnyx_leg_id": "04461b14-1885-11f1-87f2-02420aefba1f",
                "telnyx_session_id": "044613a8-1885-11f1-87c4-02420aefba1f"
            }
        }
        """
        
        let message = Message().decode(message: jsonMessage)
        
        XCTAssertNotNil(message, "Message should be decoded successfully")
        XCTAssertEqual(message?.method, Method.ANSWER, "Method should be ANSWER")
        
        guard let params = message?.params else {
            XCTFail("Params should not be nil")
            return
        }
        
        // Verify telnyx_call_control_id is present and correctly parsed
        let telnyxCallControlId = params["telnyx_call_control_id"] as? String
        XCTAssertNotNil(telnyxCallControlId, "telnyx_call_control_id should be present")
        XCTAssertEqual(telnyxCallControlId, "v3:mXnwxhjqOG0oDW6V6m7pEYGFCibIeNnsHQwvvUbqyADtTXKaX6uK4g",
                       "telnyx_call_control_id should match expected value")
        
        // Verify other Telnyx identifiers are also present
        let telnyxLegId = params["telnyx_leg_id"] as? String
        XCTAssertEqual(telnyxLegId, "04461b14-1885-11f1-87f2-02420aefba1f",
                       "telnyx_leg_id should match expected value")
        
        let telnyxSessionId = params["telnyx_session_id"] as? String
        XCTAssertEqual(telnyxSessionId, "044613a8-1885-11f1-87c4-02420aefba1f",
                       "telnyx_session_id should match expected value")
    }
    
    /// Test parsing an ANSWER message without `telnyx_call_control_id`.
    /// This ensures backwards compatibility with older backend versions that don't include this field.
    func testAnswerMessageParsingWithoutCallControlId() {
        let jsonMessage = """
        {
            "jsonrpc": "2.0",
            "id": "test-id-456",
            "method": "telnyx_rtc.answer",
            "params": {
                "callID": "a2f31dd9-b9e6-403a-89d8-33767df14a56",
                "sdp": "v=0\\r\\no=- 123456 2 IN IP4 127.0.0.1\\r\\n",
                "telnyx_leg_id": "04461b14-1885-11f1-87f2-02420aefba1f",
                "telnyx_session_id": "044613a8-1885-11f1-87c4-02420aefba1f"
            }
        }
        """
        
        let message = Message().decode(message: jsonMessage)
        
        XCTAssertNotNil(message, "Message should be decoded successfully")
        XCTAssertEqual(message?.method, Method.ANSWER, "Method should be ANSWER")
        
        guard let params = message?.params else {
            XCTFail("Params should not be nil")
            return
        }
        
        // Verify telnyx_call_control_id is nil (backwards compatibility)
        let telnyxCallControlId = params["telnyx_call_control_id"] as? String
        XCTAssertNil(telnyxCallControlId, "telnyx_call_control_id should be nil when not present")
        
        // Verify other Telnyx identifiers are still present
        let telnyxLegId = params["telnyx_leg_id"] as? String
        XCTAssertEqual(telnyxLegId, "04461b14-1885-11f1-87f2-02420aefba1f",
                       "telnyx_leg_id should still be present")
        
        let telnyxSessionId = params["telnyx_session_id"] as? String
        XCTAssertEqual(telnyxSessionId, "044613a8-1885-11f1-87c4-02420aefba1f",
                       "telnyx_session_id should still be present")
    }
    
    /// Test parsing an ANSWER message with an empty `telnyx_call_control_id`.
    /// This ensures the SDK handles edge cases gracefully by not storing empty strings.
    func testAnswerMessageParsingWithEmptyCallControlId() {
        let jsonMessage = """
        {
            "jsonrpc": "2.0",
            "id": "test-id-789",
            "method": "telnyx_rtc.answer",
            "params": {
                "callID": "a2f31dd9-b9e6-403a-89d8-33767df14a56",
                "sdp": "v=0\\r\\no=- 123456 2 IN IP4 127.0.0.1\\r\\n",
                "telnyx_call_control_id": "",
                "telnyx_leg_id": "04461b14-1885-11f1-87f2-02420aefba1f",
                "telnyx_session_id": "044613a8-1885-11f1-87c4-02420aefba1f"
            }
        }
        """
        
        let message = Message().decode(message: jsonMessage)
        
        XCTAssertNotNil(message, "Message should be decoded successfully")
        XCTAssertEqual(message?.method, Method.ANSWER, "Method should be ANSWER")
        
        guard let params = message?.params else {
            XCTFail("Params should not be nil")
            return
        }
        
        // Verify telnyx_call_control_id is present in params but empty
        let telnyxCallControlId = params["telnyx_call_control_id"] as? String
        XCTAssertNotNil(telnyxCallControlId, "telnyx_call_control_id should be present in params")
        XCTAssertEqual(telnyxCallControlId, "", "telnyx_call_control_id should be empty string in params")
        
        // Note: The Call class will NOT store empty strings - it checks !telnyxCallControlId.isEmpty
        // This test verifies the message parsing; the Call class behavior is tested separately
    }
    
    /// Test that the ANSWER method constant matches the expected value.
    func testAnswerMethodConstant() {
        XCTAssertEqual(Method.ANSWER.rawValue, "telnyx_rtc.answer",
                       "ANSWER method should have correct raw value")
    }
}
