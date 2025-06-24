//
//  AuthenticationViewControllerTests.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 24/06/25.
//

import XCTest
@testable import Filmcity

class AuthenticationViewControllerTests: XCTestCase {
  
  var sut: AuthenticationViewController!
  var window: UIWindow!
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    sut = AuthenticationViewController()
    window.rootViewController = sut
    window.makeKeyAndVisible()
    _ = sut.view
  }
  
  override func tearDown() {
    sut = nil
    window = nil
    super.tearDown()
  }
  
  func testTapSubmitPin_showsAlertOnFailure() {
    let textField = sut.authView.subviews.compactMap { $0 as? UITextField }.first!
    textField.text = "0000"
    let submitButton = sut.authView.subviews.compactMap { $0 as? UIButton }
      .first { $0.currentTitle == "Login with PIN" }!
    
    submitButton.sendActions(for: .touchUpInside)
    
    let presented = sut.presentedViewController as? UIAlertController
    XCTAssertNotNil(presented)
    XCTAssertEqual(presented?.title, "Erro")
    XCTAssertEqual(presented?.message, "Autenticação falhou. Tente novamente.")
  }
  
  func testOnSuccess_navigationClosureIsCalled() {
    var called = false
    sut.onSuccess = { called = true }
    sut.viewModel.onAuthenticationResult?(true)
    XCTAssertTrue(called)
  }
}
