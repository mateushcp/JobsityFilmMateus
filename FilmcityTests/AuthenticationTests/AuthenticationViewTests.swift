//
//  AuthenticationViewTests.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 24/06/25.
//

import XCTest
@testable import Filmcity

class AuthenticationViewTests: XCTestCase {
  
  public class DummyDelegate: AuthenticationViewDelegate {
    var tappedBiometric = false
    var tappedPin: String?
    
    func authenticationViewDidTapBiometric(_ view: AuthenticationView) {
      tappedBiometric = true
    }
    func authenticationView(_ view: AuthenticationView, didEnterPin pin: String) {
      tappedPin = pin
    }
  }
  
  var view: AuthenticationView!
  var delegate: DummyDelegate!
  
  override func setUp() {
    super.setUp()
    view = AuthenticationView()
    delegate = DummyDelegate()
    view.delegate = delegate
    view.frame = CGRect(x: 0, y: 0, width: 343, height: 600)
    view.layoutIfNeeded()
  }
  
  override func tearDown() {
    view = nil
    delegate = nil
    super.tearDown()
  }
  
  func testTapBiometricButton_triggersDelegate() {
    let faceButtons = view.subviews.compactMap { $0 as? UIButton }
      .filter { $0.currentImage != nil && $0.currentTitle == nil }
    XCTAssertFalse(faceButtons.isEmpty, "Não achei o botão de FaceID")
    let faceButton = faceButtons.first!
    
    faceButton.sendActions(for: .touchUpInside)
    XCTAssertTrue(delegate.tappedBiometric)
  }
  
  func testTapSubmitPinButton_triggersDelegateWithPin() {
    let textField = view.subviews.compactMap { $0 as? UITextField }.first!
    textField.text = "9999"
    
    let submitButtons = view.subviews.compactMap { $0 as? UIButton }
      .filter { $0.currentTitle == "Login with PIN" }
    XCTAssertFalse(submitButtons.isEmpty, "Não achei o botão Entrar com PIN")
    let submit = submitButtons.first!
    
    submit.sendActions(for: .touchUpInside)
    XCTAssertEqual(delegate.tappedPin, "9999")
  }

}
