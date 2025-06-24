//
//  AuthenticationViewModelTests.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 24/06/25.
//

import XCTest
@testable import Filmcity

class AuthenticationViewModelTests: XCTestCase {
  
  var viewModel: AuthenticationViewModel!
  var result: Bool?
  
  override func setUp() {
    super.setUp()
    viewModel = AuthenticationViewModel()
    result = nil
  }
  
  override func tearDown() {
    viewModel = nil
    result = nil
    super.tearDown()
  }
  
  func testAuthenticateWithPin_callsResultTrueWhenPinMatches() {
    // Salva um PIN conhecido no Keychain
    KeychainHelper.standard.savePin("1234")
    
    let exp = expectation(description: "onAuthenticationResult called")
    viewModel.onAuthenticationResult = { success in
      self.result = success
      exp.fulfill()
    }
    
    // Chama com o PIN correto
    viewModel.authenticate(withPin: "1234")
    waitForExpectations(timeout: 1)
    
    XCTAssertEqual(result, true)
  }
  
  func testAuthenticateWithPin_callsResultFalseWhenPinDoesNotMatch() {
    KeychainHelper.standard.savePin("1234")
    
    let exp = expectation(description: "onAuthenticationResult called")
    viewModel.onAuthenticationResult = { success in
      self.result = success
      exp.fulfill()
    }
    
    viewModel.authenticate(withPin: "0000")
    waitForExpectations(timeout: 1)
    
    XCTAssertEqual(result, false)
  }
  
}
