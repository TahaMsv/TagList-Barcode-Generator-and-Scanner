import 'classes.dart';
import 'package:dio/dio.dart';

Future<String?> login() async {
  Response response;
  var dio = Dio();
  response = await dio.post(
    'https://brs-api.abomis.com/default',
    data: {
      "Body": {
        "Execution": "Login",
        "Request": {
          "Domain": "App Mobile",
          "Company": "APPLE",
          "Model": "IPHONE9,1",
          "IsWifi": true,
          "Username": "SamZoji",
          "Password": "1bea20e1df19b12013976de2b5e0e3d1fb4ba088b59fe53642c324298b21ffd9",
          "AppName": "W&B",
          "OSVersion": "14.6",
          "VersionNum": "10.0",
          "Device": "IOS",
          "DeviceID": "CBB3D0AE-1747-4058-B241-D4C55E7124A9",
          "VersionJSNum": 20,
          "IsApplication": true,
          "FlavorName": "Abomis"
        }
      }
    },
  );

  String? token;
  if (response.statusCode == 200) {
    if (response.data["Status"] == 1) {
      token = response.data["Body"]["Token"];
    }
  }
  return token;
}

Future<List> getFlightList() async {
  List flightsLists = [];

  Future<String?> token = login();
  Response response;
  var dio = Dio();
  response = await dio.post(
    'https://brs-api.abomis.com/default',
    data: {
      "Body": {
        "Token": token,
        "Execution": "FlightList",
        "Request": {"Date": "2022-08-01", "Airport": "IST", "AL": "JI"}
      }
    },
  );

  if (response.statusCode == 200) {
    if (response.data["Status"] == 1) {
      flightsLists = response.data["Body"];
    }
  }

  return flightsLists;
}

Future<List> getFlightTagList(String token, String flightScheduleID) async {
  List tagList = [];
  Response response;
  var dio = Dio();
  response = await dio.post(
    'https://brs-api.abomis.com/default',
    data: {
      "Body": {
        "Body": {
          "Token": "B42C9DFF-86F7-424D-9FBB-4B41CF4E747A",
          "Execution": "FlightDetails",
          "Request": {"FlightScheduleID": flightScheduleID, "Position": null, "Airport": "IST"},
        }
      }
    },
  );

  if (response.statusCode == 200) {
    if (response.data["Status"] == 1) {
      tagList = response.data["Body"]["TagList"];
    }
  }
  return tagList;
}

String convertFormattedStringToJson(String formattedString) {
  String result = "";
  Map<int, Map<String, List<String>>> mapOfAllTags = new Map();
  Map<int, int> numberOfTagsByPositionNumber = new Map();
  Map<String, int> numberOfTagsByContainerCode = new Map();

  List<String> separatedByCurrentPosition = formattedString.split("}");
  int numberOfTags = int.parse(separatedByCurrentPosition[0].split(",")[0]);
  String stemOfStems = separatedByCurrentPosition[0].split(",")[1];

  separatedByCurrentPosition.removeWhere((element) => element == "");

  TagInformation tagInformation = TagInformation(tagList: []);
  tagInformation.tagList = [];
  for (var i = 1; i < separatedByCurrentPosition.length; ++i) {
    // print("*************************${i}*****************************");
    int currentPosition = int.parse(separatedByCurrentPosition[i].substring(0, separatedByCurrentPosition[i].indexOf("=")));
    mapOfAllTags[currentPosition] = new Map();
    numberOfTagsByPositionNumber[currentPosition] = 0;
    // print("currentPosition: " + currentPosition.toString());
    List<String> containerCodesAndTagNumbers = separatedByCurrentPosition[i].substring(separatedByCurrentPosition[i].indexOf("=") + 1).split("{");
    containerCodesAndTagNumbers.removeWhere((element) => element == "");

    for (var j = 0; j < containerCodesAndTagNumbers.length; ++j) {
      // print("/////////////////////////////${j}////////////////////////");

      String containerCode = containerCodesAndTagNumbers[j].substring(0, containerCodesAndTagNumbers[j].indexOf("="));
      mapOfAllTags[currentPosition]![containerCode] = [];
      numberOfTagsByContainerCode[containerCode] = 0;
      List<String> stemAndTagNumbers = containerCodesAndTagNumbers[j].substring(containerCodesAndTagNumbers[j].indexOf("=") + 1).split(":");
      String stem = stemOfStems + stemAndTagNumbers[0];
      String oddTagNumbers = stemAndTagNumbers[1];
      String tagNumbersRange = convertToNormalRange(oddTagNumbers);

      List<String> compressedTagNumbers = tagNumbersRange.split(",");
      List<String> tagNumbers = [];
      for (var k = 0; k < compressedTagNumbers.length; ++k) {
        if (compressedTagNumbers[k].contains("_")) {
          String startNumber = compressedTagNumbers[k].split("_")[0];
          String endNumber = compressedTagNumbers[k].split("_")[1];

          int l = compressedTagNumbers[k].split("_")[1].length;

          int s = int.parse(startNumber);
          int e = int.parse(endNumber);

          for (var m = s; m <= e; ++m) {
            String mString = m.toString().padLeft(l, "0");
            tagNumbers.add(mString);
            // stdout.write(mString+",");
          }
        } else {
          tagNumbers.add(compressedTagNumbers[k]);
          // stdout.write(compressedTagNumbers[k]+",");
        }
      }
      // print(tagNumbers);
      for (var k = 0; k < tagNumbers.length; ++k) {
        if (!tagNumbers[k].startsWith("-")) {
          tagNumbers[k] = stem + tagNumbers[k];
        }
        // print("currentPosition: " + currentPosition.toString());
        // print("tagNumbers: " + tagNumbers[k]);
        // print("containerCode: " + containerCode);
        // print("//////////");
        mapOfAllTags[currentPosition]![containerCode]!.add(tagNumbers[k]);
        numberOfTagsByPositionNumber[currentPosition] = numberOfTagsByPositionNumber[currentPosition]! + 1;
        numberOfTagsByContainerCode[containerCode] = numberOfTagsByContainerCode[containerCode]! + 1;

        TagList tagList = TagList(
          currentPosition: currentPosition,
          tagNumber: tagNumbers[k],
          tagPositions: [
            containerCode == "!" ? TagPosition(containerCode: null) : TagPosition(containerCode: containerCode),
          ],
        );
        tagInformation.tagList!.add(tagList);
      }

      // print("tagNumbers after adding stem: " + tagNumbers.toString());
    }
  }

  print("Total  number of tags: ${numberOfTags}");
  result += "Total  number of tags: ${numberOfTags}\n";
  print("////////////////////////////////////////");
  result += "////////////////////////////////////////\n";
  numberOfTagsByPositionNumber.forEach((k, v) {
    print("Position number : $k => tags: $v");
    result += "P N: $k => tags: $v\n";
  });

  print("////////////////////////////////////////");
  result += "////////////////////////////////////////\n";
  numberOfTagsByContainerCode.forEach((k, v) {
    if (k == "!") k = "null";
    print("Container Code : $k => tags: $v");
    result += "C C: $k => tags: $v\n";
  });

  return result;
}

