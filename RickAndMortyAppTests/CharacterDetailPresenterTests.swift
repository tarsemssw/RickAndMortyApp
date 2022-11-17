//
//  CharacterDetailPresenterTests.swift
//  RickAndMortyAppTests
//
//  Created by Tarsem Singh on 17/11/22.
//

import XCTest
@testable import RickAndMortyApp

class CharacterDetailPresenterTests: XCTestCase {

    var mockImageLoader: MockCharacterDetailImageLoader!
    var mockDisplay: MockCharacterDetailDisplay!
    var mockCoordinator: MockCharacterDetailCoordinator!
    var presenter: CharacterDetailPresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDisplay = MockCharacterDetailDisplay()
        mockCoordinator = MockCharacterDetailCoordinator()
        mockImageLoader = MockCharacterDetailImageLoader()
        presenter = CharacterDetailPresenter(
            display: mockDisplay,
            coordinator: mockCoordinator,
            imageLoader: mockImageLoader
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        presenter = nil
        mockDisplay = nil
        mockCoordinator = nil
    }

    // MARK:- Tests

    func testViewDidLoad() throws {
        // Given
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            location: Location(
                name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"
            ),
            episode: [ "https://rickandmortyapi.com/api/episode/1",
                       "https://rickandmortyapi.com/api/episode/2",
                       "https://rickandmortyapi.com/api/episode/3",
                       "https://rickandmortyapi.com/api/episode/4"]

        )
        // When
        presenter.viewDidLoad(character: character)
    }


    func testLoadImage() throws {
        // Given
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            location: Location(
                name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"
            ),
            episode: [ "https://rickandmortyapi.com/api/episode/1",
                       "https://rickandmortyapi.com/api/episode/2",
                       "https://rickandmortyapi.com/api/episode/3",
                       "https://rickandmortyapi.com/api/episode/4"]

        )
        presenter.viewDidLoad(character: character)
        var receivedImage: UIImage?
        presenter.loadImage(url: character.image) { image in
            receivedImage = image
        }
        
        // When
        let imageData = #imageLiteral(resourceName: "placeholder").pngData()
        mockImageLoader.loadCompletionHandler?(imageData!)

        // Then
        XCTAssertEqual(receivedImage?.pngData(), imageData)
    }

   
}

// MARK:- Mocks

final class MockCharacterDetailDisplay: CharacterDetailDisplaying {
    
    private(set) var showImageCount = 0
    private(set) var image: UIImage?
    
    private(set) var showCharacterCount = 0
    private(set) var character: Character?
    
    func show(image: UIImage) {
        showImageCount += 1
        self.image = image
    }
    
    func show(character: RickAndMortyApp.Character) {
        showCharacterCount += 1
        self.character = character
    }
    
}
final class MockCharacterDetailCoordinator: CharacterDetailCoordinating {

    private(set) var showSelectionCount = 0
    private(set) var showCharacter: CharacterCellItem?
    
    func didSelectCharacter(characterCellItem: RickAndMortyApp.CharacterCellItem) {
        showSelectionCount += 1
        showCharacter = characterCellItem
    }
}

final class MockCharacterDetailImageLoader: ImageLoading{
    private(set) var loadCallCount: Int = 0
    private(set) var loadURLPath: String?
    private(set) var loadCompletionHandler: ((Data) -> Void)?

    private(set) var cancelCallCount: Int = 0
    private(set) var cancelURLPath: String?

    func load(urlPath: String, completionHandler: @escaping ((Data) -> Void)) {
        loadCallCount += 1
        loadURLPath = urlPath
        loadCompletionHandler = completionHandler
    }

    func cancel(urlPath: String) {
        cancelCallCount += 1
        cancelURLPath = urlPath
    }
}

