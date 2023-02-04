import 'dart:html';

import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

// for practice dart grammar
// https://dartpad.dev/?

void main() {
  List<int> a = [1, 2, 3, 4];
  List<int> b;
  // 1. 이렇게 쓸수도 있고
  b = a.map((e) => e + 1).toList();
  // 2. 이렇게 쓸수도 있단다.
  b = a.map(
    (e) {
      return e + 1;
    },
  ).toList();
  // 3. 그리고 map 뒤에 <int> 붙일 수 있는데 똑같은거임, 그냥 무슨 타입을 넣는지 참고해주는 역할인듯.... 이거 몰라서 짜증났네
  b = a.map<int>((e) => e + 1).toList();

  // 또 하나 유용한 것으로 generate
  // generate로 반복 연산 없애기
  var t1 = List<String>.generate(5, (int index) {
    return "dad";
  });
  // 물론 아래도 됨
  var t2 = List.generate(5, (int index) {
    return "dad";
  });
}

// 참고로 아래 둘다 똑같은거임
// (e) => (e+1)
// (e) { return e+1 }

Future<List> readJson(String S) async {
  final String response = await rootBundle.loadString("assets/etc/tip.json");
  final data = await json.decode(response);
  debugPrint(data["Manner"]);

  return data["S"];
}