String convertToNormalRange(String oddTagNumbers) {
  String tagNumbersRange = "";
  for (var k = 0; k < oddTagNumbers.length; ++k) {
    String ch = oddTagNumbers.substring(k, k + 1);
    if (ch.contains(new RegExp('^[a-z]+'))) {
      // print(oddTagNumbers.substring(k, k + 1));
      int lengthOfEnd = 0;
      switch (ch) {
        case "a":
          lengthOfEnd = 0;
          break;
        case "b":
          lengthOfEnd = 1;
          break;
        case "c":
          lengthOfEnd = 2;
          break;
        case "d":
          lengthOfEnd = 3;
          break;
        case "e":
          lengthOfEnd = 4;
          break;
        case "f":
          lengthOfEnd = 5;
          break;
        case "g":
          lengthOfEnd = 6;
          break;
        case "h":
          lengthOfEnd = 7;
          break;
        case "i":
          lengthOfEnd = 8;
          break;
        case "j":
          lengthOfEnd = 9;
          break;
        case "k":
          lengthOfEnd = 10;
          break;
        case "l":
          lengthOfEnd = 11;
          break;
      }
      String end = tagNumbersRange.substring(tagNumbersRange.length - lengthOfEnd);
      tagNumbersRange = tagNumbersRange.substring(0, tagNumbersRange.length - lengthOfEnd) + (lengthOfEnd == 0 ? "" : "_") + end + ",";
    } else {
      tagNumbersRange += ch;
    }
  }
  if (tagNumbersRange == "") {
    return tagNumbersRange;
  } else {
    List<String> oddTagNumbersList = tagNumbersRange.split(",");
    List<String> tagNumbersList = [];
    if (oddTagNumbersList.length > 0) {
      bool firstRange = true;
      int maxLengthOfNumber = oddTagNumbersList[0].contains("_") ? oddTagNumbersList[0].split("_")[0].length : oddTagNumbersList[0].length;
      int lastNumber = int.parse((oddTagNumbersList[0].contains("_") ? oddTagNumbersList[0].split("_")[0] : oddTagNumbersList[0]));
      String lastNumberString = lastNumber.toString().padLeft(maxLengthOfNumber, "0");
      String start, end;

      for (var i = 0; i < oddTagNumbersList.length; ++i) {
        var tn = oddTagNumbersList[i];
        if (tn.contains("_")) {
          start = tn.split("_")[0];
          end = tn.split("_")[1];
          if (firstRange) {
            firstRange = false;
            end = start.substring(0, maxLengthOfNumber - end.length) + end;
          } else {
            start = lastNumberString.substring(0, maxLengthOfNumber - start.length) + start;
            lastNumber = int.parse(start);
            lastNumberString = lastNumber.toString().padLeft(maxLengthOfNumber, "0");
            end = lastNumberString.substring(0, maxLengthOfNumber - end.length) + end;
          }
          tagNumbersList.add(start + "_" + end);
        } else {
          start = end = tn;
          if (firstRange) {
            firstRange = false;
          } else {
            start = end = lastNumberString.substring(0, maxLengthOfNumber - end.length) + end;
          }
          tagNumbersList.add(end);
        }
        lastNumber = int.parse(end);
        lastNumberString = lastNumber.toString().padLeft(maxLengthOfNumber, "0");
        // print("start: " + start + " , " + "end: " + end + " , " + "lastNumberString: " + lastNumberString);
      }
    }
    return tagNumbersList.join(",");
  }

  return tagNumbersRange;
}
