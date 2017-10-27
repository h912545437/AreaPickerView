# AreaPickerView
	最简单的选择地理位置控件


##使用方法


###复制AreaPickerView文件夹到项目工程,确保文件夹里面内容被包含到target

###选择三级地址
```
@IBAction func chooseBtnClick() {
    AreaPickView.showChooseCityView { (province, city, town) in
        self.areaLabel.text = province + " " + city + " " + town
        }

}

```
<img width="35%" height="35%" src="https://github.com/h912545437/AreaPickerView/blob/master/Images/WX20171027-104346@2x.png?raw=true"/>

###选择二级地址
```
@IBAction func chooseBtnClick() {
    AreaPickView.showChooseCityView { (province, city, town) in
        self.areaLabel.text = province + " " + city + " " + town
        }

}

```
<img width="35%" height="35%" src="https://github.com/h912545437/AreaPickerView/blob/master/Images/WX20171027-110406@2x.png?raw=true"/>
