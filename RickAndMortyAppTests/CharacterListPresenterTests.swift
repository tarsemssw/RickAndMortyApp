//
//  CharacterListPresenterTests.swift
//  RickAndMortyAppTests
//
//  Created by Tarsem Singh on 16/11/22.
//

import XCTest
@testable import RickAndMortyApp

class CharacterListPresenterTests: XCTestCase {

    var mockAPIClient: MockAPIClient!
    var mockImageLoader: MockImageLoader!
    var mockDisplay: MockCharacterListDisplay!
    var mockCoordinator: MockCharacterListCoordinator!
    var presenter: CharacterListPresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDisplay = MockCharacterListDisplay()
        mockCoordinator = MockCharacterListCoordinator()
        mockAPIClient = MockAPIClient()
        mockImageLoader = MockImageLoader()
        presenter = CharacterListPresenter(
            display: mockDisplay,
            coordinator: mockCoordinator,
            apiClient: mockAPIClient,
            imageLoader: mockImageLoader
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        presenter = nil
        mockDisplay = nil
        mockCoordinator = nil
        mockAPIClient = nil
    }

    // MARK:- Tests

    func testViewDidLoad() throws {
        // When
        presenter.viewDidLoad()

        //Then
        XCTAssertEqual(mockDisplay.showScreenTitleCount, 1)
        XCTAssertEqual(mockDisplay.showScreenTitle, "Characters")

        XCTAssertEqual(mockDisplay.showIndicatorCount, 1)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, true)

        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)
        XCTAssertTrue(mockAPIClient.fetchDecodedDataCompletionHandler is ((Result<APIResponse, APIError>) -> ()))
    }

    func testFetchCharacterListSuccess() throws {
        // Given
        let characterList = APIResponse(results: [Character(
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

        )])


        //When
        presenter.viewDidLoad()
        let handler = (mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ()))
        handler?(.success(characterList))

        //Then
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)

        XCTAssertEqual(mockDisplay.showIndicatorCount, 2)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, false)

        XCTAssertEqual(mockDisplay.showListCount, 1)
        XCTAssertEqual(mockDisplay.showList?.count, 1)
        XCTAssertEqual(mockDisplay.showList?[0].character.name, "Rick Sanchez")
        XCTAssertEqual(mockDisplay.showList?[0].character.gender, "Male")

        // When
        let cellItem = mockDisplay.showList?[0]
        cellItem?.loadImage(handler: { _ in })

        // Then
        XCTAssertEqual(mockImageLoader.loadCallCount, 1)
        XCTAssertEqual(mockImageLoader.loadURLPath, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
    }

    func testLoadImage() throws {
        // Given
        let characterList = APIResponse(results: [Character(
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

        )])
        presenter.viewDidLoad()
        let handler = (mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ()))
        handler?(.success(characterList))
        let cellItem = mockDisplay.showList?[0]
        var receivedImage: UIImage?
        cellItem?.loadImage(handler: { (image) in
            receivedImage = image
        })

        // When
        let imageData = #imageLiteral(resourceName: "placeholder").pngData()
        mockImageLoader.loadCompletionHandler?(imageData!)

        // Then
        XCTAssertEqual(receivedImage?.pngData(), imageData)
    }

    func testCancelImage() throws {
        // Given
        let characterList = APIResponse(results: [Character(
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

        )])
        presenter.viewDidLoad()
        let handler = (mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ()))
        handler?(.success(characterList))

        // When
        let cellItem = mockDisplay.showList?[0]
        cellItem?.cancel()

        // Then
        XCTAssertEqual(mockImageLoader.cancelCallCount, 1)
        XCTAssertEqual(mockImageLoader.cancelURLPath, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
    }

    func testFetchCharacterListSuccessEmptyList() throws {
        // Given
        let characterList: APIResponse = APIResponse(results: [])

        //When
        presenter.viewDidLoad()
        let handler = mockAPIClient.fetchDecodedDataCompletionHandler as! ((Result<APIResponse, APIError>) -> ())
        handler(.success(characterList))

        //Then
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)

        XCTAssertEqual(mockDisplay.showIndicatorCount, 2)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, false)

        XCTAssertEqual(mockDisplay.showNoDataViewCount, 1)
        XCTAssertEqual(mockDisplay.showNoDataViewMessage, "Sorry! \n\n Could not find any characters. Please try again later.")
    }

    func testFetchCharacterListFailure() throws {
        //When
        presenter.viewDidLoad()
        let handler = mockAPIClient.fetchDecodedDataCompletionHandler as? ((Result<APIResponse, APIError>) -> ())
        handler?(.failure(APIError.response))

        //Then
        XCTAssertEqual(mockAPIClient.fetchDecodedDataCount, 1)

        XCTAssertEqual(mockDisplay.showIndicatorCount, 2)
        XCTAssertEqual(mockDisplay.shouldShowIndicator, false)

        XCTAssertEqual(mockDisplay.showNoDataViewCount, 1)
        XCTAssertEqual(mockDisplay.showNoDataViewMessage, "Oops! \n\n There is some issue in loading characters. Please try again later.")
    }
}

// MARK:- Mocks

final class MockCharacterListDisplay: CharacterListDisplaying {

    private(set) var showScreenTitleCount = 0
    private(set) var showScreenTitle: String?

    private(set) var showIndicatorCount = 0
    private(set) var shouldShowIndicator: Bool?

    private(set) var showNoDataViewCount = 0
    private(set) var showNoDataViewMessage: String?

    private(set) var showListCount = 0
    private(set) var showList: [CharacterCellItem]?

    func show(screenTitle: String) {
        showScreenTitleCount += 1
        showScreenTitle = screenTitle
    }

    func showIndicator(_ shouldShow: Bool) {
        showIndicatorCount += 1
        shouldShowIndicator = shouldShow
    }

    func showNoDataView(with message: String) {
        showNoDataViewCount += 1
        showNoDataViewMessage = message
    }

    func show(list: [CharacterCellItem]) {
        showListCount += 1
        showList = list
    }
}
final class MockCharacterListCoordinator: CharacterListCoordinating {
    
    private(set) var showSelectionCount = 0
    private(set) var showCharacter: Character?
    
    func didSelectCharacter(character: RickAndMortyApp.Character) {
        showSelectionCount += 1
        showCharacter = character
    }
}

final class MockImageLoader: ImageLoading{
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

