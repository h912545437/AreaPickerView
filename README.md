# AreaPickerView
	最简单的选择地理位置控件


###使用方法


1 复制AreaPickerView文件夹到项目工程,确保文件夹里面内容被包含到target

2
```
@IBAction func chooseBtnClick() {

    AreaPickView.showChooseCityView { (province, city,            town) in
        self.areaLabel.text = province + " " + city + " "         + town
        }


}

```

