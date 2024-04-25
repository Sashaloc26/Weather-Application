//
//  ViewController.swift
//  Weather
//
//  Created by Саша Тихонов on 06/12/2023.
//

import UIKit
import SnapKit

class BaseController: UIViewController {
    let blueEllipseImageView = UIImageView(image: UIImage(named: "blue_ellipse"))
    let redEllipseImageView = UIImageView(image: UIImage(named: "red_ellipse"))
    let orangeEllipseImageView = UIImageView(image: UIImage(named: "orange_ellipse"))
    let firstLine = UIImageView(image: UIImage(named: "first_line"))
    let secondLine = UIImageView(image: UIImage(named: "second_line"))
    let thirdLine = UIImageView(image: UIImage(named: "third_line"))
    let sunrise = UIImageView(image: UIImage(named: "sunrise"))
    let sunset = UIImageView(image: UIImage(named: "sunset"))
    
    let weatherApi = WeatherManager()
        
    let switchToSecondControllerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    
    let labelsData: [(String, String)] = [
        ("", "FeelsLike"),
        ("", "Humidity"),
        ("", "W,Speed"),
        ("", "Pressure")
    ]
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        return stack
        
    }()
    
    let sunsetTime: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.helveticaFont(with: 10)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let sunriseTime: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.helveticaFont(with: 10)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = Fonts.helveticaFont(with: 20)
        label.textAlignment = .center
        label.text = "Details"
        return label
    }()
    
    let nameOfCityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.helveticaFont(with: 40)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.helveticaFont(with: 60)
        label.textAlignment = .center
        return label
    }()
    
    let visibilityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = Fonts.helveticaFont(with: 30)
        label.textAlignment = .center
        return label
    }()
    
    var labelStack: [UILabel] = []
    
    let weatherView = UIView()
    
    var temperatureCollectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.black.cgColor
        
        setupViews()
        makeConstraints()
        configureLowerIndicators()
        presentSecondController()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isntLastCity()
    }
}

extension BaseController {
    func setupViews() {
        view.addSubview(blueEllipseImageView)
        view.addSubview(redEllipseImageView)
        view.addSubview(orangeEllipseImageView)
        view.addSubview(switchToSecondControllerButton)
        orangeEllipseImageView.addSubview(weatherView)
        weatherView.addSubview(firstLine)
        weatherView.addSubview(nameOfCityLabel)
        weatherView.addSubview(temperatureLabel)
        weatherView.addSubview(visibilityLabel)
        weatherView.addSubview(detailsLabel)
        weatherView.addSubview(secondLine)
        weatherView.addSubview(thirdLine)
        weatherView.addSubview(sunrise)
        weatherView.addSubview(sunset)
        weatherView.addSubview(sunriseTime)
        weatherView.addSubview(sunsetTime)
        weatherView.addSubview(stackView)
        
        
        
        switchToSecondControllerButton.addTarget(self, action: #selector(presentSecondController), for: .touchUpInside)
        
        temperatureCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        temperatureCollectionView.register(TemperatureAndTimeCell.self, forCellWithReuseIdentifier: "TemperatureAndTimeCell")
        temperatureCollectionView.dataSource = self
        temperatureCollectionView.delegate = self
        temperatureCollectionView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0)
                
        weatherView.addSubview(temperatureCollectionView)
        weatherView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.1)
        weatherView.layer.cornerRadius = 15
        
    }
    
    func makeConstraints() {
        switchToSecondControllerButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(weatherView.snp.trailing).offset(3)
            make.width.height.equalTo(40)
        }
        
        temperatureCollectionView.snp.makeConstraints { make in
            make.top.equalTo(visibilityLabel.snp.bottom).offset(view.bounds.height * 0.05)
            make.bottom.equalTo(firstLine.snp.top).offset(-10)
            make.leading.trailing.equalTo(weatherView).inset(20)
            make.height.equalTo(view.bounds.height * 0.17) 
        }
     
        stackView.snp.makeConstraints { make in
            make.top.equalTo(thirdLine.snp.bottom).offset(15)
            make.leading.trailing.equalTo(weatherView).inset(30)
        }
        
        sunsetTime.snp.makeConstraints { make in
            make.leading.equalTo(sunset)
            make.top.equalTo(sunset.snp.bottom)
        }
        
        sunriseTime.snp.makeConstraints { make in
            make.leading.equalTo(sunrise)
            make.top.equalTo(sunrise.snp.bottom)
        }
        sunrise.snp.makeConstraints { make in
            make.trailing.equalTo(thirdLine.snp.leading).offset(-10)
            make.bottom.equalTo(thirdLine.snp.top).offset(-10)
            make.width.height.equalTo(25)
        }
        
        sunset.snp.makeConstraints { make in
            make.leading.equalTo(thirdLine.snp.trailing).offset(10)
            make.bottom.equalTo(thirdLine.snp.top).offset(-10)
            make.width.height.equalTo(25)
        }
        
        thirdLine.snp.makeConstraints { make in
            make.centerX.equalTo(weatherView)
            make.top.equalTo(secondLine.snp.bottom)
            make.leading.trailing.equalTo(weatherView).inset(50)
        }
        
        secondLine.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(thirdLine)
            
        }
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLine.snp.bottom).offset(5)
            make.leading.equalTo(firstLine.snp.leading)
            
        }
        
        firstLine.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(weatherView).inset(10)
            make.centerX.equalTo(weatherView)
            make.centerY.equalTo(weatherView).offset(70)
        }
        
        visibilityLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(weatherView)
            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(nameOfCityLabel.snp.bottom).offset(22)
            make.centerX.equalTo(weatherView)
        }
        
        nameOfCityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherView).offset(30)
            make.centerX.equalTo(weatherView)
        }
        
        blueEllipseImageView.snp.makeConstraints { make in
            make.width.equalTo(190)
            make.height.equalTo(190)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.snp.leading).offset(-30)
        }
        
        redEllipseImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            
        }
        
        orangeEllipseImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(170)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(95)
            make.trailing.equalToSuperview()
        }
        
        weatherView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(38)
            make.bottom.equalTo(view.snp.bottom).offset(-57)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
    }
}

