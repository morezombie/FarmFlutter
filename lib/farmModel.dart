import 'farmConfig.dart';

class Animal {
  int ageMonth = 0; // age
  bool isMale = false; // gender
  int feedMonth = 0; // feeding cost per month
  late CounterClerk observer; // the money observer
  int maturedPrice = 0; // selling or buying price for big one

  Animal(this.ageMonth);

  void register(var o) {
    observer = o;
  }

  void growup() {
    ++ageMonth;
    observer.onGrowConsume(feedMonth);
  }

  bool isCub() => ageMonth < config.maturedMonth;

  int estimate() {
    return isCub() ? config.priceCub : maturedPrice;
  }

  int pawn(List<Animal> pack, {bool forced = false}) => 0;

  void getSick() {}
}

class Female extends Animal {
  var isBabyMale = true;
  var birthIndex = -1;
  var monthB4Birth = 0;

  Female(int ageMonth) : super(ageMonth) {
    isMale = false;
    feedMonth = config.feedFemaleMonth;
    maturedPrice = config.priceMaturedFemale;
    final firstBirthDate = config.maturedMonth + config.carryMonth;
    if (ageMonth < firstBirthDate)
      monthB4Birth = firstBirthDate - ageMonth;
    else {
      birthIndex = ((ageMonth - firstBirthDate) / config.birthPeriodMonth) as int;
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
      observer.incomeAnimal.add(newborn);
      print(
          "Congrats! newborn $gender Cub and pack size goes to ${pack.length + 1}");
      isBabyMale = !isBabyMale;
      monthB4Birth = config.birthPeriodMonth;
    }
    ++birthIndex;
  }

  @override
  int pawn(List<Animal> pack, {bool forced = false}) {
    if (!forced && ageMonth < config.maxKeepingMonth) return 0;
    final gold = estimate();
    observer.lostAnimal.add(this);
    observer.onSell(gold);
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
    observer.lostAnimal.add(this);
    observer.onSell(gold);
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
  List<Animal> lostAnimal = [];
  List<Animal> incomeAnimal = [];

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

  CounterClerk({this.money = 0}) {
    reset();
  }

  void reset() {
    money = 0;
    month = 0;
    annualWealth = [];
    annualIncrease = [];
    annualMaturedFemale = [];
    annualCub = [];
    lostAnimal = [];
    incomeAnimal = [];
  }

  int estimate(List<Animal> pack) {
    var gold = 0;
    var female = 0;
    var cub = 0;

    for (var obj in pack) {
      // money aspect
      gold += obj.estimate();
      // animal statistics
      print("[estate] animal age:${obj.ageMonth} price ${obj.estimate()}");
      if (obj.isCub()) {
        ++cub;
      } else if (!obj.isMale) {
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

  void reCount(List<Animal> pack) {
    pack.removeWhere((element) => lostAnimal.contains(element));
    pack.addAll(incomeAnimal);
    lostAnimal.clear();
    incomeAnimal.clear();
  }

  void book(List<Animal> pack) {
    if (month % 12 != 0) return;
    final estate = estimate(pack);
    final wealth = money + estate;
    var increase = 0;
    if (annualWealth.isNotEmpty)
      increase = wealth - annualWealth.last as int;
    else
      increase = 0;
    annualWealth.add(wealth);
    annualIncrease.add(increase);
    print("[estate] money $money and estate $estate makes it $wealth");
  }

  void show() {
    print('annual profit: $annualIncrease');
  }
}

class Farm {
  List<Animal> pack = [];
  var clerk = CounterClerk();

  void reset() {
    clerk.reset();
    pack.clear();
  }

  void addAnimal(bool isMale, int age, {int num = 1, bool buying = true}) {
    var gold = 0;
    if (!buying) gold = 0;
    if (age < config.maturedMonth)
      gold = config.priceCub;
    else if (isMale)
      gold = config.priceMaturedMale;
    else
      gold = config.priceMaturedFemale;

    for (var i = 0; i < num; ++i) {
      var obj;
      if (isMale)
        obj = Male(age);
      else
        obj = Female(age);
      obj.register(clerk);
      pack.add(obj);
      clerk.onBuy(gold);
    }
  }

  void run(int month) {
    clerk.syncWallClock(0);
    clerk.book(pack);
    for (var m = 1; m <= month; ++m) {
      clerk.syncWallClock(m);
      for (var obj in pack) {
        obj.growup();
        if (!obj.isMale) {
          final Female female = obj as Female;
          female.giveBirth(pack, clerk);
        }
        obj.pawn(pack);
        obj.getSick();
      }
      clerk.reCount(pack);
      clerk.book(pack);
    }
    clerk.show();
    print('done');
  }
}
