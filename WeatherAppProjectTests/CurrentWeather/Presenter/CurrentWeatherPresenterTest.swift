//
//  CurrentWeatherPresenterTest.swift
//  WeatherAppProjectTests
//
//  Created by Руслан Хомяков on 30.07.2021.
//

import XCTest
@testable import WeatherAppProject

class CurrentWeatherPresenterTest: XCTestCase {
    
    var networkManager: NetworkManagerProtocol!
    var backgroundImageService: CurrentWeatherBackgroundImageServiceProtocol!
    var sut: CurrentWeatherPresenter!
    var delegate: CurrentWeatherPresenterDelegateMock!

    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        backgroundImageService = CurrentWeatherBackgroundImageServiceMock()
        delegate = CurrentWeatherPresenterDelegateMock()
        sut = CurrentWeatherPresenter(networkManager: networkManager, backgroundImageService: backgroundImageService)
        sut.setViewDelegate(delegate: delegate)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_loadLocalWeather_success() throws {
        // arrange
        
        // act
        sut.loadLocalWeather(latitude: "-122.4064", longitude: "37.7858")
        
        // assert
        XCTAssertTrue(delegate.wasActivityIndicatorEnabled)
        XCTAssertTrue(delegate.wasActivityIndicatorDisabled)
        XCTAssertTrue(delegate.wasShowLocalWeatherCalled(with: createExpectedResultModel()))
        XCTAssertTrue(delegate.wasShowWeatherIconCalled(with: createExpectedIconUrl()))
    }
    
    func test_loadLocalWeather_error() throws {
        // arrange
        
        // act
        sut.loadLocalWeather(latitude: "random", longitude: "random")
        
        // assert
        XCTAssertTrue(delegate.wasActivityIndicatorEnabled)
        XCTAssertTrue(delegate.wasActivityIndicatorDisabled)
        XCTAssertFalse(delegate.wasShowLocalWeatherCalled(with: createExpectedResultModel()))
        XCTAssertFalse(delegate.wasShowWeatherIconCalled(with: createExpectedIconUrl()))
        XCTAssertTrue(delegate.wasAlertCalled(with: .invalidData))
    }
    
    func test_AssertPresenterDelegateIsCorrect_true() throws {
        // arrange
        let randomDelegate = CurrentWeatherPresenterDelegateMock()
        
        // act
        sut.loadLocalWeather(latitude: "-122.4064", longitude: "37.7858")
        
        // assert
        XCTAssertFalse(randomDelegate.wasShowLocalWeatherCalled(with: createExpectedResultModel()))
        XCTAssertTrue(delegate.wasShowLocalWeatherCalled(with: createExpectedResultModel()))
    }
    
    
    func test_getCurrentWeather_success() throws {
        // arrange
        
        // act
        sut.getCurrentWeather(city: "San Francisco")
        
        // assert
        XCTAssertTrue(delegate.wasShowLocalWeatherCalled(with: createExpectedResultModel()))
        XCTAssertTrue(delegate.wasShowWeatherIconCalled(with: createExpectedIconUrl()))
    }
    
    func test_handleBackgroundImage_disabled() throws {
        // arrange
        
        // act
        sut.handleBackgroundImage()
        
        // assert
        XCTAssertTrue(delegate.wasChangeBackgroundImageCalled(with: "weatherBackground"))
    }
    
    func test_switchToggle() throws {
        // arrange
        
        // act
        sut.handleTogglePosition()
        
        // assert
        XCTAssertTrue(delegate.wasSwitchChanged)
    }
}

private class NetworkManagerMock : NetworkManagerProtocol {
    
    func getCurrentWeather(weatherType: WeatherType, completion: @escaping (Result<CurrentWeather, ErrorMessage>) -> Void) {
        switch weatherType {
        case .local(latitude: "-122.4064", longitude: "37.7858"):
            completion(.success(createExpectedNetworkResponce()))
        case .city(city: "San Francisco"):
            completion(.success(createExpectedNetworkResponce()))
        default:
            completion(.failure(.invalidData))
        }
    }
    