extension BaseController {
    func configureLowerIndicators() {
        for (labelText, subLabelText) in labelsData {
            let label: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.textAlignment = .center
                label.numberOfLines = 0
                label.font = Fonts.helveticaFont(with: 15)
                return label
            }()
            
            let subLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.textAlignment = .center
                label.numberOfLines = 0
                label.font = Fonts.helveticaFont(with: 13)
                return label
            }()
            
            label.text = labelText
            subLabel.text = subLabelText
            
            let verticalStackView = UIStackView(arrangedSubviews: [label, subLabel])
            verticalStackView.axis = .vertical
            verticalStackView.spacing = 5
            
            stackView.addArrangedSubview(verticalStackView)
            labelStack.append(contentsOf: [label, subLabel])
        }
    }
    
    func getCurrentTime(forIndex index: Int) -> String {
        let nowTime = Date()
        let oneHourInSeconds: TimeInterval = 3600
        let adjustedTime = nowTime.addingTimeInterval(TimeInterval(index) * oneHourInSeconds)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:00"
        return dateFormatter.string(from: adjustedTime)
    }
}

extension BaseController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = temperatureCollectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureAndTimeCell", for: indexPath) as? TemperatureAndTimeCell else {
            fatalError("Unable to dequeue TemperatureAndTimeCell")
        }
        
        let currentTime = getCurrentTime(forIndex: indexPath.item)
        
        if let hourlyTemperatures = weatherApi.hourlyTemperatures,
           let weatherDescriptions = weatherApi.hourlyDescriptions,
           let sunrise = weatherApi.sunriseApi,
           let sunset = weatherApi.sunsetApi {
            
            let temperature = hourlyTemperatures[indexPath.item]
            let formattedTemperature = String(format: "%.0f°C", round(temperature - 273.15))
            
            let weatherDescription = weatherDescriptions[indexPath.item]
            
            if let weatherImage = imageForWeather(description: weatherDescription, temperature: temperature, sunrise: sunrise, sunset: sunset) {
                cell.configure(withTitle: currentTime, temperatureTitle: formattedTemperature, image: weatherImage)
            } else {
                cell.configure(withTitle: currentTime, temperatureTitle: formattedTemperature, image: nil)
            }
            print("Current Time: \(currentTime), Temperature: \(formattedTemperature), Weather Description: \(weatherDescription)")
            
        } else {
            cell.configure(withTitle: currentTime, temperatureTitle: "N/A", image: nil)
        }
        
        return cell
    }
    
    private func imageForWeather(description: String, temperature: Double, sunrise: Int?, sunset: Int?) -> UIImage? {
        var imageName: String = ""
        
        let currentTime = Int(Date().timeIntervalSince1970)
        
        switch description {
        case "Snow":
            imageName = "snow"
        case "Drizzle", "Rain":
            imageName = "rain"
        case "Sunny":
            fallthrough
        case "Clouds":
            imageName = isNight(currentTime: currentTime, sunrise: sunrise, sunset: sunset) ? "nightcloud" : "sunnycloud"
        default:
            imageName = isNight(currentTime: currentTime, sunrise: sunrise, sunset: sunset) ? "moon" : "cloud"
        }
        
        return UIImage(named: imageName)
    }
    
    private func isNight(currentTime: Int, sunrise: Int?, sunset: Int?) -> Bool {
        if let sunrise = sunrise, let sunset = sunset {
            return currentTime < sunrise || currentTime > sunset
        }
        
        return false
    }
}

