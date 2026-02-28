//
//  InformationTests.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/20/25.
//

import Testing
@testable import ByeBoo_iOS

struct NicknameTests {
    
    private let checkValidNicknameUseCase = DefaultCheckValidNicknameUseCase()
    
    @Test(
        "🏁 닉네임이 2자 미만이거나 5자를 초과할 때 ✅ false",
        arguments: ["a", "abcdef"]
    )
    func isNicknameLessThan2OrGreaterThan5__false(nickname: String) async {
        let result = checkValidNicknameUseCase.isValidRegulation(nickname: nickname)
        
        #expect(result == false)
    }
    
    @Test(
        "🏁 한글 자음 및 모음을 단독으로 사용할 때 ✅ false",
        arguments: ["고ㅜ", "ㄱ우"]
    )
    func isNicknamUsingKoreanConsonantsOrVowelsAlone__false(nickname: String) async {
        let result = checkValidNicknameUseCase.isValidRegulation(nickname: nickname)
        
        #expect(result == false)
    }
    
    @Test("🏁 한글 자음과 모음이 혼합되어있지만 불완전한 글자일 때 ✅ false")
    func isNicknamUsingIncompleteKorean__false() async {
        let result = checkValidNicknameUseCase.isValidRegulation(nickname: "ㄱㅗ우")
        
        #expect(result == false)
    }
    
    @Test("🏁 닉네임에 특수문자가 포함되어있을 때 ✅ false")
    func isNicknameContainsSpecialCharacter__false() async {
        let result = checkValidNicknameUseCase.isValidRegulation(nickname: "가나디@")

        #expect(result == false)
    }
    
    @Test(
        "🏁 닉네임에 공백이 포함되어있을 때 ✅ false",
        arguments: [" 가나디", "가 나디", "가나디 "]
    )
    func isNicknamContainsSpace__false(nickname: String) async {
        let result = checkValidNicknameUseCase.isValidRegulation(nickname: nickname)
        
        #expect(result == false)
    }
    
    @Test(
        "🏁 한글, 영어 대소문자, 숫자만 2자 이상 5자 이하로 입력한 경우 ✅ true",
        arguments: ["허승준", "123", "Atom", "허1a"]
    )
    func isValidNickname__true(nickname: String) async {
        let result = checkValidNicknameUseCase.execute(nickname: nickname)
        
        #expect(result == true)
    }
}
