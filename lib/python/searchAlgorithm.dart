List<String> searchPhoneNumbers(
  List<String> phoneNumber,
  String queryText,
) {
  List<String> finalList = [];
  List<String> beginningList = [];
  for (int i = 0; i < phoneNumber.length; i++) {
    if (phoneNumber[i].contains(queryText)) {
      beginningList.add(phoneNumber[i]);
    }
  }
  List<String> tempList = [];
  List<String> tempList2 = [];
  tempList2.addAll(phoneNumber);
  for (int i = 0; i < 10 - queryText.length; i++) {
    int total = tempList2.length;
    tempList = [];
    for (int k = 0; k < total; k++) {
      if (tempList2[k].substring(i, i + queryText.length) == queryText) {
        tempList.add(tempList2[k]);
        tempList2.remove(tempList2[k]);
        k--;
        total--;
      }
    }
    tempList.sort();
    finalList = finalList + tempList;
  }
  return finalList;
}

List<int> searchNames(List<String> phoneNumber, String queryText, int Longest, bool haveAlreadyInitiated) {
  List<String> finalList = [];
  int highest = 0;
  List<int> answer = [];
  if (queryText == "" || !(haveAlreadyInitiated)) {
    for (int i = 0; i < phoneNumber.length; i++) {
      answer.add(i);
    }
    return answer;
  } else {
    List<String> tempList = [];
    List<String> tempList2 = [];
    tempList2.addAll(phoneNumber);
    for (int i = 0; i < Longest - queryText.length; i++) {
      int total = tempList2.length;
      tempList = [];
      for (int k = 0; k < total; k++) {
        if (tempList2[k].substring(i, i + queryText.length) == queryText) {
          tempList.add(tempList2[k]);
          tempList2.remove(tempList2[k]);
          k--;
          total--;
        }
      }
      tempList.sort();
      finalList = finalList + tempList;
    }
  }
  for (int i = 0; i < finalList.length; i++) {
    answer.add(phoneNumber.indexOf(finalList[i]));
  }
  return answer;
}