extension BaseController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 45
        let cellCount: CGFloat = 5
        let cellSpacing: CGFloat = collectionView.bounds.width * 0.06
        let collectionViewWidth = collectionView.bounds.width

        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)

        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.145, height: collectionView.bounds.height)
    }
}

extension BaseController: UICollectionViewDelegate {
    
}

extension BaseController {
    @objc func presentSecondController() {
        
        let secondController = ChoiceCityController()
        
        if let lastChoicedCityEntity = CoreDataManager.shared.fetchLastChoicedCity() {
            if let lastChoicedCity = lastChoicedCityEntity.lastChoicedCity {
                self.handleWeather(forCity: lastChoicedCity)
            }
        }
        
        secondController.didSelectCityClosure = { [weak self] selectedCity in
            self?.handleWeather(forCity: selectedCity)
        }
        
        secondController.didSelectSearchedCityClosure = { [weak self] searchedCity in
            self?.handleWeather(forCity: searchedCity)
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(secondController, animated: true, completion: nil)
    }
    
    func isntLastCity() {
        let secondController = ChoiceCityController()

        if let lastChoicedCityEntity = CoreDataManager.shared.fetchLastChoicedCity(),
           let lastChoicedCity = lastChoicedCityEntity.lastChoicedCity {
            handleWeather(forCity: lastChoicedCity)
        } else {
            present(secondController, animated: true, completion: nil)
        }
    }
}

extension BaseController {
    private func handleWeather(forCity city: String) {
        self.nameOfCityLabel.text = city
        
        self.weatherApi.getWeather(in: city) { [weak self] in
            DispatchQueue.main.async {
                if let temperature = self?.weatherApi.temperature {
                    self?.temperatureLabel.text = "\(temperature)"
                }
                
                if let visibility = self?.weatherApi.weatherDescription {
                    self?.visibilityLabel.text = "\(visibility)"
                }
                
                if let feelsLike = self?.weatherApi.feelsLike {
                    if let firstLabel = self?.labelStack.first {
                        firstLabel.text = "\(feelsLike)"
                    }
                }
                
                if let humidity = self?.weatherApi.humidityProperty {
                    if self?.labelStack.count ?? 0 >= 7 {
                        let secondLabel = self?.labelStack[2]
                        secondLabel?.text = "\(humidity)%"
                    }
                }
                
                if let windSpeed = self?.weatherApi.windSpeedProperty {
                    if self?.labelStack.count ?? 0 >= 7 {
                        let secondLabel = self?.labelStack[4]
                        secondLabel?.text = "\(windSpeed)m/s"
                    }
                }
                
                if let pressure = self?.weatherApi.pressureProperty {
                    if self?.labelStack.count ?? 0 >= 7 {
                        let secondLabel = self?.labelStack[6]
                        secondLabel?.text = "\(pressure)hPa"
                    }
                }
                
                if let timeStampSunrise = self?.weatherApi.sunriseApi {
                    let dateFormatter = DateFormatter()
                    let date = Date(timeIntervalSince1970: TimeInterval(timeStampSunrise))
                    dateFormatter.dateFormat = "HH:mm"
                    let formattedSunrise = dateFormatter.string(from: date)
                    self?.sunriseTime.text = "\(formattedSunrise)"
                }
                
                if let timeStampSunset = self?.weatherApi.sunsetApi {
                    let dateFormatter = DateFormatter()
                    let date = Date(timeIntervalSince1970: TimeInterval(timeStampSunset))
                    dateFormatter.dateFormat = "HH:mm"
                    let formattedSunset = dateFormatter.string(from: date)
                    self?.sunsetTime.text = "\(formattedSunset)"
                }            }
        }
        
        self.weatherApi.getHourlyForecast(in: city) {
            DispatchQueue.main.async {
                self.temperatureCollectionView.reloadData()
            }
        }
    }
}