    func getFiveDaysWeather(weatherType: WeatherType, completion: @escaping (Result<FiveDaysWeatherModel, ErrorMessage>) -> Void) {
        //
    }
}

class CurrentWeatherPresenterDelegateMock : CurrentWeatherPresenterDelegateProtocol {
    
    private var resultModel: CurrentWeatherPresentationModel?
    private var resultErrorMessage: ErrorMessage?
    private var resultIconUrl: URL?
    var wasActivityIndicatorEnabled = false
    var wasActivityIndicatorDisabled = false
    private var backfroundName = ""
    var wasSwitchChanged = false
    
    func wasShowLocalWeatherCalled(with expectedResultModel: CurrentWeatherPresentationModel) -> Bool {
        return resultModel == expectedResultModel
    }
    
    func wasAlertCalled(with expectedErrorMessage: ErrorMessage) -> Bool {
        return resultErrorMessage == expectedErrorMessage
    }
    
    func wasShowWeatherIconCalled(with expectedIconUrl: URL) -> Bool {
        return resultIconUrl == expectedIconUrl
    }
    
    func wasChangeBackgroundImageCalled(with expectedName: String) -> Bool {
        return backfroundName == expectedName
    }
    
    func showLocalWeather(presentationModel: CurrentWeatherPresentationModel) {
        resultModel = presentationModel
    }
    
    func showWeatherIcon(url: URL) {
        resultIconUrl = url
    }
    
    func showAlert(title: String) {
        resultErrorMessage = ErrorMessage.init(rawValue: title)
    }
    
    func startActivityIndicator() {
        wasActivityIndicatorEnabled = true
    }
    
    func stopActivityIndicator() {
        wasActivityIndicatorDisabled = true
    }
    
    func changeBackgroundImage(name: String) {
        backfroundName = name
    }
    
    func setSwitch(isEnabled: Bool) {
        wasSwitchChanged = true
    }
}

private class CurrentWeatherBackgroundImageServiceMock : CurrentWeatherBackgroundImageServiceProtocol {
    
    var isEnabled: Bool = false
    
    func getCurrentWeatherBackground() -> String {
        return isEnabled ? "weatherBackground2" : "weatherBackground"
    }
}

func createExpectedIconUrl() -> URL {
    return URL(string: "https://openweathermap.org/img/wn/04d@2x.png")!
}

func createExpectedNetworkResponce() -> CurrentWeather {
    return CurrentWeather(coord: Coord(lon: -122.4064, lat: 37.7858),
                          weather: [Weather(id: 804,
                                            main: "Clouds",
                                            weatherDescription: "overcast clouds",
                                            icon: "04d")],
                          base: "stations",
                          main: Main(temp: 289.58,
                                     pressure: 1013,
                                     humidity: 92,
                                     tempMin: 285.59,
                                     tempMax: 298.6),
                          visibility: 10000,
                          wind: Wind(speed: 0.45,
                                     deg: 254),
                          clouds: Clouds(all: 90),
                          dt: 1627660048,
                          sys: Sys(type: 2,
                                   id: 2017837,
                                   message: nil,
                                   country: "US",
                                   sunrise: 1627650699,
                                   sunset: 1627701615),
                          id: 5391959,
                          name: "San Francisco",
                          cod: 200)
}

func createExpectedResultModel() -> CurrentWeatherPresentationModel {
    return WeatherAppProject.CurrentWeatherPresentationModel(city: "San Francisco",
                                                             temperature: "16°C",
                                                             date: "July 30, 2021 at 6:47:28 PM")
}

extension CurrentWeatherPresentationModel : Equatable {
    public static func == (lhs: CurrentWeatherPresentationModel, rhs: CurrentWeatherPresentationModel) -> Bool {
        return lhs.city == rhs.city && lhs.date == rhs.date && lhs.temperature == rhs.temperature
    }
}
