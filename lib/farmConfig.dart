// market and bio parameters
class FarmConfig {
  var maturedMonth = 18; // 成熟月龄
  var birthPeriodMonth = 16; // 产崽间隔月数
  var carryMonth = 10; // 怀孕月数
  var numPerBirth = 1; // 每胎产崽数量
  var feedFemaleMonth = 120; // 成年雌性每月饲料花费
  var feedMaleMonth = 350; // 成年雄性每月饲料花费
  var priceMaturedMale = 20000; // 成年雄性每头买/卖价格
  var priceMaturedFemale = 17000; // 成年雌性每头买/卖价格
  var priceCub = 12000; // 幼崽每头买/卖价格
  var maxKeepingMonth = 120; // 淘汰月龄

  void restore() {
    maturedMonth = 18;
    birthPeriodMonth = 16;
    carryMonth = 10;
    numPerBirth = 1;
    feedFemaleMonth = 120;
    feedMaleMonth = 350;
    priceMaturedMale = 20000;
    priceMaturedFemale = 17000;
    priceCub = 12000;
    maxKeepingMonth = 120;
  }
}

var config = FarmConfig();
