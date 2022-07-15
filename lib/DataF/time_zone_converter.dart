import 'dart:ffi';

class TimeZoneConverter {
  static Map<int, Duration> tzMap = {
    -43200: Duration(hours: -12),
    -39600: Duration(hours: -11),
    -36000: Duration(hours: -10),
    -34200: Duration(hours: -9, minutes: -30),
    -32400: Duration(hours: -9),
    -28800: Duration(hours: -8),
    -25200: Duration(hours: -7),
    -21600: Duration(hours: -6),
    -18000: Duration(hours: -5),
    -16200: Duration(hours: -4, minutes: -30),
    -14400: Duration(hours: -4),
    -12600: Duration(hours: -3, minutes: -30),
    -10800: Duration(hours: -3),
    -7200: Duration(hours: -2),
    -3600: Duration(hours: -1),
    0: Duration(hours: 0),
    3600: Duration(hours: 1),
    7200: Duration(hours: 2),
    10800: Duration(hours: 3),
    12600: Duration(hours: 3, minutes: -30),
    14400: Duration(hours: 4),
    16200: Duration(hours: 4, minutes: -30),
    18000: Duration(hours: 5),
    19800: Duration(hours: 5, minutes: -30),
    20700: Duration(hours: 5, minutes: 45),
    21600: Duration(hours: 6),
    23400: Duration(hours: 6, minutes: 30),
    25200: Duration(hours: 7),
    28800: Duration(hours: 8),
    32400: Duration(hours: 9),
    34200: Duration(hours: 09, minutes: 30),
    36000: Duration(hours: 10),
    37800: Duration(hours: 10, minutes: 30),
    39600: Duration(hours: 11),
    41400: Duration(hours: 11, minutes: 30),
    43200: Duration(hours: 12),
    45900: Duration(hours: 12, minutes: 45),
    46800: Duration(hours: 13),
    50400: Duration(hours: 14)
  } as Map<int, Duration>;

  static DateTime convert(int index) {
    DateTime dtUtc = DateTime.now().toUtc();

    try {
      // var flag = tzMap.containsKey(index);
      // int y = 0;

      if (tzMap.containsKey(index)) {
        Duration dur = tzMap[index]!;
        DateTime dtRes = dtUtc.add(dur);
        return dtRes;
      }
    } catch (e) {
      print(e);
    }

    return dtUtc;
  }
}

/*
-43200	Международное западное время	-12:00
-39600	Острова Мидуэй, Американское Самоа	-11:00
-36000	Гавайи	-10:00
-34200	Французская Полинезия, Маркизские острова	-09:30
-32400	Аляска	-09:00
-28800	Тихоокеанское время (США и Канада)	-08:00
-25200	Горное время (США и Канада)	-07:00
-21600	Центральное время (США и Канада), Мехико	-06:00
-18000	Восточное время (США и Канада)	-05:00
-16200	Венесуэла	-04:30
-14400	Среднеатлантическое время (Канада), Сантьяго	-04:00
-12600	Ньюфаундленд (Канада)	-03:30
-10800	Гренландия, Бразилия, Монтевидео	-03:00
-7200	Центрально-Атлантическое время	-02:00
-3600	Азорские острова	-01:00
0	GMT: Дублин, Эдинбург, Лиссабон, Лондон	00:00
3600	Амстердам, Берлин, Рим, Вена, Прага, Брюссель	+01:00
7200	Афины, Стамбул, Бейрут, Каир, Иерусалим	+02:00
10800	Санкт-Петербург, Минск, Багдад, Москва	+03:00
12600	Иран	+03:30
14400	Волгоград, Баку, Ереван	+04:00
16200	Афганистан	+04:30
18000	Екатеринбург, Ташкент	+05:00
19800	Ченнай, Калькутта, Мумбаи, Нью-Дели	+05:30
20700	Непал	+05:45
21600	Омск, Алматы	+06:00
23400	Мьянма и Кокосовые острова	+06:30
25200		+07:00
28800	Красноярск, Улан-Батор, Перт	+08:00
32400	Иркутск	+09:00
34200	Стандартное время центральной Австралии	+09:30
36000	Якутск, Канберра, Мельбурн, Сидней, Хобарт	+10:00
37800	Остров Лорд-Хау (Австралия)	+10:30
39600	Владивосток, Соломоновы Острова, Новая Каледония	+11:00
41400	Остров Норфолк (Австралия)	+11:30
43200	Магадан, Окленд, Веллингтон	+12:00
45900	Новая Зеландия, архипелаг Чатем	+12:45
46800	Нуку-алофа	+13:00
50400	Кирибати, острова Лайн	+14:00
*/