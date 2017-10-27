//
//  AreaPickView.swift
//  Trip
//
//  Created by 贺思佳 on 2017/10/26.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import JavaScriptCore

final class AreaPickView: UIView {
    let pickerViewBtnW: CGFloat = 50.0
    let pickerViewBtnH: CGFloat = 30.0
    typealias SelectCityHandle = ((String, String, String) -> ())?
    
    private var selectCityHandle: SelectCityHandle
    private var defaultAddress: (String?,String?,String?)?
    
    private var cityDataLevel = 3
    private lazy var dataArray: [CityModel] = {
        return AreaPickView.getCityData()!
    }()
    private var cityArray: [CityModel]?
    private var townArray: [CityModel]?
    
    
    private var optionView = UIView()
    private var pickerView = UIPickerView()
    
    init(level: Int,defaultAddress: (String?,String?,String?)?, selectCityHandle: SelectCityHandle) {
        super.init(frame: UIScreen.main.bounds)
        self.cityDataLevel = level
        self.defaultAddress = defaultAddress
        self.selectCityHandle = selectCityHandle
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        cityArray = dataArray.first?.children
        townArray = dataArray.first?.children?.first?.children
        setupOptionView()
        setDefaultAddress()
    }
    
    private func setupOptionView(){
        
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.darkText, for: .normal)
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnClick), for: .touchUpInside)
        
        let doneBtn = UIButton()
        doneBtn.setTitle("确定", for: .normal)
        doneBtn.setTitleColor(UIColor.darkText, for: .normal)
        doneBtn.addTarget(self, action: #selector(self.doneBtnClick), for: .touchUpInside)
        

        
        optionView.addSubview(cancelBtn)
        optionView.addSubview(doneBtn)
        optionView.addSubview(pickerView)
        addSubview(optionView)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        optionView.backgroundColor = UIColor.white
        
        
        let size = pickerView.bounds.size
        
        pickerView.frame = CGRect(x: 0, y: pickerViewBtnH, width: SJScreeW, height: size.height)
        optionView.frame = CGRect(x: 0, y: SJScreeH - size.height, width: SJScreeW, height: size.height)
        cancelBtn.frame = CGRect(x: pickerView.x, y: pickerView.y - pickerViewBtnH, width: pickerViewBtnW, height: pickerViewBtnH)
        doneBtn.frame = CGRect(x: pickerView.maxX - pickerViewBtnW, y: cancelBtn.y, width: pickerViewBtnW, height: pickerViewBtnH)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func cancelBtnClick(){
        removeFromSuperview()
    }
    @objc private func doneBtnClick(){
        if let block = selectCityHandle{
            let province = dataArray[pickerView.selectedRow(inComponent: 0)].text
            let city = cityArray?[pickerView.selectedRow(inComponent: 1)].text ?? ""
            var town = ""
            if pickerView.numberOfComponents == 3{
                town = townArray?[pickerView.selectedRow(inComponent: 2)].text ?? ""
            }
            block(province,city,town)
            selectCityHandle = nil
            cancelBtnClick()
            print(province + city + town)
        }
    }
    
    
    
    //MARK: - 选择地址
    static func showChooseCityView(level: Int = 3, defaultAddress: (String?,String?,String?)? = nil,  selectCityHandle: SelectCityHandle){
        let view = AreaPickView(level: level, defaultAddress: defaultAddress, selectCityHandle: selectCityHandle)

        SJKeyWindow?.addSubview(view)
    
        
    }
    
    private func setDefaultAddress(){
        if let defaultAddress = defaultAddress{
            var rows = [Int]()
            var array = dataArray
            for text in [defaultAddress.0,defaultAddress.1,defaultAddress.2]{
                if let text = text{
                    var provinceIndex: Int? = nil
                    for (index,model) in array.enumerated(){
                        if model.text == text{
                            provinceIndex = index
                            
                            break
                        }
                    }
                    if let provinceIndex = provinceIndex{
                        rows.append(provinceIndex)
                        
                        if array.count > provinceIndex, array[provinceIndex].children != nil{
                            array = array[provinceIndex].children!
                        }
                        
                    }else{
                        break
                    }
                }
            }
            
            if rows.count == 2{
                pickerView.selectRow(rows[0], inComponent: 0, animated: false)
                cityArray = dataArray[rows[0]].children
                pickerView.reloadComponent(1)
                pickerView.selectRow(rows[1], inComponent: 1, animated: false)
            }else if rows.count == 3{
                pickerView.selectRow(rows[0], inComponent: 0, animated: false)
                cityArray = dataArray[rows[0]].children
                pickerView.reloadComponent(1)
                pickerView.selectRow(rows[1], inComponent: 1, animated: false)
                townArray = cityArray![rows[1]].children
                pickerView.reloadComponent(2)
                pickerView.selectRow(rows[2], inComponent: 2, animated: false)
            }
            
        }
    }

}



extension AreaPickView{
    static func getCityData() -> [CityModel]?{
        
        let path = Bundle.main.path(forResource: "address", ofType: "txt")!
                do{
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let models = try JSONDecoder().decode([CityModel].self, from: data)

                    return models
                } catch{
                    print("解析失败")
                    return nil

                }
    }
}

extension AreaPickView: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return cityDataLevel
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let provinceCount = dataArray.count
        let cityCount = cityArray!.count
        let townCount = townArray?.count ?? 0
        return [provinceCount,cityCount,townCount][component]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return dataArray[row].text
        }else if component == 1{
            return cityArray?[row].text
        }else{
            return townArray?[row].text
        }
//        return [dataArray[row].text,cityArray?[row].text,townArray?[row].text][component]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SJScreeW * 0.3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == 0{
            cityArray = dataArray[row].children
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            if pickerView.numberOfComponents == 3{
                townArray = cityArray![0].children
                pickerView.reloadComponent(2)
            }
        }
        
        if component == 1{
            if pickerView.numberOfComponents == 3{
                townArray = cityArray![row].children
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }
        }
        
    }
}

struct CityModel: Codable {
    var value: String
    var text: String
    var children: [CityModel]?
}
