import 'farmConfig.dart';

final config = FarmConfig();

class Animal {
  var ageMonth = .0; // age
  var isMale = false; // gender
  var feedMonth = 0; // feeding cost per month
  var observer; // the money observer
  var maturedPrice = 0; // selling or buying price for big one
  var newborn = false;

  Animal(this.ageMonth) {
    if (ageMonth == 0) newborn = true;
  }

  void register(var o) {
    observer = o;
  }

  void growup() {
    if (newborn) {
      newborn = !newborn;
      return;
    }
    ++ageMonth;
    if (observer) observer.onGrowConsume(feedMonth);
  }

  bool isCub() => ageMonth < config.maturedMonth;

  int estimate() {
    return isCub() ? config.priceCub : maturedPrice;
  }

  int pawn(List<Animal> pack, {bool forced}) => 0;

  void getSick() {}

}

class Female extends Animal {

  var isBabyMale = true;
  var birthIndex = -1;
  var monthB4Birth = 0;

  Female(var ageMonth) : super(ageMonth) {
    isMale = false;
    feedMonth = config.feedFemaleMonth;
    maturedPrice = config.priceMaturedFemale;
    final firstBirthDate = config.maturedMonth + config.carryMonth;
    if (ageMonth < firstBirthDate)
      monthB4Birth = firstBirthDate - ageMonth;
    else {
      birthIndex = (ageMonth - firstBirthDate) / config.birthPeriodMonth;
      monthB4Birth =
          birthIndex * config.birthPeriodMonth + firstBirthDate - ageMonth;
    }
  }

  @override
  void growup() {
    super.growup();
    --monthB4Birth;
  }


  void giveBirth(List<Animal> pack, var observer) {
    if (monthB4Birth > 0) return;
    for (var i = 0; i < config.numPerBirth; ++i) {
      Animal newborn;
      String gender;
      if (isBabyMale) {
        newborn = Male(0);
        gender = 'male';
      } else {
        newborn = Female(0);
        gender = 'female';
      }
      newborn.register(observer);
      pack.add(this);
      print("Congrats! newborn $gender Cub and pack size goes to ${pack.length}");
      isBabyMale = !isBabyMale;
      monthB4Birth = config.birthPeriodMonth;
    }
    ++birthIndex;
  }

  @override
  int pawn(List<Animal> pack, {bool forced = false}) {
    if (!forced && ageMonth < config.maxKeepingMonth) return 0;
    final gold = estimate();
    pack.remove(this);
    if (observer) observer.onSell(gold);
    return gold;
  }
}

class Male extends Animal {
  Male(var ageMonth) : super(ageMonth) {
    isMale = true;
    feedMonth = config.feedMaleMonth;
    maturedPrice = config.priceMaturedMale;
  }

  @override
  int pawn(List<Animal> pack, {bool forced = false}) {
    if (!forced && isCub()) return 0;
    final gold = estimate();
    pack.remove(this);
    if (observer) observer.onSell(gold);
    return gold;
  }
}


class CounterClerk {
  var money = 0;
  var month = 0;
  var annualWealth = [];
  var annualIncrease = [];
  var annualMaturedFemale = [];
  var annualCub = [];

  void onBuyMedicine() {}

  void onGrowConsume(int gold) {
    money -= gold;
    print("[feeding] cash -$gold, \$$money");
  }

  void onBuy(int gold) {
    money -= gold;
    print("[buying] cash -$gold, \$$money");
  }

  void onSell(int gold) {
    money += gold;
    print("[selling] cash +$gold, \$$money");
  }

  CounterClerk(this.money);

  int estimate(List<Animal> pack) {
    var gold = 0;
    var male = 0;
    var female = 0;
    var cub = 0;

    for (var obj in pack) {
      // money aspect
      gold += obj.estimate();
      // animal statistics
      print("[estate] animal age:${obj.ageMonth} price ${obj.estimate()}");
      if (obj.isCub()) {
        ++cub;
      } else if (obj.isMale) {
        ++male;
      } else {
        ++female;
      }
    }
    annualMaturedFemale.add(female);
    annualCub.add(cub);
    return gold;
  }

  void syncWallClock(int month) {
    this.month = month;
    print("At the end of Month $month");
  }

  void book(List<Animal> pack) {
    if (month % 12 != 0) return;
    final estate = estimate(pack);
    final wealth = money + estate;
    var increase = 0;
    if (annualWealth.isNotEmpty) increase = wealth - annualWealth[-1];
    else increase = 0;
    annualWealth.add(wealth);
    annualIncrease.add(increase);
    print("[estate] money $money and estate $estate makes it $wealth");
  }

  void show() {}
}


class Farm {
  List<Animal> pack;
  CounterClerk clerk;

  void addAnimal(bool isMale, int age, {int num = 1, bool buying = true}) {
    var gold = 0;
    if (!buying) gold = 0;
    if (age < config.maturedMonth) gold = config.priceCub;
    else if (isMale) gold = config.priceMaturedMale;
    else gold = config.priceMaturedFemale;

    for (var i = 0; i < num; ++i) {
      var obj;
      if (isMale) obj = Male(age);
      else obj = Female(age);
      obj.register(clerk);
      pack.add(obj);
      clerk.onBuy(gold);
    }
  }


  void run(int month) {
    clerk.syncWallClock(0);
    clerk.book(pack);
    for (var m = 1; m <= month; ++m) {
      clerk.syncWallClock(m + 1);
      for (var obj in pack) {
        obj.growup();
        if (!obj.isMale) {
          final Female female = obj;
          female.giveBirth(pack, clerk);
        }
        obj.pawn(pack);
        obj.getSick();
      }
      clerk.book(pack);
    }
    clerk.show();
    print('done');
  }
}