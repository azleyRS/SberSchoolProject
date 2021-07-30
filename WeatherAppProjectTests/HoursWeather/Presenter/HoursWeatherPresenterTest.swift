//
//  HoursWeatherPresenterTest.swift
//  WeatherAppProjectTests
//
//  Created by Руслан Хомяков on 30.07.2021.
//

import XCTest
@testable import WeatherAppProject

class HoursWeatherPresenterTest: XCTestCase {
    
    var networkManager: NetworkManagerProtocol!
    var persistantService: PersistentServiceMock!
    var delegate: HoursPresenterDelegateMock!
    
    var sut : HoursPresenter!

    override func setUpWithError() throws {
        delegate = HoursPresenterDelegateMock()
        networkManager = NetworkManagerMock()
        persistantService = PersistentServiceMock()
        sut = HoursPresenter(networkManager: networkManager, persistentService: persistantService)
        sut.setViewDelegate(delegate: delegate)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_loadHoursWeather_success() throws {
        // arrange
        
        // act
        sut.loadHoursWeather(lat: "-122.4064", lon: "37.7858")
        
        // assert
        
        XCTAssertTrue(delegate.wasShowLocalHoursWeatherCalled)
        XCTAssertTrue(delegate.wasSetTitleCalled(with: "San Francisco"))
    }
    
    func test_loadHoursCityWeather_success() throws {
        // arrange
        
        // act
        sut.loadHoursCityWeather(city: "San Francisco")
        
        // assert
        
        XCTAssertTrue(delegate.wasShowLocalHoursWeatherCalled)
        XCTAssertTrue(delegate.wasSetTitleCalled(with: "San Francisco"))
    }
    
    func test_saveWeather() throws {
        // arrange
        
        // act
        sut.loadHoursCityWeather(city: "San Francisco")
        sut.saveWeather()
        
        // assert
        XCTAssertTrue(persistantService.wasWeatherListSaved(with: createExpectedListToSave()))
    }

}

class HoursPresenterDelegateMock : HoursPresenterDelegateProtocol {
    
    var wasShowLocalHoursWeatherCalled = false
    private var cityName = ""
    
    func wasSetTitleCalled(with name: String) -> Bool {
        return cityName == name
    }
    
    func showLocalHoursWeather() {
        wasShowLocalHoursWeatherCalled = true
    }
    
    func setTitle(title: String) {
        cityName = title
    }
    
    
}

class PersistentServiceMock: PersistentServiceProtocol {
    
    private var resultList : [HoursCellModel]?
    
    func wasWeatherListSaved(with expectedList : [HoursCellModel]) -> Bool {
        return resultList == expectedList
    }
    
    func saveWeatherList(weatherList: [HoursCellModel]) {
        resultList = weatherList
    }
}

private class NetworkManagerMock : NetworkManagerProtocol {
    
    func getCurrentWeather(weatherType: WeatherType, completion: @escaping (Result<CurrentWeather, ErrorMessage>) -> Void) {
        //
    }
    
    func getFiveDaysWeather(weatherType: WeatherType, completion: @escaping (Result<FiveDaysWeatherModel, ErrorMessage>) -> Void) {
        switch weatherType {
        case .local(latitude: "-122.4064", longitude: "37.7858"):
            completion(.success(createExpectedNetworkResponce()))
        case .city(city: "San Francisco"):
            completion(.success(createExpectedNetworkResponce()))
        default:
            completion(.failure(.invalidData))
        }
    }
}

func createExpectedNetworkResponce() -> FiveDaysWeatherModel {
   return FiveDaysWeatherModel(cod: "200",
                         message: 0,
                         cnt: 40,
                         list: [
                            List(dt: 1627668000,
                                 main: MainClass(temp: 292.87,
                                                 feelsLike: 293.12,
                                                 tempMin: 291.66,
                                                 tempMax: 292.87,
                                                 pressure: 1014,
                                                 seaLevel: 1014,
                                                 grndLevel: 1012,
                                                 humidity: 85,
                                                 tempKf: 1.21),
                                 weather: [
                                    FiveDaysWeather(id: 804,
                                                    main: "Clouds",
                                                    weatherDescription: "overcast clouds",
                                                    icon: "04d")
                                 ],
                                 clouds: FiveDaysClouds(all: 90),
                                 wind: FiveDaysWind(speed: 3.9,
                                                    deg: 247,
                                                    gust: 4.58),
                                 visibility: 10000,
                                 pop: 0.0,
                                 sys: FiveDaysSys(pod: WeatherAppProject.Pod.d),
                                 dtTxt: "2021-07-30 18:00:00",
                                 rain: nil)
                         ],
                         city: City(id: 5391959,
                                    name: "San Francisco",
                                    coord: FiveDaysCoord(lat: 37.7858,
                                                         lon: -122.4064),
                                    country: "US",
                                    population: 805235,
                                    timezone: -25200,
                                    sunrise: 1627650699,
                                    sunset: 1627701615))

}

func createExpectedListToSave() -> [HoursCellModel] {
    return [HoursCellModel(city: "San Francisco", time: "7/30/21, 9:00 PM", temperature: "20°C", description: "overcast clouds", humidity: "85", wind: "3.9", imageId: "04d")]
}

extension HoursCellModel : Equatable {
    public static func == (lhs: HoursCellModel, rhs: HoursCellModel) -> Bool {
        return lhs.city == rhs.city
            && lhs.description == rhs.description
            && lhs.humidity == rhs.humidity
            && lhs.imageId == rhs.imageId
            && lhs.temperature == rhs.temperature
            && lhs.time == rhs.time
            && lhs.wind == rhs.wind
    }
}
